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
    _$enumDecodeNullable(_$ConnectionStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$ConnectionDtoToJson(ConnectionDto instance) =>
    <String, dynamic>{
      'uid1': instance.uid1,
      'uid2': instance.uid2,
      'date': instance.date?.toIso8601String(),
      'status': _$ConnectionStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.Pending: 'Pending',
  ConnectionStatus.Accepted: 'Accepted',
  ConnectionStatus.Declined: 'Declined',
};
