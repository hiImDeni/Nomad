import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../scheme.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditProfilePageState();
  }

}

class EditProfilePageState extends State<EditProfilePage> {
  CustomInput firstNameInput = new CustomInput(label: 'First Name');
  CustomInput lastNameInput = new CustomInput(label: 'Last Name',);

  DateTime dateOfBirth;
  TextEditingController dateController = TextEditingController();


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
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/take-photo.webp'),
                                  radius: 50.0,
                                ),
                                firstNameInput,
                                lastNameInput,
                                TextField(
                                  readOnly: true,
                                  controller: dateController,
                                  decoration: InputDecoration(
                                      hintText: 'Pick your Date'
                                  ),
                                  onTap: () async {
                                    var date =  await showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate:DateTime(1900),
                                        lastDate: DateTime(2100));
                                    dateController.text = date.toString().substring(0,10);
                                  },),
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

  _saveUser(BuildContext context) {}
}