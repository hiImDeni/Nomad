import 'package:experience_exchange_app/features/widgets/custom-input.dart';
import 'package:flutter/material.dart';

import '../../common/scheme.dart';

class PasswordInput extends StatefulWidget{
  TextEditingController textEditingController;
  String get text { return this.textEditingController.text; }

  bool obscureText;
  String label;
  Function validator;

  PasswordInput({this.label, this.validator, this.obscureText = true}) { textEditingController = TextEditingController(); }

  @override
  State<StatefulWidget> createState() {
    return PasswordInputState();
  }
}

class PasswordInputState extends State<PasswordInput> {

  Color _currentColor = Scheme.inactiveColor;
  Color _nextColor = Scheme.mainColor;

  PasswordInputState();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
        child:TextField(
          controller: widget.textEditingController,

          decoration: InputDecoration(labelText: widget.label,
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
            suffixIcon: IconButton(icon: Icon(Icons.visibility, color: _currentColor),
              onPressed: () => { setState(() {
                widget.obscureText = !widget.obscureText;
                Color auxColor = _nextColor;
                _nextColor = _currentColor;
                _currentColor = auxColor;
              }) } ,
            ),
          ),
          obscureText: widget.obscureText,
        )
    );
  }
}