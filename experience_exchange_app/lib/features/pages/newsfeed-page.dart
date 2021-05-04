import 'package:flutter/cupertino.dart';

class NewsfeedPage extends StatefulWidget {
  const NewsfeedPage();

  @override
  State<StatefulWidget> createState() {
    return NewsfeedPageState();
  }

}

class NewsfeedPageState extends State<NewsfeedPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Newsfeed Page'),
        ]
      )
    );
  }
}