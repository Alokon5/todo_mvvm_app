import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<TodoController>();
    controller.clearForm();

    titleCtrl = TextEditingController(text: controller.title.value);
    descCtrl = TextEditingController(text: controller.description.value);

    titleCtrl.addListener(() => controller.title.value = titleCtrl.text);
    descCtrl.addListener(() => controller.description.value = descCtrl.text);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title:
            const Text('Add New Task', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create a new task',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Fill in the details below to add a new task',
                style: TextStyle(
                    fontSize: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),
            const SizedBox(height: 40),
            _buildLabel('Task Title *'),
            const SizedBox(height: 8),
            _buildTextField(
                controller: titleCtrl,
                hint: 'Enter task title',
                icon: Icons.title_rounded,
                maxLines: 1),
            const SizedBox(height: 4),
            Text('Required field', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 24),
            _buildLabel('Description'),
            const SizedBox(height: 8),
            _buildTextField(
                controller: descCtrl,
                hint: 'Enter task description (optional)',
                icon: Icons.description_rounded,
                maxLines: 4,
                minLines: 3),
            const SizedBox(height: 4),
            Text('Add more details about your task',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 40),
            Obx(() => _buildPrimaryButton(
                  text: controller.isLoading.value ? 'Saving...' : 'Save Task',
                  onPressed: controller.isFormValid && !controller.isLoading.value
                      ? controller.addTodo // ← Just call the method
                      : null,
                )),
            const SizedBox(height: 16),
            _buildOutlinedButton('Cancel', () => Get.back()),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int minLines = 1,
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
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.hintColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7)),
        ),
        style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
      ),
    );
  }

  Widget _buildPrimaryButton({required String text, VoidCallback? onPressed}) {
    final theme = Get.theme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onPressed) {
    final theme = Get.theme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color)),
      ),
    );
  }
}
