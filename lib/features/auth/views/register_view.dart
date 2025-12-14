import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart'; // Your modern Snackbar
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    bool isValidEmail(String email) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    }

    void attemptRegister() {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (email.isEmpty) {
        Snackbar.error('Please enter your email address');
        return;
      }

      if (!isValidEmail(email)) {
        Snackbar.error('Please enter a valid email address');
        return;
      }

      if (password.isEmpty) {
        Snackbar.error('Please create a password');
        return;
      }

      if (password.length < 8) {
        Snackbar.error('Password must be at least 8 characters long');
        return;
      }

      if (password != confirmPassword) {
        Snackbar.error('Passwords do not match');
        return;
      }

      if (!controller.isTermsAccepted.value) {
        Snackbar.warning('You must agree to the Terms & Conditions');
        return;
      }

      controller.register(email, password);
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
                // Back button and title
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20, color: theme.iconTheme.color),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Join us today! Create your account to get started.',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 48),

                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email Address',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: theme.shadowColor.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
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

                // Password field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: theme.shadowColor.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Obx(() => TextField(
                            controller: passwordController,
                            obscureText: !controller.isRegPasswordVisible.value,
                            decoration: InputDecoration(
                              hintText: 'Create a strong password',
                              hintStyle: TextStyle(color: theme.hintColor),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: theme.iconTheme.color?.withOpacity(0.7)),
                              suffixIcon: GestureDetector(
                                onTap: () => controller.isRegPasswordVisible.toggle(),
                                child: Icon(
                                  controller.isRegPasswordVisible.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: theme.iconTheme.color?.withOpacity(0.7),
                                ),
                              ),
                            ),
                            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                          )),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16, color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
                        const SizedBox(width: 6),
                        Text('Use 8+ characters with letters, numbers & symbols',
                            style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Confirm Password',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: theme.shadowColor.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Obx(() => TextField(
                            controller: confirmPasswordController,
                            obscureText: !controller.isConfirmVisible.value,
                            decoration: InputDecoration(
                              hintText: 'Re-enter your password',
                              hintStyle: TextStyle(color: theme.hintColor),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              prefixIcon: Icon(Icons.lock_reset_outlined,
                                  color: theme.iconTheme.color?.withOpacity(0.7)),
                              suffixIcon: GestureDetector(
                                onTap: () => controller.isConfirmVisible.toggle(),
                                child: Icon(
                                  controller.isConfirmVisible.value
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

                const SizedBox(height: 24),

                Obx(() => Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.isTermsAccepted.toggle(),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: controller.isTermsAccepted.value
                                  ? colorScheme.primary
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: controller.isTermsAccepted.value
                                      ? colorScheme.primary
                                      : theme.dividerColor,
                                  width: 2),
                              boxShadow: [
                                BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1)),
                              ],
                            ),
                            child: controller.isTermsAccepted.value
                                ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                                  fontSize: 14),
                              children: [
                                TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                        color: colorScheme.primary, fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        color: colorScheme.primary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),

                const SizedBox(height: 24),

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
                                child: Text(controller.errorMessage.value,
                                    style: TextStyle(color: Colors.red[700], fontSize: 14))),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                const SizedBox(height: 32),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: attemptRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 4,
                      shadowColor: theme.shadowColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Create Account',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 32),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                              fontSize: 15)),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Sign In',
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
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
