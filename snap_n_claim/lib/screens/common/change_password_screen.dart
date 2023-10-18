import 'package:flutter/material.dart';

import '../../models/employee.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this._width, this._height, this._user,{super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Settings"),),
      body: Form(
        key: _formKey,
        child: Column(),
      ),
    );
  }
}
