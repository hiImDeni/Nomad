import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepository {
  var _dbReference = FirebaseFirestore.instance.collection('users');
  // FirebaseDatabase.instance.reference();
  // final Firestore firestore;

  Future<void> save(String id, UserDto user) async {
    return _dbReference.doc(id).set(user.toJson());
  }

  Future<UserDto> getById(String uid) async{
    var snapshot = await _dbReference.doc(uid).get();
    var value = snapshot;
    // var id = snapshot.key;
    return UserDto(value['firstName'], value['lastName'], value['location'], DateTime.tryParse(value['dateOfBirth']), value['photoUrl']); //?
  }

  // Future<List<UserDto>> searchByName(String name) async{
  //   var searchByName = await _search(['lastName', 'firstName'], name).then((value) {
  //     if (value == null)
  //       return [];
  //     return value;
  //   });
  // }

  Future<String> getUid(UserDto user) async {
    return await _dbReference
        .where('firstName', isEqualTo: user.firstName)
        .where('lastName', isEqualTo: user.lastName)
        .limit(1)
        .get().then((value) {
          return value.docs.first.id; //????
        });

  }

  Future<List<UserDto>> search(List<String> criterions, String name) async{
    var result = await _dbReference.get();
      var usersModel = result.docs;
      var users = <UserDto>[];

      usersModel.forEach((value) { //todo: check
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
  }

  Stream getUsers() => _dbReference.snapshots();
}