import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdDate;

  @HiveField(4)
  DateTime updatedDate;

  @HiveField(5)
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.updatedDate,
    required this.isCompleted,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdDate,
    DateTime? updatedDate,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
