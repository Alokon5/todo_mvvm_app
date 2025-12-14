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

  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;

  final RxBool isRegPasswordVisible = false.obs;
  final RxBool isConfirmVisible = false.obs;
  final RxBool isLoginPasswordVisible = false.obs;

  final RxBool isTermsAccepted = false.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  bool get isEmailValid => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.value.trim());

  bool get isPasswordValid => password.value.length >= 8;

  bool get isConfirmPasswordValid =>
      password.value == confirmPassword.value && confirmPassword.value.isNotEmpty;

  bool get isRegisterFormValid =>
      email.value.trim().isNotEmpty &&
      isEmailValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      isTermsAccepted.value;

  bool get isLoginFormValid =>
      email.value.trim().isNotEmpty && isEmailValid && password.value.isNotEmpty;

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

  void clearError() => errorMessage.value = '';

  Future<void> register() async {
    clearError();
    isLoading.value = true;

    try {
      final success =
          await _repo.register(User(email: email.value.trim(), password: password.value));
      if (success) {
        await login();
      } else {
        errorMessage.value = 'Email already exists';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    clearError();
    isLoading.value = true;

    try {
      final user = await _repo.getUser(email.value.trim());
      if (user != null && user.password == password.value) {
        final sessionBox = await Hive.openBox(Constants.sessionBox);
        await sessionBox.put(Constants.sessionKey, email.value.trim());
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.todoList);
        Snackbar.success('Login successful!');
      } else {
        errorMessage.value = 'Invalid email or password';
      }
    } finally {
      isLoading.value = false;
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

    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    isTermsAccepted.value = false;

    Get.offAllNamed(AppRoutes.login);
    Snackbar.success('Logged out successfully!');
  }

  void toggleRegPasswordVisibility() => isRegPasswordVisible.toggle();
  void toggleConfirmVisibility() => isConfirmVisible.toggle();
  void toggleLoginPasswordVisibility() => isLoginPasswordVisible.toggle();
  void toggleTerms() => isTermsAccepted.toggle();
}
