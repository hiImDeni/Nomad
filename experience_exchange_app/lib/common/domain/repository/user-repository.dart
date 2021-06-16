import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserRepository {
  var _dbReference = FirebaseFirestore.instance.collection('users');

  Future<void> save(String id, UserDto user) async {
    return _dbReference.doc(id).set(user.toJson());
  }

  Future<UserDto> getById(String uid) async{
    var snapshot = await _dbReference.doc(uid).get();
    if (snapshot.exists)
      return UserDto.fromJson(snapshot.data()); //?
    else
      return null;
  }

  Future<String> getUid(UserDto user) async {
    return await _dbReference
        .where('firstName', isEqualTo: user.firstName)
        .where('lastName', isEqualTo: user.lastName)
        .where('dateOfBirth', isEqualTo: user.dateOfBirth)
        .limit(1)
        .get().then((value) {
          return value.docs.first.id;
        });
  }

  Future<Map<String, UserDto>> search(List<String> criterions, String name) async{
    var result = await _dbReference.get();
      var usersModel = result.docs;
      var users = Map<String, UserDto>();

      usersModel.forEach((value) {
        for (var criterion in criterions) {
          var searchValue = value[criterion].toLowerCase();
          if (searchValue.startsWith(name.toLowerCase())) {
            UserDto userDto = UserDto(
                value['firstName'], value['lastName'], value['location'],
                DateTime.tryParse(value['dateOfBirth']), value['photoUrl']);
            users[value.id] = userDto;
          }
        }
      });
      return users;
  }

  Future<int> getNumberOfRequests(String uid) async {
    return await _dbReference.doc(uid).collection('requests').get().then((value) => value.size);
  }

  Stream getRequests(String uid) => _dbReference.doc(uid).collection('requests').snapshots();

  Stream getUsers() => _dbReference.snapshots();
}