import 'package:json_annotation/json_annotation.dart';

part 'postdto.g.dart';

@JsonSerializable()
class PostDto {
  final String uid;
  final String mediaUrl;
  final String text;
  final int upvotes;

  PostDto(this.uid, this.mediaUrl, this.text, this.upvotes);

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}