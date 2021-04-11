import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/scheme.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'features/pages/sign-in-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      // Provider<AuthenticationService>(create: (_) => AuthenticationService()),
      ChangeNotifierProvider(create: (context) => AuthenticationService()),
      StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),//listens to authentication changes
    ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Scheme.mainColor,
          // primaryColor: Scheme.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          unselectedWidgetColor: Scheme.inactiveColor
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // return EditProfilePage();
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return new Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Spacer(),
          CircularProfileAvatar(
            "",
            child: ClipOval(child: Text(firebaseUser.photoURL)),
          ),
          Text("Welcome ${firebaseUser.displayName}"),
          ElevatedButton(child: Text("Logout"), onPressed: () {
            GoogleSignIn().disconnect();
            FirebaseAuth.instance.signOut();
            },),
          Spacer()
        ])
      );
    }
    else return SignInPage();
  }

}