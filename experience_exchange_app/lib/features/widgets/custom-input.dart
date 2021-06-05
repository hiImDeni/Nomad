import 'package:flutter/material.dart';

import '../../common/scheme.dart';

class CustomInput extends StatefulWidget{
  TextEditingController _textEditingController;

  bool obscureText;
  String label;
  Function validator;
  String originalText;

  CustomInput({this.label, this.validator, this.obscureText = false, this.originalText = ''}) {
    _textEditingController = TextEditingController();
    _textEditingController.text = originalText;
  }

  String get text { return this._textEditingController.text; }
  set text(String t) { this._textEditingController.text = t; }
  TextEditingController get textEditingController { return this._textEditingController; }

  @override
  State<StatefulWidget> createState() {
    return CustomInputState(label: label, validator: validator, obscureText: obscureText, textEditingController: textEditingController);
  }
}

class CustomInputState extends State<CustomInput> {
  TextEditingController textEditingController;
  bool obscureText;
  String label;
  Function validator;

  CustomInputState({this.label, this.validator, this.obscureText, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
        child:TextField(
          controller: textEditingController,

          decoration: InputDecoration(labelText: label,
            contentPadding: EdgeInsets.only(
                bottom: 20,
                left: 15,
                right: 15
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Scheme.inputColor, width: 1.7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Scheme.inactiveColor, width: 1.5),
            ),
          ),
          obscureText: obscureText,
        )
    );
  }
}