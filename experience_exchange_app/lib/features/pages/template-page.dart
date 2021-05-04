import 'package:experience_exchange_app/features/pages/create-post-page.dart';
import 'package:experience_exchange_app/features/pages/newsfeed-page.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TemplatePage extends StatefulWidget {
  User currentUser;

  TemplatePage({this.currentUser});

  @override
  State<StatefulWidget> createState() {
    return TemplatePageState();
  }

}

class TemplatePageState extends State<TemplatePage> {
  User currentUser;

  List<Widget> _widgetOptions = <Widget>[NewsfeedPage(), ProfilePage(), CreatePostPage()];
  int _selectedIndex = 0;

  TemplatePageState({this.currentUser});

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SignInPage();
      }));
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          child:
            Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}