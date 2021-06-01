import 'package:json_annotation/json_annotation.dart';

part 'userdto.g.dart';

@JsonSerializable()
class UserDto{
  String firstName;
  String lastName;
  String location;
  DateTime dateOfBirth;
  String photoUrl;

  UserDto(this.firstName, this.lastName, this.location, this.dateOfBirth, this.photoUrl);

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}