// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatdto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDto _$ChatDtoFromJson(Map<String, dynamic> json) {
  return ChatDto(
    (json['uids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ChatDtoToJson(ChatDto instance) => <String, dynamic>{
      'uids': instance.uids,
    };
