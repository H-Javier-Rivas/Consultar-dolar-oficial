import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dolar_bcv/viewmodels/todo_viewmodel.dart';
import 'package:dolar_bcv/data/local/database_helper.dart';
import 'package:dolar_bcv/data/models/todo_item_model.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class FakeTodoItemModel extends Fake implements TodoItemModel {}

void main() {
  late TodoViewModel viewModel;
  late MockDatabaseHelper mockDatabaseHelper;

  setUpAll(() {
    registerFallbackValue(FakeTodoItemModel());
  });

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    
    // Mock inicial: lista vacía
    when(() => mockDatabaseHelper.getAllTodos()).thenAnswer((_) async => []);
    
    viewModel = TodoViewModel(dbHelper: mockDatabaseHelper);
  });

  group('TodoViewModel', () {
    test('Debe cargar tareas al inicializar', () async {
      final initialTodos = [
        TodoItemModel(id: 1, text: 'Test 1', isDone: false),
        TodoItemModel(id: 2, text: 'Test 2', isDone: true),
      ];
      
      when(() => mockDatabaseHelper.getAllTodos()).thenAnswer((_) async => initialTodos);
      
      await viewModel.loadTodos();
      
      expect(viewModel.todos.length, 2);
      expect(viewModel.todos[0].text, 'Test 1');
      expect(viewModel.isLoading, false);
    });

    test('addTodo debe insertar en BD y actualizar lista local', () async {
      when(() => mockDatabaseHelper.insertTodo(any())).thenAnswer((_) async => 10);
      
      await viewModel.addTodo('Nueva Tarea');
      
      expect(viewModel.todos.length, 1);
      expect(viewModel.todos[0].text, 'Nueva Tarea');
      expect(viewModel.todos[0].id, 10);
      verify(() => mockDatabaseHelper.insertTodo(any())).called(1);
    });

    test('toggleTodo debe actualizar estado y persistir en BD', () async {
      final todo = TodoItemModel(id: 1, text: 'Tarea', isDone: false);
      viewModel.todos.add(todo); // Simular carga inicial
      
      when(() => mockDatabaseHelper.updateTodo(any())).thenAnswer((_) async => 1);
      
      await viewModel.toggleTodo(todo);
      
      expect(viewModel.todos[0].isDone, true);
      verify(() => mockDatabaseHelper.updateTodo(any())).called(1);
    });

    test('deleteDone debe limpiar tareas completadas de la lista y la BD', () async {
      viewModel.todos.addAll([
        TodoItemModel(id: 1, text: 'T1', isDone: true),
        TodoItemModel(id: 2, text: 'T2', isDone: false),
      ]);
      
      when(() => mockDatabaseHelper.deleteDoneTodos()).thenAnswer((_) async => 1);
      
      await viewModel.deleteDone();
      
      expect(viewModel.todos.length, 1);
      expect(viewModel.todos[0].text, 'T2');
      verify(() => mockDatabaseHelper.deleteDoneTodos()).called(1);
    });
  });
}
