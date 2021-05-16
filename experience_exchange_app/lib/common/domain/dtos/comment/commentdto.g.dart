// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentdto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) {
  return CommentDto(
    json['postId'] as String,
    json['uid'] as String,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['text'] as String,
  );
}

Map<String, dynamic> _$CommentDtoToJson(CommentDto instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'uid': instance.uid,
      'date': instance.date?.toIso8601String(),
      'text': instance.text,
    };
