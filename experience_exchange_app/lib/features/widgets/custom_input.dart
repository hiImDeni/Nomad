import 'package:flutter/material.dart';

import '../scheme.dart';

class CustomInput extends StatelessWidget{
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = new FocusNode();

  bool obscureText;
  String label;
  Function validator;

  CustomInput({this.label, this.validator, this.obscureText = false}) { _textEditingController = TextEditingController(); }

  String get text { return this._textEditingController.text; }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
        child:TextFormField(
          controller: _textEditingController,
          focusNode: _focusNode,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
            //TODO: make validator prettier, abstract
          },
          decoration: InputDecoration(labelText: label,
            labelStyle: TextStyle(
                color: _focusNode.hasFocus ? Scheme.mainColor : Scheme.inputBorder //TODO: fix label color
            ),
            contentPadding: EdgeInsets.only(
                bottom: 20,
                left: 15,
                right: 15
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Scheme.mainColor, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Scheme.inputBorder, width: 2.5),
            ),),
          obscureText: obscureText,
        )
      );
  }
}