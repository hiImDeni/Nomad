import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  TextEditingController textEditingController;

  String get text { return this.textEditingController.text; }
  set text(String message) { this.textEditingController.text = message; }

  Function action;
  bool enabled;

  ChatInput({@required this.action, this.enabled}) { textEditingController = TextEditingController(); }

  @override
  State<StatefulWidget> createState() {
    return ChatInputState();
  }
}

class ChatInputState extends State<ChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          maxLines: 5,
          minLines: 1,
          enabled: widget.enabled != null ? widget.enabled : true,
          textCapitalization: TextCapitalization.sentences,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            hintText: 'Type your message',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: widget.action,
            ),
            border: InputBorder.none,
          ),
        )
    );
  }
}