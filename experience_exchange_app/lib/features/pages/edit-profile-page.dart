import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/date_input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

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

  DateTime dateOfBirth;
  TextEditingController dateController = TextEditingController();
  DateInput dateInput = DateInput(label: 'Date of Birth');

  ImagePicker _imagePicker = ImagePicker();
  Image _currentImage = Image.asset('assets/images/take-photo.webp');
  File _imageFile;


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
    final provider = Provider.of<AuthenticationService>(context, listen: false);

    Uri firebaseUrl = await _uploadImage();

    provider.updateUserProfile(firstNameInput.text, lastNameInput.text, firebaseUrl);
  }

  _selectImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    _imageFile = File(pickedFile.path);

    setState(() {
      _currentImage = Image.file(_imageFile);
    });
  }

  Future<Uri> _uploadImage() async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask.then((result) => result.ref.getDownloadURL());
  }
}