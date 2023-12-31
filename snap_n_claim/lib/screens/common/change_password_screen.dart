import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/models/response.dart';
import 'package:snap_n_claim/screens/head_of_department/approver_dashboard_screen.dart';
import 'package:snap_n_claim/services/employee_onboarding_service.dart';

import '../../models/employee.dart';
import '../employee/employee_home_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  String? _validateNewPassword(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (value.length < 8) {
      return "Password should have minimum 8 characters!";
    }
    return null;
  }

  String? _validateRetypePassword(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (value != _newPasswordController.text) {
      return "Passwords do not match!";
    }
    return null;
  }

  Future<void> _updateUser() async {
    widget._user.firstLogin = false;
    widget._user.password = _newPasswordController.text;
    Response response =
        await EmployeeOnboardingService.updateEmployee(widget._user);
    if (response.code == 200) {
      Fluttertoast.showToast(
          msg: "Password Updated!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      await _saveCredentials();
      _navigate();
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _saveCredentials() async {
    String userData = '{"department" : "' +
        widget._user.department +
        '", "email" : "' +
        widget._user.email +
        '", "emp_grade" : "' +
        widget._user.empGrade +
        '", "emp_no" : "' +
        widget._user.empNo +
        '", "emp_type" : "' +
        widget._user.empType +
        '", "first_login" : "' +
        widget._user.firstLogin.toString() +
        '", "name" : "' +
        widget._user.name +
        '", "password" : "' +
        widget._user.password +
        '", "phone" : "' +
        widget._user.phone +
        '"}';

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/userdata.txt');
    file.writeAsString(userData);
  }

  void _navigate() {
    if (widget._user.empType == "hod") {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ApproverDashboardScreen(
              widget._width, widget._height, widget._user)));
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              EmployeeHomeScreen(widget._width, widget._height, widget._user)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(widget._width / 49.09090909090909),
          child: Column(
            children: [
               Padding(
                padding: EdgeInsets.symmetric(vertical: widget._height / 40.14545454545455),
                child: Text(
                  "Please change your password from the initial password.",
                  style: TextStyle(fontSize: widget._width / 26.18181818181818),
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: _newPasswordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "New Password"),
                validator: (value) {
                  return _validateNewPassword(value!);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: widget._height / 40.14545454545455),
                child: TextFormField(
                  obscureText: true,
                  controller: _retypePasswordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Re-type Password"),
                  validator: (value) {
                    return _validateRetypePassword(value!);
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateUser();
                    }
                  },
                  child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
