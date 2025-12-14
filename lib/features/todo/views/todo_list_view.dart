import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_mvvm_app/core/controllers/theme_controller.dart';
import 'package:todo_mvvm_app/features/todo/controllers/todo_controller.dart';
import 'package:todo_mvvm_app/features/todo/models/todo_model.dart';
import 'package:todo_mvvm_app/routes/app_routes.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find();
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    void setFilter(TodoStatus status) {
      if (controller.filterStatus.value != status) {
        controller.filterStatus.value = status;
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 1,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  Get.find<ThemeController>().isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
                )),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, color: theme.iconTheme.color),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
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
                onChanged: (value) => controller.searchQuery.value = value,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search todos...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search_rounded, color: theme.iconTheme.color),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: [
                    _buildModernFilterChip(
                      context: context,
                      label: 'All',
                      isSelected: controller.filterStatus.value == TodoStatus.all,
                      onTap: () => setFilter(TodoStatus.all),
                      selectedColor: colorScheme.primary,
                    ),
                    _buildModernFilterChip(
                      context: context,
                      label: 'Pending',
                      isSelected: controller.filterStatus.value == TodoStatus.pending,
                      onTap: () => setFilter(TodoStatus.pending),
                      selectedColor: Colors.orange,
                    ),
                    _buildModernFilterChip(
                      context: context,
                      label: 'Completed',
                      isSelected: controller.filterStatus.value == TodoStatus.completed,
                      onTap: () => setFilter(TodoStatus.completed),
                      selectedColor: Colors.green,
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              final displayedTodos = controller.todos;

              if (displayedTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.checklist_rounded,
                          size: 50,
                          color: theme.disabledColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No todos yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add one by tapping the + button',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: displayedTodos.length,
                itemBuilder: (context, index) {
                  final todo = displayedTodos[index];
                  return _buildModernTodoCard(
                    todo: todo,
                    controller: controller,
                    theme: theme,
                    colorScheme: colorScheme,
                    isDark: isDark,
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addTodo),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildModernFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color selectedColor,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.15) : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : theme.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(isSelected ? 0.2 : 0.05),
              blurRadius: isSelected ? 6 : 4,
              offset: Offset(0, isSelected ? 2 : 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) Icon(Icons.check_rounded, size: 16, color: selectedColor),
            if (isSelected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? selectedColor : theme.textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTodoCard({
    required Todo todo,
    required TodoController controller,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    final textColor = todo.isCompleted ? theme.disabledColor : theme.textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(AppRoutes.editTodo, arguments: todo),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => controller.toggleCompletion(todo),
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
                        todo.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor?.withOpacity(0.8),
                            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 14, color: theme.iconTheme.color?.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            'Created: ${todo.createdDate.toString().substring(0, 16)}',
                            style: TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                      if (todo.updatedDate != todo.createdDate) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.update_rounded,
                                size: 14, color: theme.iconTheme.color?.withOpacity(0.6)),
                            const SizedBox(width: 4),
                            Text(
                              'Updated: ${todo.updatedDate.toString().substring(0, 16)}',
                              style:
                                  TextStyle(fontSize: 12, color: theme.textTheme.bodySmall?.color),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: theme.iconTheme.color?.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
