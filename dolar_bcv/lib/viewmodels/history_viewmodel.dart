import 'package:flutter/foundation.dart';
import '../data/local/database_helper.dart';
import '../data/models/history_entry_model.dart';

class HistoryViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper;

  List<HistoryEntryModel> _entries = [];
  bool _isLoading = false;

  List<HistoryEntryModel> get entries => _entries;
  bool get isLoading => _isLoading;

  HistoryViewModel({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper.instance {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    _entries = await _dbHelper.getAllHistory();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _dbHelper.clearHistory();
    _entries.clear();
    notifyListeners();
  }
}
