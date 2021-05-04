import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/date_input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class EditProfilePage extends StatefulWidget {
  UserDto user;

  EditProfilePage({this.user});
  @override
  State<StatefulWidget> createState() {
    return EditProfilePageState(user: this.user);
  }

}

class EditProfilePageState extends State<EditProfilePage> {
  CustomInput firstNameInput;
  CustomInput lastNameInput;
  CustomInput locationInput;

  // TextEditingController dateController = TextEditingController();
  DateInput dateInput;

  ImagePicker _imagePicker = ImagePicker();
  Image _currentImage = Image.asset('assets/images/take-photo.webp');
  File _imageFile;

  UserDto user;

  UserService _userService;

  EditProfilePageState({this.user}) {
    if (this.user == null)
      this.user = UserDto('', '', '', DateTime.now(), '');

    firstNameInput = CustomInput(label: 'First Name', originalText: user.firstName);
    lastNameInput = CustomInput(label: 'Last Name', originalText: user.lastName,);
    locationInput = CustomInput(label: 'Location', originalText: user.location,);
    dateInput =  DateInput(label: 'Date of Birth', originalDate: user.dateOfBirth);
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

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
                                    onTap: () async => await _setImage(),
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
    // provider.getById(provider.currentUser.uid);

    String firebaseUrl = await _uploadImage();

    user = new UserDto(firstNameInput.text, lastNameInput.text, locationInput.text, DateTime.tryParse(dateInput.text), firebaseUrl);

    _userService.updateUserProfile(user);

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) {
              return ProfilePage(user: _userService.currentUser);
            }));
  }

  _setImage() async {
    File selectedImage = await _selectImage();
    _imageFile = await _cropImage(selectedImage);

    setState(() {
      _currentImage = Image.file(_imageFile);
    });
  }

  Future<String> _uploadImage() async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('/images').child(_imageFile.path.split('/').last);
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(_imageFile);
    return snapshot.ref.getDownloadURL();
  }

  Future<File> _selectImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future<File> _cropImage(File selectedImage) async {
    return await ImageCropper.cropImage(
      sourcePath: selectedImage.path,
      maxWidth: 1080,
      maxHeight: 1080,
    );
  }
}