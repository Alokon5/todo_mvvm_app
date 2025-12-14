import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todo_mvvm_app/core/constant.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart';
import 'package:todo_mvvm_app/features/auth/models/user_model.dart';
import 'package:todo_mvvm_app/features/auth/repositories/auth_repository.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';
import 'package:todo_mvvm_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isRegPasswordVisible = false.obs;
  final RxBool isConfirmVisible = false.obs;
  final RxBool isTermsAccepted = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkSession();
  }

  Future<void> checkSession() async {
    final sessionBox = await Hive.openBox(Constants.sessionBox);
    final loggedInEmail = sessionBox.get(Constants.sessionKey);
    isLoggedIn.value = loggedInEmail != null;
  }

  Future<void> register(String email, String password) async {
    errorMessage.value = '';
    final success = await _repo.register(User(email: email, password: password));
    if (success) {
      await login(email, password);
    } else {
      errorMessage.value = 'Email already exists';
    }
  }

  Future<void> login(String email, String password) async {
    errorMessage.value = '';
    final user = await _repo.getUser(email);
    if (user != null && user.password == password) {
      final sessionBox = await Hive.openBox(Constants.sessionBox);
      await sessionBox.put(Constants.sessionKey, email);
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.todoList);
      Snackbar.success('Login successfull!');
    } else {
      errorMessage.value = 'Invalid email or password';
    }
  }

  Future<void> logout() async {
    final sessionBox = await Hive.openBox(Constants.sessionBox);
    await sessionBox.clear();
    isLoggedIn.value = false;
    if (Get.isRegistered<TodoController>()) {
      final todoController = Get.find<TodoController>();
      await todoController.clearAllTodos();
    }
    Get.offAllNamed(AppRoutes.login);
    Snackbar.success('Logout successfully!');
  }
}
