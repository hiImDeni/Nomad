import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  static Future<String> uploadImage(File imageFile) async {
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('/images').child(imageFile.path.split('/').last);
    TaskSnapshot snapshot = await firebaseStorageRef.putFile(imageFile);
    return snapshot.ref.getDownloadURL();
  }

  static Future<File> selectImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  static Future<File> cropImage(File selectedImage) async {
    return await ImageCropper.cropImage(
      sourcePath: selectedImage.path,
      maxWidth: 1080,
      maxHeight: 1080,
    );
  }
}