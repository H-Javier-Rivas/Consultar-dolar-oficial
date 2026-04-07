import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dolar_bcv/viewmodels/converter_viewmodel.dart';
import 'package:dolar_bcv/data/services/exchange_rate_service.dart';
import 'package:dolar_bcv/data/local/cache_manager.dart';
import 'package:dolar_bcv/data/local/database_helper.dart';
import 'package:dolar_bcv/data/models/exchange_rate_model.dart';
import 'package:dolar_bcv/data/models/history_entry_model.dart'; 

class MockExchangeRateService extends Mock implements ExchangeRateService {}
class MockCacheManager extends Mock implements CacheManager {}
class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class FakeExchangeRateModel extends Fake implements ExchangeRateModel {}
class FakeHistoryEntryModel extends Fake implements HistoryEntryModel {}

void main() {
  late ConverterViewModel viewModel;
  late MockExchangeRateService mockApiService;
  late MockCacheManager mockCacheManager;
  late MockDatabaseHelper mockDatabaseHelper;

  setUpAll(() {
    registerFallbackValue(FakeExchangeRateModel());
    registerFallbackValue(FakeHistoryEntryModel());
  });

  setUp(() {
    mockApiService = MockExchangeRateService();
    mockCacheManager = MockCacheManager();
    mockDatabaseHelper = MockDatabaseHelper();

    // Comportamiento base
    when(() => mockCacheManager.getCachedTotals()).thenAnswer((_) async => 100.0);
    when(() => mockApiService.getOfficialRate()).thenAnswer((_) async => ExchangeRateModel(
      promedio: 40.0, fechaActualizacion: 'Hoy'
    ));
    when(() => mockApiService.getParallelRate()).thenAnswer((_) async => ExchangeRateModel(
      promedio: 45.0, fechaActualizacion: 'Hoy'
    ));
    when(() => mockCacheManager.saveRate(any(), isOfficial: any(named: 'isOfficial')))
        .thenAnswer((_) async => true);

    viewModel = ConverterViewModel(mockApiService, mockCacheManager, dbHelper: mockDatabaseHelper);
  });

  group('Lógica de Conversión', () {
    test('Debe inicializar con totales desde el caché', () async {
      await Future.delayed(Duration.zero); // Esperar a que termine _init
      expect(viewModel.totalBs, 100.0);
    });

    test('Cálculo de subtotal Bs -> USD correcto (Modo Bs activo)', () {
      viewModel.updateInput('80'); // 80 Bs
      // Tasa BCV = 40.0 (por defecto)
      // 80 Bs / 40.0 = 2.0 USD
      expect(viewModel.computedSubtotalBs, 80.0);
      expect(viewModel.computedSubtotalUsd, 2.0);
    });

    test('Cálculo de subtotal USD -> Bs correcto (Modo USD activo)', () {
      viewModel.toggleCurrencyMode(); // Cambiar a entrada USD
      viewModel.updateInput('2'); // 2 USD
      // 2 USD * 40.0 = 80 Bs
      expect(viewModel.computedSubtotalBs, 80.0);
      expect(viewModel.computedSubtotalUsd, 2.0);
    });

    test('Cambio de tasa afecta cálculos inmediatamente', () {
      viewModel.setRateSource(RateSource.usdt); // Cambiar a Paralelo (45.0)
      viewModel.updateInput('90'); 
      // 90 Bs / 45.0 = 2.0 USD
      expect(viewModel.computedSubtotalUsd, 2.0);
    });
  });

  group('Operaciones de Totales e Historial', () {
    test('Sumar al total debe actualizar caché e insertar en BD', () async {
      when(() => mockCacheManager.saveTotals(bolivares: any(named: 'bolivares')))
          .thenAnswer((_) async => true);
      when(() => mockDatabaseHelper.insertHistory(any()))
          .thenAnswer((_) async => 1);

      viewModel.updateInput('40'); // 40 Bs
      await viewModel.addToTotal();

      // Total anterior era 100 + 40 = 140
      expect(viewModel.totalBs, 140.0);
      verify(() => mockCacheManager.saveTotals(bolivares: 140.0)).called(1);
      verify(() => mockDatabaseHelper.insertHistory(any())).called(1);
      expect(viewModel.inputValue, ''); // El input debe limpiarse
    });

    test('Limpiar todo debe resetear el estado y el caché', () async {
      when(() => mockCacheManager.saveTotals(bolivares: 0.0))
          .thenAnswer((_) async => true);
      
      await viewModel.clearAll();
      
      expect(viewModel.totalBs, 0.0);
      expect(viewModel.inputValue, '');
      verify(() => mockCacheManager.saveTotals(bolivares: 0.0)).called(1);
    });
  });

  group('Manejo de Errores y Modo Offline', () {
    test('Si la API falla, debe intentar cargar tasas del caché', () async {
      // Forzar fallo de API
      when(() => mockApiService.getOfficialRate()).thenThrow(Exception('Error de red'));
      when(() => mockCacheManager.getCachedRate(isOfficial: true)).thenAnswer((_) async => ExchangeRateModel(
        promedio: 39.0, fechaActualizacion: 'Ayer'
      ));
      when(() => mockCacheManager.getCachedRate(isOfficial: false)).thenAnswer((_) async => ExchangeRateModel(
        promedio: 44.0, fechaActualizacion: 'Ayer'
      ));

      await viewModel.fetchRates();

      expect(viewModel.isOffline, true);
      expect(viewModel.currentRate, 39.0);
    });
  });
}
