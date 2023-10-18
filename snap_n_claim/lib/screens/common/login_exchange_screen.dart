import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/screens/head_of_department/approver_dashboard_screen.dart';
import 'package:snap_n_claim/screens/employee/employee_home_screen.dart';

import '../../models/employee.dart';
import '../finance_admin/finance_admin_home_screen.dart';
import 'login_screen.dart';

class LoginExchangeScreen extends StatefulWidget {
  const LoginExchangeScreen(this._width, this._height, {super.key});

  final double _width;
  final double _height;

  @override
  State<LoginExchangeScreen> createState() => _LoginExchangeScreenState();
}

class _LoginExchangeScreenState extends State<LoginExchangeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/userdata.txt');
    try {
      final userData = await file.readAsString();
      if (userData != '') {
        Map decodedUser = jsonDecode(userData);
        Employee user = Employee(
            decodedUser["emp_no"],
            decodedUser["name"],
            decodedUser["department"],
            decodedUser["email"],
            decodedUser["emp_grade"],
            decodedUser["emp_type"],
            decodedUser["first_login"] == "true",
            decodedUser["password"],
            decodedUser["phone"]);

        _navigate(user);
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginScreen(widget._width, widget._height)));
      }
    } catch (e) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              LoginScreen(widget._width, widget._height)));
    }
  }

  void _navigate(Employee employee) {
    if (employee.empType == "finadmin") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              FinanceAdminHomeScreen(widget._width, widget._height, employee)));
    } else if (employee.empType == "hod") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              ApproverDashboardScreen(widget._width, widget._height, employee)));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              EmployeeHomeScreen(widget._width, widget._height, employee)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
