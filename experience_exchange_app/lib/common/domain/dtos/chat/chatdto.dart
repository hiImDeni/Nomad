import 'package:json_annotation/json_annotation.dart';

part 'chatdto.g.dart';

@JsonSerializable()
class ChatDto {
  String uid1;
  String uid2;

  ChatDto(this.uid1, this.uid2);

  factory ChatDto.fromJson(Map<String, dynamic> json) => _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}