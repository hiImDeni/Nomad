import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/common/domain/dtos/user/userdto.dart';
import 'package:firebase_database/firebase_database.dart';

class UserRepository {
  final FirebaseFirestore _firestoreDb = FirebaseFirestore.instance;
  var _dbReference = FirebaseDatabase.instance.reference();

  Future<void> save(String id, UserDto user) async {

    return _dbReference.child('/users/$id').set(user.toJson());
    // doc(id)
    //     .set(user.toJson())
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));
  }

  Future<UserDto> getById(String uid) async{
    var snapshot = await _dbReference.child('/users/$uid').once();
    Map<String, dynamic> json = Map<String, dynamic>();
    // var user = snapshot.value.foreach((key, value) {
    //   json.addEntries([MapEntry(key, value)]);
    // });
    var value = await snapshot.value;
    return UserDto.fromJson(value); //?
  }
}