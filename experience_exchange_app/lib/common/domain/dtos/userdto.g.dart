// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return UserDto(
    json['firstName'] as String,
    json['lastName'] as String,
    json['location'] as String,
    json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
    json['photoUrl'] as String,
  );
}

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'location': instance.location,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'photoUrl': instance.photoUrl,
    };
