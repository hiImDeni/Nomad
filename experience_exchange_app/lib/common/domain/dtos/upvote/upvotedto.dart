import 'package:json_annotation/json_annotation.dart';

part 'upvotedto.g.dart';

@JsonSerializable()
class UpvoteDto {
  // String upvoteId;
  String postId;
  String uid;

  UpvoteDto(this.postId, this.uid);

  factory UpvoteDto.fromJson(Map<String, dynamic> json) => _$UpvoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpvoteDtoToJson(this);
}