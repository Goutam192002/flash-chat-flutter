import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputFieldDecoration = InputDecoration(
  hintText: 'Hint Text Here',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

const styleUser = BorderRadius.only(
  topLeft: Radius.circular(30.0),
  bottomLeft: Radius.circular(30.0),
  bottomRight: Radius.circular(30.0),
);

const styleSender = BorderRadius.only(
  bottomLeft: Radius.circular(30.0),
  bottomRight: Radius.circular(30.0),
  topRight: Radius.circular(30.0),
);
