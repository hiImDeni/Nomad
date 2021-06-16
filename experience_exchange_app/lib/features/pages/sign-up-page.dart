import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/common/scheme.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/custom-input.dart';
import 'package:experience_exchange_app/features/widgets/google-signin-button.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/features/widgets/password-input.dart';
import 'package:experience_exchange_app/logic/services/analytics-service.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }

}

class SignUpPageState extends State<SignUpPage> {
  AuthenticationService _authenticationService;
  AnalyticsService _analyticsService;

  CustomInput emailInput = CustomInput(label: 'Email',
    validator: validateEmail,);
  PasswordInput passwordInput = PasswordInput(
    label: 'Password',
    validator: validatePassword,
  );

  @override
  Widget build(BuildContext context) {
    _authenticationService = Provider.of<AuthenticationService>(context, listen: false);
    _analyticsService = Provider.of<AnalyticsService>(context);

    return Scaffold(
        appBar: null,
        body:
        Form(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SafeArea(child:
                                Container(
                                  height: 210,
                                  padding: EdgeInsets.only(top: 25,),
                                  child: Image.asset('assets/images/logo_nomad.png'),
                                )
                                ),

                                Text('SIGN UP', style: TextStyle(
                                    color: Scheme.mainColor, fontSize: 27, fontWeight: FontWeight.w600)),
                                emailInput,
                                passwordInput,
                                MainButton(text: "Sign Up", action: () async { await _signUp(context); }),
                                GoogleSignInButton(action: () async => _googleSignUp(context)),

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

  _signUp(BuildContext context) async {
    String email = emailInput.text;
    String password = passwordInput.text;

    if (!validateEmail(email)) {
      _showSnackBar(context, "Please enter a valid email");
      return;
    }
    if (!validatePassword(password)) {
      _showSnackBar(context, "Please enter a valid password");
      return;
    }

    try {

      final currentUser = await _authenticationService.signUp(email: emailInput.text, password: passwordInput.text);

      if (currentUser == null) {
        _showSnackBar(context, "unable to sign up");
      }
      else {
        await _analyticsService.logSignUp(emailInput.text);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage()),
        );
      }
    } catch (e) {
      print(e.message);
      _analyticsService.logSignUp(e.message);
    }


  }

  _googleSignUp(BuildContext context) async {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    await provider.signInWithGoogle();

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}