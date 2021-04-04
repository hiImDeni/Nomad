import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:flutter/material.dart';

import '../scheme.dart';

class PasswordInput extends CustomInput{
  PasswordInput({label, validator, obscureText = true})
      : super(label: label, validator: validator, obscureText: obscureText);

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
            suffixIcon: Icon(Icons.visibility),
          ),
          obscureText: obscureText,
        )
    );
  }
}