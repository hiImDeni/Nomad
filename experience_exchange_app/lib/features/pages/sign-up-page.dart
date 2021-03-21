import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/features/scheme.dart';
import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

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

  final _authFirebase = FirebaseAuth.instance;


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
                                Text('SIGN IN', style: TextStyle(
                                    color: Scheme.mainColor, fontSize: 30)),
                                emailInput,
                                passwordInput,
                                ElevatedButton(
                                    onPressed: () => _signUp(), child: Text('Sign In'))

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
    final storage = FlutterSecureStorage();
    storage.write(key: "loginstatus", value: "loggedin");
    String email = emailInput.text;
    String password = passwordInput.text;

    if (validateEmail(email) && validatePassword(password)) {
      try {
        final currentUser = await _authFirebase.createUserWithEmailAndPassword(email: email, password: password);
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