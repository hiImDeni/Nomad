// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messagedto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return MessageDto(
    json['uid1'] as String,
    json['uid2'] as String,
    json['text'] as String,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'uid1': instance.uid1,
      'uid2': instance.uid2,
      'text': instance.text,
      'date': instance.date?.toIso8601String(),
    };
