import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart';
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';
import 'package:todo_mvvm_app/features/todo/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

enum TodoStatus { all, pending, completed }

class TodoController extends GetxController {
  final TodoRepository _repo = TodoRepository();

  final RxList<Todo> todos = <Todo>[].obs;

  // Form fields
  final RxString title = ''.obs;
  final RxString description = ''.obs;

  final RxBool isLoading = false.obs;

  // Search & Filter
  final RxString searchQuery = ''.obs;
  final Rx<TodoStatus> filterStatus = TodoStatus.all.obs;

  bool get isTitleValid => title.value.trim().isNotEmpty;
  bool get isFormValid => isTitleValid;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    ever(searchQuery, (_) => _applyFilters());
    ever(filterStatus, (_) => _applyFilters());
  }

  Future<void> loadTodos() async {
    isLoading.value = true;
    final allTodos = await _repo.getAllTodos();
    todos.value = allTodos;
    _applyFilters();
    isLoading.value = false;
  }

  void _applyFilters() async {
    final fullList = await _repo.getAllTodos();

    var filtered = fullList;

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where((todo) =>
              todo.title.toLowerCase().contains(query) ||
              todo.description.toLowerCase().contains(query))
          .toList();
    }

    if (filterStatus.value != TodoStatus.all) {
      final bool targetCompleted = filterStatus.value == TodoStatus.completed;
      filtered = filtered.where((t) => t.isCompleted == targetCompleted).toList();
    }

    todos.value = filtered;
  }

  Future<void> addTodo() async {
    if (!isFormValid) {
      Snackbar.error('Task title cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      final newTodo = Todo(
        id: const Uuid().v4(),
        title: title.value.trim(),
        description: description.value.trim(),
        isCompleted: false,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );

      await _repo.addTodo(newTodo);
      await loadTodos();
      clearForm();
      Get.back();
      Snackbar.success('Task added successfully');
    } catch (e) {
      Snackbar.error('Failed to add task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTodo(Todo originalTodo) async {
    if (!isFormValid) {
      Snackbar.error('Task title cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      final updatedTodo = originalTodo.copyWith(
        title: title.value.trim(),
        description: description.value.trim(),
        updatedDate: DateTime.now(),
      );

      await _repo.updateTodo(updatedTodo);
      await loadTodos();
      Get.back();
      Snackbar.success('Task updated successfully');
    } catch (e) {
      Snackbar.error('Failed to update task');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleCompletion(Todo todo) async {
    final updated = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedDate: DateTime.now(),
    );
    await _repo.updateTodo(updated);
    await loadTodos();
    Snackbar.info(updated.isCompleted ? 'Task completed!' : 'Task marked as pending');
  }

  Future<void> deleteTodo(String id) async {
    final deletedTodo = todos.firstWhereOrNull((t) => t.id == id);
    await _repo.deleteTodo(id);
    await loadTodos();
    Snackbar.warning('Task deleted', title: deletedTodo?.title ?? 'Task');
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

  void prepareForEdit(Todo todo) {
    title.value = todo.title;
    description.value = todo.description;
  }

  void clearForm() {
    title.value = '';
    description.value = '';
  }

  void logout() {
    Get.find<AuthController>().logout();
  }
}
