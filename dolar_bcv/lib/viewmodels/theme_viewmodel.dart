import 'package:flutter/material.dart';
import '../data/local/cache_manager.dart';

class ThemeViewModel extends ChangeNotifier {
  final CacheManager _cacheManager;
  bool _isDarkMode = true;

  ThemeViewModel(this._cacheManager) {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadTheme() async {
    _isDarkMode = await _cacheManager.getThemeMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _cacheManager.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
}
