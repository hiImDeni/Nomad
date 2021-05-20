import 'dart:io';

import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/helper.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/alert.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

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
  File _mediaFile;
  Image _currentImage;
  String _text;
  TextEditingController controller;
  // VideoElement _currentVideo;

  UserService _userService;
  PostService _postService;

  CreatePostPageState({this.uid});

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _postService = Provider.of<PostService>(context);

    uid = _userService.currentUser.uid;

    if (_userService.currentUser == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (context) {
                  return SignInPage();
                }));
    }
    uid = _userService.currentUser.uid;
    controller = TextEditingController(text: _text);

    return Padding(padding: EdgeInsets.only(top: 80, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Title(color: Scheme.mainColor, child: Text('Create Post')),
                Spacer(),
                TextButton(onPressed: () async => _post(), child: Text('Post'))
              ],
            ),

            Card (child: TextField(
              controller: controller,
              onEditingComplete: () => setState(() {
                _text = controller.text;
              }),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Enter some thoughts',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),),

              style: TextStyle(fontSize: 18,),
            ),),

            _currentImage != null ?
              ClipRect(
                  child: _currentImage
              ) : Padding(padding: EdgeInsets.only(bottom: 20)),


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MainButton(text: 'Add Photo', action: () async => _setPhoto()),
                // MainButton(text: 'Add Video', action: _setVideo())
              ],
            )
          ],
        ),
    );
  }

  _setPhoto() async {
    File selectedImage = await Helper.selectImage();
    _mediaFile = await Helper.cropImage(selectedImage);

    setState(() {
      _currentImage = Image.file(_mediaFile);
    });
  }

  _setVideo() {}

  _post() async {
    String mediaUrl = '';
    if (_mediaFile != null) {
      mediaUrl = await Helper.uploadImage(_mediaFile);
    }

    if (mediaUrl != '' || controller.text != '') {
      PostDto post = PostDto(
          '',
          uid,
          mediaUrl,
          controller.text,
          0,
          []
      );
      await _postService.createPost(post);
      _showSnackBar(context, 'Post successfully created');
    }
    else {
      _showAlertDialog(context, "You can't create an empty post");
    }
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  _showAlertDialog(BuildContext context, String text) {
    showDialog(context: context, builder: (_) => Alert(context, text));
  }
}