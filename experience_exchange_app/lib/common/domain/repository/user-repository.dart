import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepository {
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  var _dbReference = FirebaseDatabase.instance.reference();

  Future<void> save(String id, UserDto user) async {
    return _dbReference.child('/users/$id').set(user.toJson());
  }

  Future<UserDto> getById(String uid) async{
    var snapshot = await _dbReference.child('/users/$uid').once();
    var value = snapshot.value;
    // var id = snapshot.key;
    return UserDto(value['firstName'], value['lastName'], value['location'], DateTime.tryParse(value['dateOfBirth']), value['photoUrl']); //?
  }

  Future<List<UserDto>> searchByName(String name) async{
    var searchByName = await _search(['lastName', 'firstName'], name).then((value) {
      if (value == null)
        return [];
      return value;
    });
  }

  Future<String> getUid(UserDto user) async {
    await _dbReference.child('/users').orderByChild('lastName').equalTo(user.lastName)
      .orderByChild('firstName').equalTo(user.firstName).once().then((value) {
        return value.key;
    });
  }

  Future<List<UserDto>> _search(List<String> criterions, String name) async{
    _dbReference.child('users').once().then((result) {
      var usersModel = result.value;
      var users = <UserDto>[];

      usersModel.forEach((key, value) {
        for (var criterion in criterions) {
          var searchValue = value[criterion].toLowerCase();
          if (searchValue.startsWith(name.toLowerCase())) {
            UserDto userDto = UserDto(
                value['firstName'], value['lastName'], value['location'],
                DateTime.tryParse(value['dateOfBirth']), value['photoUrl']);
            users.add(userDto);
          }
        }
      });

      return users;
    });

  }
}