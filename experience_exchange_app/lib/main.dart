import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/features/pages/create-post-page.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/pages/template-page.dart';
import 'package:experience_exchange_app/features/scheme.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'common/helper.dart';
import 'features/pages/newsfeed-page.dart';
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
      ChangeNotifierProvider(create: (context) => UserService()),
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
        home: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[NewsfeedPage(), ProfilePage(), CreatePostPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();

    if (firebaseUser == null)
      return SignInPage();

    return Scaffold(
      appBar: null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outlined),
            label: 'Post',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}