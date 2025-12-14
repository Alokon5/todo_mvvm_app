import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/utils/snackbar.dart';
import 'package:todo_mvvm_app/features/auth/controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
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
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20, color: theme.iconTheme.color),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text('Create Account',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.headlineMedium?.color)),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Text('Join us today! Create your account to get started.',
                    style: TextStyle(
                        fontSize: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),

                const SizedBox(height: 48),

                // Email
                _buildLabel('Email Address'),
                const SizedBox(height: 8),
                _buildTextField(
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  onChanged: (value) => controller.email.value = value,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // Password
                _buildLabel('Password'),
                const SizedBox(height: 8),
                Obx(() => _buildTextField(
                      hint: 'Create a strong password',
                      icon: Icons.lock_outline,
                      obscureText: !controller.isRegPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(controller.isRegPasswordVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        onPressed: controller.toggleRegPasswordVisibility,
                      ),
                      onChanged: (value) => controller.password.value = value,
                    )),
                const SizedBox(height: 8),
                _buildInfoText('Use 8+ characters with letters, numbers & symbols'),

                const SizedBox(height: 24),

                // Confirm Password
                _buildLabel('Confirm Password'),
                const SizedBox(height: 8),
                Obx(() => _buildTextField(
                      hint: 'Re-enter your password',
                      icon: Icons.lock_reset_outlined,
                      obscureText: !controller.isConfirmVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(controller.isConfirmVisible.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                        onPressed: controller.toggleConfirmVisibility,
                      ),
                      onChanged: (value) => controller.confirmPassword.value = value,
                    )),

                const SizedBox(height: 24),

                // Terms
                Obx(() => _buildTermsCheckbox(controller, colorScheme)),

                const SizedBox(height: 24),

                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? _buildErrorBanner(controller.errorMessage.value, theme)
                    : const SizedBox.shrink()),

                const SizedBox(height: 32),

                // Register Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isRegisterFormValid && !controller.isLoading.value
                            ? controller.register
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Create Account',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    )),

                const SizedBox(height: 32),

                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
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

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Get.theme;
    return Container(
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
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7)),
          suffixIcon: suffixIcon,
        ),
        style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    final theme = Get.theme;
    return Row(
      children: [
        Icon(Icons.info_outline_rounded,
            size: 16, color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
        const SizedBox(width: 6),
        Text(text,
            style:
                TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color?.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildTermsCheckbox(AuthController controller, ColorScheme colorScheme) {
    final theme = Get.theme;
    return Row(
      children: [
        GestureDetector(
          onTap: controller.toggleTerms,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: controller.isTermsAccepted.value ? colorScheme.primary : theme.cardColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color:
                      controller.isTermsAccepted.value ? colorScheme.primary : theme.dividerColor,
                  width: 2),
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
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), fontSize: 14),
              children: [
                TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                const TextSpan(text: ' and '),
                TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String message, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(color: Colors.red[700], fontSize: 14))),
        ],
      ),
    );
  }
}
