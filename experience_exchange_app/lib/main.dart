import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:experience_exchange_app/features/pages/chats-page.dart';
import 'package:experience_exchange_app/features/pages/create-post-page.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/scheme.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/logic/services/upvote-repository.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'common/domain/dtos/user/userdto.dart';
import 'common/helper.dart';
import 'features/pages/newsfeed-page.dart';
import 'features/pages/sign-in-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/services/chat-service.dart';
import 'logic/services/post-service.dart';



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
      ChangeNotifierProvider(create: (context) => PostService()),
      ChangeNotifierProvider(create: (context) => UpvoteService()),
      ChangeNotifierProvider(create: (context) => ChatService()),
      StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),//listens to authentication changes
    ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Scheme.mainColor,
          // primaryColor: Scheme.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          unselectedWidgetColor: Scheme.inactiveColor,
          scaffoldBackgroundColor: Scheme.backgroundColor,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: Text('Welcome')
      ),
      drawer: Drawer(child:
      ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            // ),
            child: Text('Menu'),
          ),
          ListTile(
            title: Text('Edit Profile'),
            onTap: () async {
              await _goToEditProfile(firebaseUser);
            },
          ),
          ListTile(
            title: Text('Chats'),
            onTap: () async { _gotToChats(); },
          ),
          Spacer(),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              Navigator.pop(context);
              AuthenticationService().signOut();
            },
          ),
        ],
      ),
      ),
      body:
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery
              .of(context).size.height,
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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

  _goToEditProfile(User firebaseUser) async {
    Navigator.pop(context);
    UserService service = Provider.of<UserService>(context, listen: false);
    var currentUser = await service.getById(firebaseUser.uid);
    Navigator.push(context, MaterialPageRoute(builder: (context) { return EditProfilePage(user: currentUser); }));
  }

  _gotToChats() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) { return ChatsPage(); }));
  }
}