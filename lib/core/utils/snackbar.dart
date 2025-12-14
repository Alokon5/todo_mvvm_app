import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbar {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onTap,
  }) {
    final ColorScheme colorScheme = Get.theme.colorScheme;
    final bool isDark = Get.isDarkMode;

    late Color backgroundColor;
    late Color foregroundColor;
    late IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green.shade600;
        foregroundColor = Colors.white;
        icon = Icons.check_circle_rounded;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red.shade600;
        foregroundColor = Colors.white;
        icon = Icons.error_rounded;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange.shade600;
        foregroundColor = Colors.white;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackbarType.info:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        icon = Icons.info_rounded;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor.withOpacity(0.95),
      colorText: foregroundColor,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: duration,
      animationDuration: const Duration(milliseconds: 600),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: foregroundColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: foregroundColor, size: 28),
      ),
      shouldIconPulse: true,
      mainButton: onTap != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onTap();
              },
              child: Text(
                'DISMISS',
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            )
          : null,
      titleText: Text(
        title,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: foregroundColor.withOpacity(0.95),
          fontSize: 14,
        ),
      ),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  // Convenience methods
  static void success(String message, {String title = 'Success'}) {
    show(title: title, message: message, type: SnackbarType.success);
  }

  static void error(String message, {String title = 'Error'}) {
    show(title: title, message: message, type: SnackbarType.error);
  }

  static void warning(String message, {String title = 'Warning'}) {
    show(title: title, message: message, type: SnackbarType.warning);
  }

  static void info(String message, {String title = 'Info'}) {
    show(title: title, message: message, type: SnackbarType.info);
  }
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
}
