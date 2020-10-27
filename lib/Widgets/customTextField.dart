import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObscure = true;

  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
