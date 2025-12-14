import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final Todo todo = Get.arguments as Todo;
    final TodoController controller = Get.find();
    final TextEditingController titleController = TextEditingController(text: todo.title);
    final TextEditingController descController = TextEditingController(text: todo.description);

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Task',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 1,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Task',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.headlineMedium?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Make changes to your task below',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          if (value != null) {
                            controller.toggleCompletion(todo);
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        activeColor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todo.isCompleted ? 'Completed' : 'Pending',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: todo.isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Title Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Title *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
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
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.title_rounded,
                            color: theme.iconTheme.color?.withOpacity(0.7)),
                      ),
                      style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Description Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
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
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: 'Enter task description',
                        hintStyle: TextStyle(color: theme.hintColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.description_rounded,
                            color: theme.iconTheme.color?.withOpacity(0.7)),
                      ),
                      style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                      maxLines: 4,
                      minLines: 3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      final updatedTodo = todo.copyWith(
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                      );
                      controller.updateTodo(updatedTodo);
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 4,
                    shadowColor: theme.shadowColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Update Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.dividerColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Delete Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.deleteTodo(todo.id);
                    Get.back();
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text(
                    'Delete Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(isDark ? 0.5 : 0.3)),
                    backgroundColor: Colors.red.withOpacity(isDark ? 0.15 : 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Created/Updated Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Information',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
                        const SizedBox(width: 8),
                        Text(
                          'Created: ${todo.createdDate.toString().substring(0, 16)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (todo.updatedDate != todo.createdDate)
                      Row(
                        children: [
                          Icon(Icons.update_rounded,
                              size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
                          const SizedBox(width: 8),
                          Text(
                            'Updated: ${todo.updatedDate.toString().substring(0, 16)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
