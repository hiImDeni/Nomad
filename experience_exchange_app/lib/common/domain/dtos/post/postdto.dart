import 'package:experience_exchange_app/common/domain/dtos/comment/commentdto.dart';
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
  int comments;
  List<CommentDto> commentDtos;

  PostDto(this.postId, this.uid, this.mediaUrl, this.text, this.upvotes, this.comments);

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}