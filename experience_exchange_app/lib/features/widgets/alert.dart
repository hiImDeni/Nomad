import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  BuildContext context;
  String message;

  Alert(this.context, this.message);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}