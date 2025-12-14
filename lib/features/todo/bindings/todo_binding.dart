import 'package:get/get.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(() => TodoController());
  }
}
