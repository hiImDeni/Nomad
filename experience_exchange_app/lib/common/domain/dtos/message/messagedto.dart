import 'package:json_annotation/json_annotation.dart';

part 'messagedto.g.dart';

@JsonSerializable()
class MessageDto {
  // String messageId;
  String uid1;
  String uid2;
  String text;
  DateTime date;

  MessageDto(this.uid1, this.uid2, this.text, this.date);

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}