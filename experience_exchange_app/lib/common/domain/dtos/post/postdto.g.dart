// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postdto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDto _$PostDtoFromJson(Map<String, dynamic> json) {
  return PostDto(
    json['postId'] as String,
    json['uid'] as String,
    json['mediaUrl'] as String,
    json['text'] as String,
    json['upvotes'] as int,
    (json['upvotesDtos'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PostDtoToJson(PostDto instance) => <String, dynamic>{
      'postId': instance.postId,
      'uid': instance.uid,
      'mediaUrl': instance.mediaUrl,
      'text': instance.text,
      'upvotes': instance.upvotes,
      'upvotesDtos': instance.upvotesDtos,
    };
