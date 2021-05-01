import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/common/domain/dtos/userdto.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/date_input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditProfilePageState();
  }

}

class EditProfilePageState extends State<EditProfilePage> {
  CustomInput firstNameInput = CustomInput(label: 'First Name');
  CustomInput lastNameInput = CustomInput(label: 'Last Name',);
  CustomInput locationInput = CustomInput(label: 'Location',);

  TextEditingController dateController = TextEditingController();
  DateInput dateInput = DateInput(label: 'Date of Birth');

  ImagePicker _imagePicker = ImagePicker();
  Image _currentImage = Image.asset('assets/images/take-photo.webp');
  File _imageFile;

  UserDto user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        // key: _pageKey,
        body:
        Form(
          // key: _formPageKey,
            child:
            SingleChildScrollView(
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProfileAvatar(
                                  "",
                                    child: ClipOval(child: _currentImage),
                                    onTap: () async => await _selectImage(),
                                ),
                                firstNameInput,
                                lastNameInput,
                                dateInput,
                                locationInput,
                                MainButton(text: "Save",
                                    action: () => _saveUser(context)),

                              ],
                            ),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }

  _saveUser(BuildContext context) async {
    final provider = Provider.of<UserService>(context, listen: false);

    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('/images').child(_imageFile.path.split('/').last);
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(_imageFile);
    String firebaseUrl = await snapshot.ref.getDownloadURL();

    user = new UserDto(firstNameInput.text, lastNameInput.text, locationInput.text, DateTime.tryParse(dateInput.text), firebaseUrl);

    provider.updateUserProfile(user);
  }

  _selectImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    _imageFile = File(pickedFile.path);

    setState(() {
      _currentImage = Image.file(_imageFile);
    });
  }

  Future<String> _uploadImage() async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/');
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(_imageFile);
    return snapshot.ref.getDownloadURL();
  }
}