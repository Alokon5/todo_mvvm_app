import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';

class EditTodoView extends StatefulWidget {
  const EditTodoView({super.key});

  @override
  State<EditTodoView> createState() => _EditTodoViewState();
}

class _EditTodoViewState extends State<EditTodoView> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late Todo todo;

  @override
  void initState() {
    super.initState();
    todo = Get.arguments as Todo;
    final controller = Get.find<TodoController>();
    controller.prepareForEdit(todo);

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
        title: const Text('Edit Task', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Task', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Make changes to your task below',
                style: TextStyle(
                    fontSize: 16, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),
            const SizedBox(height: 24),
            _buildStatusCard(todo, controller, theme, colorScheme),
            const SizedBox(height: 24),
            _buildLabel('Task Title *'),
            const SizedBox(height: 8),
            _buildTextField(
                controller: titleCtrl,
                hint: 'Enter task title',
                icon: Icons.title_rounded,
                maxLines: 1),
            const SizedBox(height: 24),
            _buildLabel('Description'),
            const SizedBox(height: 8),
            _buildTextField(
                controller: descCtrl,
                hint: 'Enter task description',
                icon: Icons.description_rounded,
                maxLines: 4,
                minLines: 3),
            const SizedBox(height: 40),
            Obx(() => _buildPrimaryButton(
                  text: controller.isLoading.value ? 'Updating...' : 'Update Task',
                  onPressed: controller.isFormValid && !controller.isLoading.value
                      ? () => controller.updateTodo(todo) // ← Pass the original todo
                      : null,
                )),
            const SizedBox(height: 16),
            _buildOutlinedButton('Cancel', () => Get.back()),
            const SizedBox(height: 24),
            _buildDeleteButton(() {
              controller.deleteTodo(todo.id);
              Get.back();
            }, theme),
            const SizedBox(height: 24),
            _buildInfoCard(todo, theme),
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

  Widget _buildStatusCard(
      Todo todo, TodoController controller, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) =>
                  controller.updateTodo(todo.copyWith(isCompleted: !todo.isCompleted)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              activeColor: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Task Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  todo.isCompleted ? 'Completed' : 'Pending',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: todo.isCompleted ? Colors.green : Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback onPressed, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.delete_outline_rounded, size: 20),
        label:
            const Text('Delete Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.withOpacity(isDark ? 0.5 : 0.3)),
          backgroundColor: Colors.red.withOpacity(isDark ? 0.15 : 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Todo todo, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Task Information',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
              const SizedBox(width: 8),
              Text('Created: ${todo.createdDate.toString().substring(0, 16)}',
                  style: TextStyle(
                      fontSize: 14, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),
            ],
          ),
          if (todo.updatedDate != todo.createdDate)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.update_rounded,
                      size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
                  const SizedBox(width: 8),
                  Text('Updated: ${todo.updatedDate.toString().substring(0, 16)}',
                      style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
