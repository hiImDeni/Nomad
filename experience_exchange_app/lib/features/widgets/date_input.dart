import 'package:flutter/material.dart';

import '../scheme.dart';

class DateInput extends StatefulWidget{
  TextEditingController _textEditingController;
  String label;

  DateInput({this.label}) { _textEditingController = TextEditingController(); }

  String get text { return this._textEditingController.text; }
  TextEditingController get textEditingController { return this._textEditingController; }

  @override
  State<StatefulWidget> createState() {
    return DateInputState(label: label, textEditingController: textEditingController);
  }
}

class DateInputState extends State<DateInput> {
  TextEditingController textEditingController;
  String label;

  DateInputState({this.label, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 40.0, right: 40.0),
        child:TextField(
          readOnly: true,
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
          onTap: () async {
            var date =  await showDatePicker(
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100));
            textEditingController.text = date.toString().substring(0,10);
          },
        )
    );
  }
}