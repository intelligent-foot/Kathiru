import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white54, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);

TextStyle simpleTextFieldStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      )));
}

void nextScreen(context, page) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}
