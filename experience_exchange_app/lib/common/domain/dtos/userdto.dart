import 'package:json_annotation/json_annotation.dart';

part 'userdto.g.dart';

@JsonSerializable()
class UserDto{
  UserDto(this.firstName, this.lastName, this.location, this.dateOfBirth, this.photoUrl);

  String firstName;
  String lastName;
  String location;
  DateTime dateOfBirth;
  String photoUrl;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}