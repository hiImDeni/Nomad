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
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['text'] as String,
    json['upvotes'] as int,
    json['comments'] as int,
  )
    ..upvotesDtos =
        (json['upvotesDtos'] as List)?.map((e) => e as String)?.toList()
    ..commentDtos = (json['commentDtos'] as List)
        ?.map((e) =>
            e == null ? null : CommentDto.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PostDtoToJson(PostDto instance) => <String, dynamic>{
      'postId': instance.postId,
      'uid': instance.uid,
      'mediaUrl': instance.mediaUrl,
      'date': instance.date?.toIso8601String(),
      'text': instance.text,
      'upvotes': instance.upvotes,
      'upvotesDtos': instance.upvotesDtos,
      'comments': instance.comments,
      'commentDtos': instance.commentDtos,
    };
