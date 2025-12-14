import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends GetxController {
  static const String _themeBox = 'theme_box';
  static const String _themeKey = 'is_dark_mode';

  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBox);
    isDarkMode.value = box.get(_themeKey, defaultValue: false);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final box = await Hive.openBox(_themeBox);
    await box.put(_themeKey, isDarkMode.value);
  }
}
