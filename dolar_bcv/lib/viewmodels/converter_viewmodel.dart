import 'package:flutter/material.dart';
import '../data/local/cache_manager.dart';
import '../data/local/database_helper.dart';
import '../data/models/exchange_rate_model.dart';
import '../data/models/history_entry_model.dart';
import '../data/services/exchange_rate_service.dart';

class ConverterViewModel extends ChangeNotifier {
  final ExchangeRateService _apiService;
  final CacheManager _cacheManager;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TextEditingController inputController = TextEditingController();

  // State
  ExchangeRateModel? _exchangeRate;
  bool _isOffline = false;
  bool _isLoading = true;

  double _totalBs = 0.0;
  String _inputValue = '';
  bool _isBsMode = true; // true = Bs -> USD, false = USD -> Bs

  // Getters
  ExchangeRateModel? get exchangeRate => _exchangeRate;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;
  double get totalBs => _totalBs;
  double get totalUsd => _totalBs / (_exchangeRate?.promedio ?? 1.0);
  String get inputValue => _inputValue;
  bool get isBsMode => _isBsMode;

  double get computedSubtotalBs {
    final val = double.tryParse(_inputValue) ?? 0.0;
    if (_isBsMode) return val; // Already in Bs
    return val * (_exchangeRate?.promedio ?? 1.0); // USD to Bs
  }

  ConverterViewModel(this._apiService, this._cacheManager) {
    _init();
  }

  Future<void> _init() async {
    _totalBs = await _cacheManager.getCachedTotals();
    await fetchRate();
  }

  Future<void> fetchRate() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exchangeRate = await _apiService.getOfficialRate();
      _isOffline = false;
      await _cacheManager.saveRate(_exchangeRate!);
    } catch (e) {
      // Offline fallback
      _isOffline = true;
      _exchangeRate = await _cacheManager.getCachedRate();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      rateUsed: _exchangeRate?.promedio ?? 1.0,
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
      rateUsed: _exchangeRate?.promedio ?? 1.0,
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
    await _cacheManager.saveTotals(bolivares: 0.0);
    notifyListeners();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
