import 'package:json_annotation/json_annotation.dart';

part 'connectiondto.g.dart';

@JsonSerializable()
class ConnectionDto {
  // String connectionId;
  String uid1;
  String uid2;
  DateTime date;

  ConnectionDto(this.uid1, this.uid2, this.date);

  factory ConnectionDto.fromJson(Map<String, dynamic> json) => _$ConnectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionDtoToJson(this);
}