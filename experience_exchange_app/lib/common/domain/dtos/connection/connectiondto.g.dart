// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectiondto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionDto _$ConnectionDtoFromJson(Map<String, dynamic> json) {
  return ConnectionDto(
    json['uid1'] as String,
    json['uid2'] as String,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$ConnectionDtoToJson(ConnectionDto instance) =>
    <String, dynamic>{
      'uid1': instance.uid1,
      'uid2': instance.uid2,
      'date': instance.date?.toIso8601String(),
    };
