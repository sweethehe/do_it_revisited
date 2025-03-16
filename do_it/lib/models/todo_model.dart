import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isCompleted;

  TodoModel({required this.id, required this.content, this.isCompleted = false});

  void toggleStatus() {
    isCompleted = !isCompleted;
    save();
  }
}