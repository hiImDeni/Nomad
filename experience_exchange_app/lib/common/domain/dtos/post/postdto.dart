import 'package:experience_exchange_app/common/domain/dtos/upvote/upvotedto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postdto.g.dart';

@JsonSerializable()
class PostDto {
  String postId; //?
  String uid;
  String mediaUrl;
  String text;
  int upvotes;
  List<UpvoteDto> upvotesDtos; //?

  PostDto(this.uid, this.mediaUrl, this.text, this.upvotes);

  factory PostDto.fromJson(Map<String, dynamic> json) => _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}