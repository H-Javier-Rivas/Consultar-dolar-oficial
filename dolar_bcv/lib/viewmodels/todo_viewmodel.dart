import 'package:flutter/foundation.dart';
import '../data/local/database_helper.dart';
import '../data/models/todo_item_model.dart';

class TodoViewModel extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<TodoItemModel> _todos = [];
  bool _isLoading = false;

  List<TodoItemModel> get todos => _todos;
  bool get isLoading => _isLoading;

  TodoViewModel() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    _todos = await _dbHelper.getAllTodos();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String text) async {
    if (text.trim().isEmpty) return;

    final newTodo = TodoItemModel(text: text.trim());
    final id = await _dbHelper.insertTodo(newTodo);
    
    // Refresh list locally
    _todos.insert(0, TodoItemModel(id: id, text: newTodo.text, isDone: newTodo.isDone));
    notifyListeners();
  }

  Future<void> toggleTodo(TodoItemModel todo) async {
    final updatedTodo = TodoItemModel(
      id: todo.id,
      text: todo.text,
      isDone: !todo.isDone,
    );
    
    await _dbHelper.updateTodo(updatedTodo);
    
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  Future<void> deleteDone() async {
    await _dbHelper.deleteDoneTodos();
    _todos.removeWhere((t) => t.isDone);
    notifyListeners();
  }

  void sort() {
    // Sort logic mimics HTML version: Unchecked first, checked later
    _todos.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
    notifyListeners();
  }
}
