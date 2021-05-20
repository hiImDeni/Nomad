import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  TextEditingController textEditingController;
  String get text { return this.textEditingController.text; }

  Function action;

  ChatInput({@required this.action}) { textEditingController = TextEditingController(); }

  @override
  State<StatefulWidget> createState() {
    return ChatInputState();
  }
}

class ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            hintText: 'Type your message',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: widget.action,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        )
    );
  }
}