import 'package:experience_exchange_app/common/connection-status.dart';
import 'package:experience_exchange_app/common/domain/dtos/connection/connectiondto.dart';
import 'package:experience_exchange_app/common/domain/dtos/user/userdto.dart';
import 'package:experience_exchange_app/features/pages/profile-page.dart';
import 'package:experience_exchange_app/logic/services/connection-service.dart';
import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

class RequestsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RequestsPageState();
  }
}

class RequestsPageState extends State<RequestsPage> {
  UserService _userService;
  ConnectionService _connectionService;

  User _firebaseUser;

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _connectionService = Provider.of<ConnectionService>(context);

    _firebaseUser = _userService.currentUser;

    return Scaffold(
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
                color: Scheme.backgroundColor,
                margin: EdgeInsets.only(left: 15, right: 15),
                height: MediaQuery
                    .of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SafeArea(
                        child:
                        Padding(padding: EdgeInsets.only(top:10, bottom: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Connection Requests', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                              ],
                            )
                        )
                    ),

                    StreamBuilder(
                      stream: _userService.getRequests(_firebaseUser.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)  {
                          return Text(snapshot.error.toString());
                        }

                        if (snapshot.hasData) {
                          var requests = [];

                          snapshot.data.docs.forEach((doc) {
                            requests.add(doc.id);
                          });
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: requests.length,
                            itemBuilder: (context, index) {

                              return FutureBuilder(
                                  future: _userService.getById(requests[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }

                                    if (snapshot.hasData) {
                                      UserDto user = snapshot.data;

                                      return ListTile(
                                        onTap: () async {
                                          await Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                                return ProfilePage(uid: requests[index]);
                                              }
                                          ));
                                        },
                                        leading: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl),),
                                        title: Text('${user.firstName} ${user.lastName}'),
                                        trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                          children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    await _connectionService.acceptConnection(requests[index], _firebaseUser.uid);
                                                  },
                                                  icon: Icon(Icons.check, color: Colors.green,)),

                                              IconButton(
                                                  onPressed: () async {
                                                    await _connectionService.deleteConnection(
                                                        ConnectionDto(requests[index], _firebaseUser.uid, null, ConnectionStatus.Pending));
                                                  },
                                                  icon: Icon(Icons.clear, color: Colors.redAccent,)),
                                          ]
                                      ));
                                    }

                                    return Center(child: CircularProgressIndicator(),);
                                  });
                            },
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  ],
                )
            )
        )
    );
  }
}