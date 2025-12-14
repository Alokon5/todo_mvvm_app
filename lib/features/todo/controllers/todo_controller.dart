import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart'; // <-- Import your modern Snackbar
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';
import 'package:todo_mvvm_app/features/todo/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

enum TodoStatus { all, pending, completed }

class TodoController extends GetxController {
  final TodoRepository _repo = TodoRepository();
  final RxList<Todo> todos = <Todo>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<TodoStatus> filterStatus = TodoStatus.all.obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    ever(searchQuery, (_) => filterTodos());
    ever(filterStatus, (_) => filterTodos());
  }

  Future<void> loadTodos() async {
    todos.value = await _repo.getAllTodos();
  }

  Future<void> addTodo(String title, String? description) async {
    if (title.trim().isEmpty) {
      Snackbar.error('Task title cannot be empty');
      return;
    }

    final todo = Todo(
      id: const Uuid().v4(),
      title: title.trim(),
      description: description?.trim() ?? '',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      isCompleted: false,
    );

    await _repo.addTodo(todo);
    await loadTodos();

    Snackbar.success('Task added successfully');
  }

  Future<void> updateTodo(Todo todo) async {
    final updatedTodo = todo.copyWith(updatedDate: DateTime.now());
    await _repo.updateTodo(updatedTodo);
    await loadTodos();

    Snackbar.success('Task updated successfully');
  }

  Future<void> toggleCompletion(Todo todo) async {
    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedDate: DateTime.now(),
    );
    await _repo.updateTodo(updatedTodo);
    await loadTodos();

    Snackbar.info(
      todo.isCompleted ? 'Task marked as pending' : 'Task completed!',
    );
  }

  Future<void> deleteTodo(String id) async {
    // Optional: Find the todo for better message
    final deletedTodo = todos.firstWhereOrNull((t) => t.id == id);

    await _repo.deleteTodo(id);
    await loadTodos();

    Snackbar.warning(
      'Task deleted',
      title: deletedTodo?.title ?? 'Task',
    );
  }

  Future<void> clearAllTodos() async {
    if (todos.isEmpty) {
      Snackbar.info('No tasks to clear');
      return;
    }

    await _repo.clearAllTodos();
    todos.clear();

    Snackbar.success('All tasks cleared');
  }

  void filterTodos() {
    _repo.getAllTodos().then((fullList) {
      var filtered = fullList;

      // Apply search
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        filtered = filtered
            .where((todo) =>
                todo.title.toLowerCase().contains(query) ||
                todo.description.toLowerCase().contains(query))
            .toList();
      }

      // Apply status filter
      if (filterStatus.value != TodoStatus.all) {
        final bool targetCompleted = filterStatus.value == TodoStatus.completed;
        filtered = filtered.where((todo) => todo.isCompleted == targetCompleted).toList();
      }

      todos.value = filtered;
    });
  }

  void logout() {
    Get.find<AuthController>().logout();
  }
}
