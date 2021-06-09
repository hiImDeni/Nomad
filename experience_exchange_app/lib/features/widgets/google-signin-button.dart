import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/common/scheme.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  Function action;

  GoogleSignInButton({@required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      width: 170,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 2)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: OutlinedButton.icon(
          label: Text("Google Sign In", style: TextStyle(fontSize: 15, color: Colors.black),),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
          onPressed: action,
        ),
      ),
    );
  }
}