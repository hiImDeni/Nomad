import 'package:json_annotation/json_annotation.dart';

part 'commentdto.g.dart';

@JsonSerializable()
class CommentDto {
  String uid;
  DateTime date;
  String text;

  CommentDto(this.uid, this.date, this.text);

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDtoToJson(this);
}