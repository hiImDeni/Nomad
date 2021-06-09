import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/scheme.dart';

class MainButton extends StatelessWidget {
  String text;
  Function action;

  MainButton({@required this.text, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      width: 170,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
              colors: [Scheme.mainColor, Scheme.inputColor]
          )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ElevatedButton(
          onPressed: action,
          child: Text(text, style: TextStyle(
              fontSize: 15,
              // color: Colors.white
          )),
        ),
      ),
    );
  }

}