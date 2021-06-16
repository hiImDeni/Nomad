import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connectiondto.g.dart';

@JsonSerializable()
class ConnectionDto {
  String uid1;
  String uid2;
  DateTime date;
  ConnectionStatus status;

  ConnectionDto(this.uid1, this.uid2, this.date, this.status);

  factory ConnectionDto.fromJson(Map<String, dynamic> json) => _$ConnectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionDtoToJson(this);
}