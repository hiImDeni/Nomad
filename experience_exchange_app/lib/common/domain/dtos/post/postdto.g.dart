// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postdto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDto _$PostDtoFromJson(Map<String, dynamic> json) {
  return PostDto(
    json['uid'] as String,
    json['mediaUrl'] as String,
    json['text'] as String,
    json['upvotes'] as int,
  );
}

Map<String, dynamic> _$PostDtoToJson(PostDto instance) => <String, dynamic>{
      'uid': instance.uid,
      'mediaUrl': instance.mediaUrl,
      'text': instance.text,
      'upvotes': instance.upvotes,
    };
