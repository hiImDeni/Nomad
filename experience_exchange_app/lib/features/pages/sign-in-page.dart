import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/features/scheme.dart';
import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/features/pages/sign-up-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:experience_exchange_app/features/widgets/google-signin-button.dart';
import 'package:experience_exchange_app/features/widgets/main-button.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }

}

class SignInPageState extends State<SignInPage> {
  CustomInput emailInput = CustomInput(label: 'Username/email',
    validator: validateEmail,);
  CustomInput passwordInput = CustomInput(label: 'Password',
      validator: validatePassword,
      obscureText: true
  );

  //TODO: fix keys??
  // final _formPageKey = GlobalKey<FormState>();
  // final _pageKey = GlobalKey<ScaffoldState>();
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
                            Text('SIGN IN', style: TextStyle(
                                color: Scheme.mainColor, fontSize: 30)),
                            emailInput,
                            passwordInput,
                            MainButton(text: "Sign In", action: () => _signIn()),
                            GoogleSignInButton(action: () => _googleSignIn(),),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account? "),
                                TextButton(
                                    child: Text("Sign Up first"),
                                    onPressed: () async {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return SignUpPage();
                                      }));
                                })
                              ],
                            ),



                          ],
                        ),
                      ),]
                )
            )
        )
      )
    );
  }

  void _goBack(BuildContext context) {
    // Navigator.pop(context);
  }

  _signIn() async {
    final storage = FlutterSecureStorage();
    storage.write(key: "loginstatus", value: "loggedin");
    String email = emailInput.text;
    String password = passwordInput.text;

    // if (_formPageKey.currentState.validate()) {
    //   setState(() {
    //     isLoading = true;
    //   });

    if (validateEmail(email) && validatePassword(password)) {
      try {
        final provider = Provider.of<AuthenticationService>(context, listen: false);

        final currentUser = provider.signIn(email: emailInput.text, password: passwordInput.text);
        log.i(currentUser.toString());

        if (currentUser == null) {
          log.e("unable to log in");
          _showSnackBar("Invalid username or password");
        }
      } catch (e) {
        log.e(e.message);
        _showSnackBar(e.message);
      }
    }
    else {
      log.e("Invalid username or password");
    }

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => InitializeProviderDataScreen()));
  }

  _googleSignIn() {
    final provider = Provider.of<AuthenticationService>(context, listen: false);
    provider.signInWithGoogle();
  }

  _showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}