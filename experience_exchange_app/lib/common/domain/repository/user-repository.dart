import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/common/domain/dtos/user/userdto.dart';
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

  Future<Set<UserDto>> searchByName(String name) async{
    var searchByLastName = await _search('lastName', name);
    var searchByFirstName = await _search('firstName', name);

    var result = searchByFirstName + searchByLastName;

    return result.toSet();
  }

  Future<List<UserDto>> _search(String criterion, String name) async{
    _dbReference.child('users').orderByChild(criterion).once().then((result) {
      var usersModel = result.value;
      var users = <UserDto>[];

      usersModel.forEach((key, value) {
        if (value[criterion].contains(name)) {
          UserDto userDto = UserDto(
              value['firstName'], value['lastName'], value['location'],
              DateTime.tryParse(value['dateOfBirth']), value['photoUrl']);
          users.add(userDto);
        }
      });

      return users;
    });

  }
}