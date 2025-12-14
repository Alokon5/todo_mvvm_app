import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Ensure this is imported
import 'package:todo_mvvm_app/core/controllers/theme_controller.dart';
import 'package:todo_mvvm_app/core/hive_init.dart'; // Your init function
import 'package:todo_mvvm_app/core/theme/app_theme.dart';
import 'package:todo_mvvm_app/features/auth/bindings/auth_binding.dart';
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';
import 'package:todo_mvvm_app/features/auth/models/user_model.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';
import 'package:todo_mvvm_app/routes/app_pages.dart';
import 'package:todo_mvvm_app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(UserAdapter());

  final authController = Get.put(AuthController());

  await authController.checkSession();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      final authController = Get.find<AuthController>();

      return GetMaterialApp(
        title: 'Todo App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        initialRoute: authController.isLoggedIn.value ? AppRoutes.todoList : AppRoutes.login,
        getPages: AppPages.routes,
        initialBinding: AuthBinding(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
