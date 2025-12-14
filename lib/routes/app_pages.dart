import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/features/auth/bindings/auth_binding.dart';
import 'package:todo_mvvm_app/features/auth/views/login_view.dart';
import 'package:todo_mvvm_app/features/auth/views/register_view.dart';
import 'package:todo_mvvm_app/features/todo/bindings/todo_binding.dart';
import 'package:todo_mvvm_app/features/todo/views/add_todo_view.dart';
import 'package:todo_mvvm_app/features/todo/views/edit_todo_view.dart';
import 'package:todo_mvvm_app/features/todo/views/todo_list_view.dart';
import 'package:todo_mvvm_app/routes/app_routes.dart';

import '../features/auth/controllers/auth_controller.dart';

class AppPages {
  static String initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.todoList,
      page: () => const TodoListView(),
      binding: TodoBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addTodo,
      page: () => const AddTodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: AppRoutes.editTodo,
      page: () => const EditTodoView(),
      binding: TodoBinding(),
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      return RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
