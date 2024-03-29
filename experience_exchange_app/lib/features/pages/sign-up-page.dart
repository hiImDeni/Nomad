import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/features/scheme.dart';
import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/google-signin-button.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/features/widgets/password-input.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  PasswordInput passwordInput = PasswordInput(
    label: 'Password',
    validator: validatePassword,
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
                                MainButton(text: "Sign Up", action: () => _signUp(context)),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Text("OR", style: TextStyle(fontSize: 18)),
                                ),
                                GoogleSignInButton(action: () => _googleSignIn(context)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Already have an account? ",),
                                    TextButton(
                                        child: Text("Sign In"),
                                        onPressed: () async {
                                          await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return SignInPage();
                                          }));
                                        })
                                  ],
                                ),
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

  void _signUp(BuildContext context) async {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    provider.signInWithGoogle();

    String email = emailInput.text;
    String password = passwordInput.text;

    if (validateEmail(email) && validatePassword(password)) {
      try {
        final provider = Provider.of<AuthenticationService>(context, listen: false);
        final currentUser = provider.signUp(email: emailInput.text, password: passwordInput.text);

        if (currentUser == null) {
          log.e("unable to sign up");
        }
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
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

  _googleSignIn(BuildContext context) {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    provider.signUpWithGoogle();
  }
}