import 'package:hive/hive.dart';
import 'package:todo_mvvm_app/core/constant.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';

class TodoRepository {
  Future<Box<Todo>> _openTodosBox() async {
    return await Hive.openBox<Todo>(Constants.todosBox);
  }

  Future<List<Todo>> getAllTodos() async {
    final box = await _openTodosBox();
    return box.values.toList();
  }

  Future<void> addTodo(Todo todo) async {
    final box = await _openTodosBox();
    await box.put(todo.id, todo);
  }

  Future<void> updateTodo(Todo todo) async {
    final box = await _openTodosBox();
    await box.put(todo.id, todo);
  }

  Future<void> deleteTodo(String id) async {
    final box = await _openTodosBox();
    await box.delete(id);
  }

  Future<void> clearAllTodos() async {
    final box = await _openTodosBox();
    await box.clear();
  }
}
