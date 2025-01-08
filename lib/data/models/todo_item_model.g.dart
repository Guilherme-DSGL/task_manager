// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoItemModelImpl _$$TodoItemModelImplFromJson(Map<String, dynamic> json) =>
    _$TodoItemModelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: (json['isCompleted'] as num).toInt(),
    );

Map<String, dynamic> _$$TodoItemModelImplToJson(_$TodoItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
    };
