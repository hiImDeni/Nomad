import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/common/helper.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/widgets/alert.dart';
import 'package:experience_exchange_app/features/widgets/custom-input.dart';
import 'package:experience_exchange_app/features/widgets/date-input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:experience_exchange_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

  DateInput dateInput;

  Image _currentImage = Image.asset('assets/images/take-photo.webp');
  File _imageFile;

  UserDto user;

  UserService _userService;

  Position _currentPosition;

  EditProfilePageState({this.user}) {
    if (this.user == null)
      this.user = UserDto('', '', '', DateTime.now(), '');
    else if (user.photoUrl != ''){
      _currentImage = Image.network(user.photoUrl);
    }

    firstNameInput = CustomInput(label: 'First Name', originalText: user.firstName);
    lastNameInput = CustomInput(label: 'Last Name', originalText: user.lastName,);
    locationInput = CustomInput(label: 'Location', originalText: user.location,);

    if (user.dateOfBirth != null)
      dateInput =  DateInput(label: 'Date of Birth', originalDate: user.dateOfBirth);
    else
      dateInput =  DateInput(label: 'Date of Birth', originalDate: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

    return Scaffold(
        body:
            SingleChildScrollView(
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProfileAvatar(
                                  "",
                                    child: ClipOval(child: _currentImage),
                                    onTap: () async {await _setImage();},
                                ),
                                firstNameInput,
                                lastNameInput,
                                dateInput,
                                locationInput,
                                TextButton(onPressed: () async { await _getCurrentLocation(); }, child: Text('Use current location')),
                                MainButton(text: "Save",
                                    action: () => _saveUser(context)),

                              ],
                            ),
                )
            )
    );
  }

  _saveUser(BuildContext context) async {
    // provider.getById(provider.currentUser.uid);

    String firebaseUrl;
    if (_imageFile != null) {
     firebaseUrl = await Helper.uploadImage(_imageFile);
     user.photoUrl = firebaseUrl;
    }
    user.firstName = firstNameInput.text;
    user.lastName = lastNameInput.text;
    user.location = locationInput.text;
    user.dateOfBirth = DateTime.tryParse(dateInput.text);

    await _userService.updateUserProfile(user);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) { return HomePage(); }));
  }

  _setImage() async {
    File selectedImage = await Helper.selectImageFromGallery();
    _imageFile = await Helper.cropImage(selectedImage);

    setState(() {
      _currentImage = Image.file(_imageFile);
    });
  }

  _getCurrentLocation() async {
    var position = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true);

    locationInput.text = await _getAddressFromLatLng(position);
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    if (position == null) {
      _showAlertDialog(context, 'Location unavailable');
      return locationInput.text;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude
    );

    Placemark place = placemarks[0];

    return "${place.locality}, ${place.country}";
  }

  _showAlertDialog(BuildContext context, String text) {
    showDialog(context: context, builder: (_) => Alert(context, text));
  }
}