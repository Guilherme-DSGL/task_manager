// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodoItemModel _$TodoItemModelFromJson(Map<String, dynamic> json) {
  return _TodoItemModel.fromJson(json);
}

/// @nodoc
mixin _$TodoItemModel {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this TodoItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoItemModelCopyWith<TodoItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoItemModelCopyWith<$Res> {
  factory $TodoItemModelCopyWith(
          TodoItemModel value, $Res Function(TodoItemModel) then) =
      _$TodoItemModelCopyWithImpl<$Res, TodoItemModel>;
  @useResult
  $Res call({int? id, String title, String description, int isCompleted});
}

/// @nodoc
class _$TodoItemModelCopyWithImpl<$Res, $Val extends TodoItemModel>
    implements $TodoItemModelCopyWith<$Res> {
  _$TodoItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoItemModelImplCopyWith<$Res>
    implements $TodoItemModelCopyWith<$Res> {
  factory _$$TodoItemModelImplCopyWith(
          _$TodoItemModelImpl value, $Res Function(_$TodoItemModelImpl) then) =
      __$$TodoItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String title, String description, int isCompleted});
}

/// @nodoc
class __$$TodoItemModelImplCopyWithImpl<$Res>
    extends _$TodoItemModelCopyWithImpl<$Res, _$TodoItemModelImpl>
    implements _$$TodoItemModelImplCopyWith<$Res> {
  __$$TodoItemModelImplCopyWithImpl(
      _$TodoItemModelImpl _value, $Res Function(_$TodoItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(_$TodoItemModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoItemModelImpl implements _TodoItemModel {
  const _$TodoItemModelImpl(
      {this.id,
      required this.title,
      required this.description,
      required this.isCompleted});

  factory _$TodoItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoItemModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int isCompleted;

  @override
  String toString() {
    return 'TodoItemModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, isCompleted);

  /// Create a copy of TodoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoItemModelImplCopyWith<_$TodoItemModelImpl> get copyWith =>
      __$$TodoItemModelImplCopyWithImpl<_$TodoItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoItemModelImplToJson(
      this,
    );
  }
}

abstract class _TodoItemModel implements TodoItemModel {
  const factory _TodoItemModel(
      {final int? id,
      required final String title,
      required final String description,
      required final int isCompleted}) = _$TodoItemModelImpl;

  factory _TodoItemModel.fromJson(Map<String, dynamic> json) =
      _$TodoItemModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get isCompleted;

  /// Create a copy of TodoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoItemModelImplCopyWith<_$TodoItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
