import 'package:flutter/material.dart';
import '../data/local/cache_manager.dart';
import '../data/local/database_helper.dart';
import '../data/models/exchange_rate_model.dart';
import '../data/models/history_entry_model.dart';
import '../data/services/exchange_rate_service.dart';

enum RateSource { bcv, usdt, custom }

class ConverterViewModel extends ChangeNotifier {
  final ExchangeRateService _apiService;
  final CacheManager _cacheManager;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TextEditingController inputController = TextEditingController();
  final TextEditingController customRateController = TextEditingController();

  // State
  ExchangeRateModel? _officialRate;
  ExchangeRateModel? _parallelRate;
  double _customRateValue = 0.0;
  RateSource _activeSource = RateSource.bcv;

  bool _isOffline = false;
  bool _isLoading = true;

  double _totalBs = 0.0;
  String _inputValue = '';
  bool _isBsMode = true; // true = Bs -> USD, false = USD -> Bs

  // Getters
  RateSource get activeSource => _activeSource;
  double get customRateValue => _customRateValue;
  
  double get currentRate {
    switch (_activeSource) {
      case RateSource.bcv:
        return _officialRate?.promedio ?? 1.0;
      case RateSource.usdt:
        return _parallelRate?.promedio ?? 1.0;
      case RateSource.custom:
        return _customRateValue > 0 ? _customRateValue : 1.0;
    }
  }

  ExchangeRateModel? get exchangeRate => _activeSource == RateSource.bcv ? _officialRate : _parallelRate;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;
  double get totalBs => _totalBs;
  double get totalUsd => _totalBs / currentRate;
  String get inputValue => _inputValue;
  bool get isBsMode => _isBsMode;

  double get computedSubtotalBs {
    final val = double.tryParse(_inputValue) ?? 0.0;
    if (_isBsMode) return val; // Already in Bs
    return val * currentRate; // USD to Bs
  }

  double get computedSubtotalUsd => computedSubtotalBs / currentRate;

  ConverterViewModel(this._apiService, this._cacheManager) {
    _init();
  }

  Future<void> _init() async {
    _totalBs = await _cacheManager.getCachedTotals();
    await fetchRates();
  }

  Future<void> fetchRates() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch both in parallel
      final results = await Future.wait([
        _apiService.getOfficialRate(),
        _apiService.getParallelRate(),
      ]);

      _officialRate = results[0];
      _parallelRate = results[1];
      _isOffline = false;

      await _cacheManager.saveRate(_officialRate!, isOfficial: true);
      await _cacheManager.saveRate(_parallelRate!, isOfficial: false);
    } catch (e) {
      _isOffline = true;
      _officialRate = await _cacheManager.getCachedRate(isOfficial: true);
      _parallelRate = await _cacheManager.getCachedRate(isOfficial: false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setRateSource(RateSource source) {
    _activeSource = source;
    notifyListeners();
  }

  void updateCustomRate(String val) {
    _customRateValue = double.tryParse(val) ?? 0.0;
    notifyListeners();
  }

  void updateInput(String val) {
    if (double.tryParse(val) != null && double.parse(val) < 0) return;
    _inputValue = val;
    notifyListeners();
  }

  void toggleCurrencyMode() {
    _isBsMode = !_isBsMode;
    notifyListeners();
  }

  Future<void> addToTotal() async {
    final subtotal = computedSubtotalBs;
    if (subtotal <= 0) return;

    _totalBs += subtotal;
    await _cacheManager.saveTotals(bolivares: _totalBs);
    
    // Save to history
    await _dbHelper.insertHistory(HistoryEntryModel(
      amountBs: subtotal,
      rateUsed: currentRate,
      operation: '+',
      sessionDate: DateTime.now().toIso8601String(),
    ));

    _inputValue = '';
    inputController.clear();
    notifyListeners();
  }

  Future<void> subtractFromTotal() async {
    final subtotal = computedSubtotalBs;
    if (subtotal <= 0) return;

    if (_totalBs - subtotal < 0) return; // Prevent negative totals

    _totalBs -= subtotal;
    await _cacheManager.saveTotals(bolivares: _totalBs);
    
    // Save to history
    await _dbHelper.insertHistory(HistoryEntryModel(
      amountBs: subtotal, // Save positive amount, sign is in operation
      rateUsed: currentRate,
      operation: '-',
      sessionDate: DateTime.now().toIso8601String(),
    ));

    _inputValue = '';
    inputController.clear();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _totalBs = 0.0;
    _inputValue = '';
    inputController.clear();
    customRateController.clear();
    _customRateValue = 0.0;
    await _cacheManager.saveTotals(bolivares: 0.0);
    notifyListeners();
  }

  @override
  void dispose() {
    inputController.dispose();
    customRateController.dispose();
    super.dispose();
  }
}
