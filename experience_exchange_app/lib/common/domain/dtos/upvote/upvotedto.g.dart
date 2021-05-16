// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upvotedto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpvoteDto _$UpvoteDtoFromJson(Map<String, dynamic> json) {
  return UpvoteDto(
    json['postId'] as String,
    json['uid'] as String,
  );
}

Map<String, dynamic> _$UpvoteDtoToJson(UpvoteDto instance) => <String, dynamic>{
      'postId': instance.postId,
      'uid': instance.uid,
    };
