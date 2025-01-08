import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item_model.freezed.dart';
part 'todo_item_model.g.dart';

@freezed
class TodoItemModel with _$TodoItemModel {
  const factory TodoItemModel({
    int? id,
    required String title,
    required String description,
    required int isCompleted,
  }) = _TodoItemModel;

  factory TodoItemModel.fromJson(Map<String, Object?> json) =>
      _$TodoItemModelFromJson(json);
}
