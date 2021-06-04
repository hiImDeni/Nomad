import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/sign-in-page.dart';
import 'package:experience_exchange_app/features/widgets/post.dart';
import 'package:experience_exchange_app/logic/services/connection-service.dart';
import 'package:experience_exchange_app/logic/services/post-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({this.uid});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(currentUid: uid);
  }

}

class ProfilePageState extends State<ProfilePage> {
  UserService _userService;
  PostService _postService;
  ConnectionService _connectionService;

  String currentUid;

  ProfilePageState({this.currentUid});

  String _nextAction;

  @override
  Widget build(BuildContext context) {
    _userService  = Provider.of<UserService>(context);
    _postService = Provider.of<PostService>(context);
    _connectionService = Provider.of<ConnectionService>(context);

    if (_userService.currentUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) {
                return SignInPage();
              }));
    }

    if (currentUid == null) {
      currentUid = _userService.currentUser.uid;
    }

    return FutureBuilder(
      future: _userService.getById(currentUid),
      builder: (context, snapshot)
      {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.hasData) {
          UserDto user = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row (
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          radius: 40
                        ),
                        Padding(padding: EdgeInsets.only(top: 10), child:
                        Title(color: Colors.black,
                            child: Text("${user.firstName}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),)),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15), child:
                        Title(color: Colors.black,
                            child: Text("${user.lastName}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),)),
                        ),
                      ]),

                      Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [StreamBuilder(
                                stream: _postService.getByUid(currentUid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return Text(snapshot.data.docs.length.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),);
                                  return Container();
                                },
                              ),
                              Text('posts')
                          ]),

                          Padding(padding: EdgeInsets.only(left: 30),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    StreamBuilder(
                                      stream: _connectionService.getConnectionsForUid(currentUid),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData)
                                          return Text(snapshot.data.docs.length.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),);
                                        return Container();
                                      },
                                    ),
                                    Text('connections')
                                  ])
                          )]
                        ),
                        Row(children: [
                          TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  Text(user.location)
                                ],
                              ),
                              onPressed: () async {
                                String googleUrl = 'https://www.google.com/maps/place/${user.location}';
                                print(googleUrl);
                                if (await canLaunch(googleUrl)) {
                                  await launch(googleUrl);
                                } else {
                                  throw 'Could not open the map.';
                                }
                              }),
                        ],)
                      ])
                    ]),
              ),



              currentUid != _userService.currentUser.uid
                  ? FutureBuilder(
                    future: _connectionService.getConnection(_userService.currentUser.uid, currentUid),
                    builder: (context, snapshot){
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (snapshot.hasData) {
                        ConnectionDto result = snapshot.data;
                        _setNextAction(result.status);

                        return ElevatedButton(
                          child: Text(_nextAction),
                          onPressed: () async { await _handleConnection(result); }
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                  })
                  : Container(),

              Expanded(
                child: StreamBuilder(
                  stream: _postService.getByUid(currentUid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (snapshot.hasData) {
                      List posts = [];

                      snapshot.data.docs.forEach((doc) {
                        posts.add(PostDto.fromJson(doc.data()));
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          if (index == posts.length - 1) {
                            return Padding(padding: EdgeInsets.only(bottom: 30),
                                child: Post(post: posts[index])
                            );
                          }

                          return Post(post: posts[index]);
                        },
                      );
                    }

                    return Center(child: CircularProgressIndicator());
                  },
                ),)
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      });
  }

  _handleConnection(ConnectionDto connection) async {
    if (connection.status == null)
      return await _requestConnection();

    if (connection.status == ConnectionStatus.Accepted || connection.status == ConnectionStatus.Pending) {
      return await _deleteConnection(connection);
    }
  }

  _requestConnection() async {
    await _connectionService.addConnection(_userService.currentUser.uid, currentUid);
    setState(() {
      _nextAction = 'Cancel Request';
    });

    _showSnackBar(context, 'Request sent');
  }

  _deleteConnection(ConnectionDto connectionDto) async {
    await _connectionService.deleteConnection(connectionDto);
    setState(() {
      _nextAction = 'Connect';
    });

    _showSnackBar(context, 'Connection deleted');
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  void _setNextAction(ConnectionStatus connectionStatus) {
    switch (connectionStatus) {
      case ConnectionStatus.Pending:
        _nextAction = 'Cancel Request';
        break;
      case ConnectionStatus.Accepted:
        _nextAction = 'Delete Connection';
        break;
      case ConnectionStatus.Declined:
        _nextAction = 'Connect';
        break;
      default:
        _nextAction = 'Connect';
        break;
    }
  }
}