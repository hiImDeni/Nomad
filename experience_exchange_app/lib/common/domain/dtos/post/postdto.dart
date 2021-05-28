import 'package:json_annotation/json_annotation.dart';

part 'postdto.g.dart';

@JsonSerializable()
class PostDto {
  String postId; //?
  String uid;
  String mediaUrl;
  String text;
  int upvotes;
  List<String> upvotesDtos; //?

  PostDto(this.postId, this.uid, this.mediaUrl, this.text, this.upvotes, this.upvotesDtos);

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}