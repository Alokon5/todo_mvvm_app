import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart';
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';
import 'package:todo_mvvm_app/routes/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final RxBool isPasswordVisible = false.obs;

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    bool isValidEmail(String email) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    }

    void attemptLogin() {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty) {
        Snackbar.error('Please enter your email address');
        return;
      }

      if (!isValidEmail(email)) {
        Snackbar.error('Please enter a valid email address');
        return;
      }

      if (password.isEmpty) {
        Snackbar.error('Please enter your password');
        return;
      }

      controller.login(email, password);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineMedium?.color,
                        )),
                    const SizedBox(height: 8),
                    Text('Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                        )),
                  ],
                ),

                const SizedBox(height: 48),

                // Email Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email Address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyMedium?.color,
                        )),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: theme.hintColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          prefixIcon: Icon(Icons.email_outlined,
                              color: theme.iconTheme.color?.withOpacity(0.7)),
                        ),
                        style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Password Field with Toggle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyMedium?.color,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(() => TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: theme.hintColor),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: theme.iconTheme.color?.withOpacity(0.7)),
                              suffixIcon: GestureDetector(
                                onTap: () => isPasswordVisible.toggle(),
                                child: Icon(
                                  isPasswordVisible.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: theme.iconTheme.color?.withOpacity(0.7),
                                ),
                              ),
                            ),
                            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red
                              .withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(color: Colors.red[700], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                const SizedBox(height: 32),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: attemptLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 4,
                      shadowColor: theme.shadowColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Create Account Link
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            fontSize: 15,
                          )),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.register),
                        child: Text('Create Account',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
