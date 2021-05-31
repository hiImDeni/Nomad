import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({this.uid});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(currentUid: uid);
  }

}

class ProfilePageState extends State<ProfilePage> {
  List<PostDto> posts;

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

    return Scaffold(body: FutureBuilder(
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
              Padding(padding: EdgeInsets.only(top: 70)),

              CircularProfileAvatar(
                "",
                child: ClipOval(child: Image.network(user.photoUrl)),
              ),
              Padding(padding: EdgeInsets.only(top: 10, bottom: 15), child:
              Title(color: Colors.black,
                  child: Text("${user.firstName} ${user.lastName}",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),)),
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

                      return CircularProgressIndicator();
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

        return CircularProgressIndicator();
      }));
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