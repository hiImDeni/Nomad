import 'file:///E:/faculta/Licenta/bachelor-thesis/experience_exchange_app/lib/features/scheme.dart';
import 'package:experience_exchange_app/common/domain/validators/validators.dart';
import 'package:experience_exchange_app/features/pages/sign-up-page.dart';
import 'package:experience_exchange_app/features/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }

}

class SignInPageState extends State<SignInPage> {
  CustomInput emailInput = CustomInput(label: 'Username/email',
    inputType: TextInputType.emailAddress,
    validator: validateEmail,);
  CustomInput passwordInput = CustomInput(label: 'Password',
    inputType: TextInputType.visiblePassword,
    validator: validatePassword,);

  //TODO: fix keys??
  // final _formPageKey = GlobalKey<FormState>();
  // final _pageKey = GlobalKey<ScaffoldState>();
  final log = Logger();

  final _authFirebase = FirebaseAuth.instance;

  bool isLoading = false;

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
                                onPressed: () => _signIn(), child: Text('Sign Up')),
                            ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                }, child: Text('Sign Up'))


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
        final currentUser = await _authFirebase.signInWithEmailAndPassword(
            email: email, password: password);
        log.i(currentUser.toString());

        if (currentUser == null) {
          log.e("unable to log in");
        }
      } catch (e) {
        log.e(e.message);
        // setState(() {
        //   isLoading = false;
        // });
        // _pageKey.currentState.showSnackBar(
        //     SnackBar(content: Text("Could not login.")));
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
}