import 'dart:io';

import 'package:experience_exchange_app/common/helper.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/alert.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  final String uid;

  const CreatePostPage({ this.uid });

  @override
  State<StatefulWidget> createState() {
    return CreatePostPageState(uid: uid);
  }
}

class CreatePostPageState extends State<CreatePostPage> {
  String uid;
  UserService _userService;
  File _mediaFile;
  Image _currentImage;
  // VideoElement _currentVideo;

  CreatePostPageState({this.uid});

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    uid = _userService.currentUser.uid;

    if (uid == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (context) {
                  return SignInPage();
                }));
    }
    if (uid != _userService.currentUser.uid) {
      Alert(context, "You don't have permission to create a post for user $uid}");
      Navigator.pop(context);
    }

    return Container(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 100, left: 20, right: 20),),
        TextField(
          controller: TextEditingController(),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          // minLines: 1,
          // decoration: InputDecoration(labelText: 'Enter some thoughts',),
          style: TextStyle(fontSize: 18,),
        ),

        ClipRect(
          child: _currentImage
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            MainButton(text: 'Add Photo', action: () async => _setPhoto()),
            // MainButton(text: 'Add Video', action: _setVideo())
          ],
        )
      ],),
    );
  }

  _setPhoto() async {
    File selectedImage = await _selectImage();
    _mediaFile = await _cropImage(selectedImage);

    setState(() {
      _currentImage = Image.file(_mediaFile);
    });
  }

  _setVideo() {}

  Future<String> _uploadImage() async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('/images').child(_mediaFile.path.split('/').last);
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(_mediaFile);
    return snapshot.ref.getDownloadURL();
  }

  Future<File> _selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
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