import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/chats-page.dart';
import 'package:experience_exchange_app/features/pages/create-post-page.dart';
import 'package:experience_exchange_app/features/pages/edit-profile-page.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/scheme.dart';
import 'package:experience_exchange_app/logic/services/authentication-service.dart';
import 'package:experience_exchange_app/logic/services/notification-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'features/pages/newsfeed-page.dart';
import 'features/pages/requests-page.dart';
import 'features/pages/sign-in-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/widgets/user.dart';
import 'logic/services/chat-service.dart';
import 'logic/services/connection-service.dart';
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
      ChangeNotifierProvider(create: (context) => ChatService()),
      ChangeNotifierProvider(create: (context) => ConnectionService()),
      ChangeNotifierProvider(create: (context) => NotificationService()),
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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[NewsfeedPage(), ProfilePage(), CreatePostPage()];

  UserService _userService;
  User firebaseUser;

  TextEditingController _textEditingController = TextEditingController();
  Future<Map<String, UserDto>> _usersFuture;

  String _notificationTitle, _notificationBody;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    NotificationService.registerNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      setState(() {
        _notificationTitle = message.notification.title;
        _notificationBody = message.notification.body;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    firebaseUser = context.watch<User>();

    _userService = Provider.of<UserService>(context);

    if (firebaseUser == null)
      return SignInPage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        title:  Container(
            height: 40,
            child:
            TextField(
              controller: _textEditingController,
              onChanged: (text) { _searchUsers(text); },
              decoration: InputDecoration(hintText: 'Search by location',
                contentPadding: EdgeInsets.only(
                  // bottom: 20,
                    left: 20,
                    right: 20
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Scheme.inputColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Scheme.inactiveColor, width: 1.5),
                ),
                prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {},),
              ),
            )
        ),
      ),
      drawer: _displayDrawer(),
      body:
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          height: MediaQuery
              .of(context).size.height,

            child:
            _usersFuture != null ?
              _showSearchResults() :
              _widgetOptions.elementAt(_selectedIndex),


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

  _displayDrawer() {
    return Drawer(
      child:
    ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        SafeArea(child:
          ListTile( title: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),)),
        ),
        Divider(),
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
        ListTile(
          title: Text('Requests'),
          trailing: FutureBuilder(
            future: _userService.getNumberOfRequests(firebaseUser.uid),
            builder: (context, snapshot){
              int requests = 0;
              if (snapshot.hasData) {
                requests = snapshot.data;
              }
              return Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: CircleAvatar(
                child: Text(requests.toString(), style: TextStyle(color: Colors.white, fontSize: 10),),
                backgroundColor: Colors.redAccent,
              ));
            },
          ),
          onTap: () async{
            await _goToRequests();
          },
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
    );
  }

  _goToEditProfile(User firebaseUser) async {
    Navigator.pop(context);
    UserService service = Provider.of<UserService>(context, listen: false);
    var currentUser = await service.getById(firebaseUser.uid);
    Navigator.push(context, MaterialPageRoute(builder: (context) { return EditProfilePage(user: currentUser); }));
  }

  _gotToChats() async {
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) { return ChatsPage(); }));
  }

  _goToRequests() async{
    Navigator.pop(context);
    await Navigator.push(context, MaterialPageRoute(builder: (context) { return RequestsPage(); }));
  }

  _searchUsers(String text) {
    setState(() {
      if (text != '') {
        _usersFuture = _userService.searchByLocation(text);
      }  else {
        _usersFuture = null;
      }
    });
  }

  Widget _showSearchResults() {
    return FutureBuilder(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            var result = snapshot.data;

            List uids = result.keys.toList();
            List users = result.values.toList();

            return Expanded(
              child:
              ListView.builder(
                itemCount: result.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return UserWidget(user: users[index], goToPage: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ProfilePage(uid: uids[index]);
                    }));
                  },);
                },
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }
}