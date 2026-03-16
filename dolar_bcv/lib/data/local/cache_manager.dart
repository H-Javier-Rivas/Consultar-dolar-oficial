import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exchange_rate_model.dart';

class CacheManager {
  static const String _kRateKey = 'cached_exchange_rate';
  static const String _kTotalsKey = 'cached_totals';
  static const String _kThemeKey = 'is_dark_mode';

  Future<void> saveRate(ExchangeRateModel rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRateKey, jsonEncode(rate.toJson()));
  }

  Future<ExchangeRateModel?> getCachedRate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString(_kRateKey);

    if (dataString != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(dataString);
        return ExchangeRateModel.fromJson(data, fromCache: true);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // To persist the totals Bs/USD exactly like localStorage 'dolarOficialState' in JS
  Future<void> saveTotals({required double bolivares}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kTotalsKey, bolivares);
  }

  Future<double> getCachedTotals() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kTotalsKey) ?? 0.0;
  }

  // Theme Persistence
  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kThemeKey, isDarkMode);
  }

  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kThemeKey) ?? true; // Default to dark mode
  }
}
