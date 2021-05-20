import 'package:experience_exchange_app/logic/services/user-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scheme.dart';

class SearchInput extends StatefulWidget {
  TextEditingController _textEditingController;
  String get text { return this._textEditingController.text; }

  String label;
  Function validator;
  Function action;

  SearchInput({this.label, this.validator, this.action}) { _textEditingController = TextEditingController(); }

  @override
  State<StatefulWidget> createState() {
    return SearchInputState(label: label, validator: validator, textEditingController: _textEditingController, action: action);
  }

}

class SearchInputState extends State<SearchInput> {
  TextEditingController textEditingController;

  String label;
  Function validator;
  Function action;

  UserService _userService;

  SearchInputState({this.label, this.validator, this.textEditingController, this.action});

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

    return
      Container(
        height: 40,
        child:
        TextField(
          controller: textEditingController,

          decoration: InputDecoration(hintText: label,
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
            prefixIcon: IconButton(icon: Icon(Icons.search),
              onPressed: () async {
                await _search(textEditingController.text);
              },
            ),
          ),
        )
    );
  }

  _search(String text) async {
    print('!!!!!!' + text);

    await _userService.searchByName(text).then((result){
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView.builder(
                    itemCount: result.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(result[index].photoUrl),),
                        trailing: Text(result[index].firstName + " " + result[index].lastName),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          ),);
        },
      );
    });
  }
}