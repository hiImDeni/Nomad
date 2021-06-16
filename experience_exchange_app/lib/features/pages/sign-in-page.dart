import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/common/scheme.dart';
import 'package:experience_exchange_app/features/pages/sign-up-page.dart';
import 'package:experience_exchange_app/features/widgets/custom-input.dart';
import 'package:experience_exchange_app/features/widgets/google-signin-button.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/features/widgets/password-input.dart';
import 'package:experience_exchange_app/logic/services/analytics-service.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }

}

class SignInPageState extends State<SignInPage> {
  AuthenticationService _authenticationService;
  AnalyticsService _analyticsService;

  String errorMessage;

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
                                Text('SIGN IN', style: TextStyle(
                                    color: Scheme.mainColor, fontSize: 27, fontWeight: FontWeight.w600)),
                                emailInput,
                                passwordInput,
                                MainButton(text: "Sign In",
                                    action: () => _signIn(context)),
                                GoogleSignInButton(
                                  action: () async => _googleSignIn(context),),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Don't have an account? "),
                                    TextButton(
                                        child: Text("Sign Up"),
                                        onPressed: () async {
                                          await Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return SignUpPage();
                                                  }));
                                        })
                                  ],
                                ),


                              ],
                            ),
                          ),
                        ]
                    )
                )
            )
        )
    );
  }

  _signIn(BuildContext context) async {
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
      final currentUser = await _authenticationService.signIn(
          email: emailInput.text, password: passwordInput.text);

      if (currentUser == null) {
        _showSnackBar(context, "Invalid username or password");
      }
      else {
        _analyticsService.logNewSignIn(emailInput.text);
      }
    } catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
        setState(() {
          errorMessage = message;
        });
        print(message);
        _analyticsService.logError(message);
      }
      _showSnackBar(context, 'Incorrect email or password');
    }
  }

  _googleSignIn(BuildContext context) {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    provider.signInWithGoogle();
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}