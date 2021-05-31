import 'package:json_annotation/json_annotation.dart';

part 'chatdto.g.dart';

@JsonSerializable()
class ChatDto {
  List<String> uids;

  ChatDto(this.uids);

  factory ChatDto.fromJson(Map<String, dynamic> json) => _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);
}