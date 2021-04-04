import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/features/scheme.dart';
import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }

}

class SignUpPageState extends State<SignUpPage> {
  CustomInput emailInput = CustomInput(label: 'Username/email',
    validator: validateEmail,);
  CustomInput passwordInput = CustomInput(label: 'Password',
    validator: validatePassword,
    obscureText: true
  );

  final log = Logger();


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
                                Text('SIGN UP', style: TextStyle(
                                    color: Scheme.mainColor, fontSize: 30)),
                                emailInput,
                                passwordInput,
                                MainButton(text: "Sign Up", action: () => _signUp()),

                              ],
                            ),
                          ),
                          Container()]
                    )
                )
            )
        )
    );
  }

  void _signUp() async {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    provider.signInWithGoogle();

    final storage = FlutterSecureStorage();
    storage.write(key: "loginstatus", value: "loggedin");
    String email = emailInput.text;
    String password = passwordInput.text;

    if (validateEmail(email) && validatePassword(password)) {
      try {
        final currentUser = provider.signUp(email: emailInput.text, password: passwordInput.text);
        log.i(currentUser.toString());

        if (currentUser == null) {
          log.e("unable to sign up");
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }
      } catch (e) {
        log.e(e.message);
      }
    }
    else {
      log.e("Invalid username or password");
    }
  }

  void _goBack(BuildContext context) {
    // Navigator.pop(context);
  }
}