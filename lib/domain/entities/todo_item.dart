import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item.freezed.dart';
part 'todo_item.g.dart';

@freezed
class TodoItem with _$TodoItem {
  const factory TodoItem({
    required String title,
    required String description,
    required bool isCompleted,
  }) = _TodoItem;

  factory TodoItem.fromJson(Map<String, Object?> json) =>
      _$TodoItemFromJson(json);
}
