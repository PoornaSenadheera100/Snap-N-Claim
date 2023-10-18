import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/head_of_department/approver_dashboard_screen.dart';
import 'package:snap_n_claim/screens/common/change_password_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_home_screen.dart';
import 'package:snap_n_claim/screens/head_of_department/hod_home_screen.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';
import 'package:snap_n_claim/services/employee_onboarding_service.dart';

import '../employee/employee_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(this._width, this._height, {super.key});

  final double _width;
  final double _height;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  String? _validateEmail(String text) {
    if (text == "") {
      return "Email / Username is required!";
    } else if (!text.contains("@")) {
      return "Invalid email / username";
    }
    return null;
  }

  String? _validatePassword(String text) {
    if (text == "") {
      return "Password is required!";
    }
    return null;
  }

  Future<void> _validateLogin(BuildContext context) async {
    QuerySnapshot snapshot =
        await EmployeeOnboardingService.getUserByEmail(
            _emailController.text);
    if (snapshot.docs.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please Register Your Account!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_passwordController.text != snapshot.docs[0]["password"]) {
        Fluttertoast.showToast(
            msg: "Invalid Credentials!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        // print(snapshot.docs[0]["email"]);
        Employee employee = await _saveCredentials(snapshot.docs[0]);
        _navigate(employee, context);
      }
    }

    //   var siteManager =
    //   await DBService.login(_emailController.text, _passwordController.text);
    //   if (siteManager.isEmpty) {
    //     Fluttertoast.showToast(
    //         msg: "Invalid Credentials!",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //   } else {
    //     if (siteManager[0]["userRole"] == "site manager") {
    //       SiteManager user = SiteManager(
    //           siteManager[0]["empId"],
    //           siteManager[0]["name"],
    //           siteManager[0]["phoneNumber"],
    //           siteManager[0]["email"],
    //           siteManager[0]["password"],
    //           siteManager[0]["userRole"],
    //           siteManager[0]["siteID"],
    //           siteManager[0]["location"]);
    //
    //       String userData = '{"empId" : "' +
    //           siteManager[0]["empId"] +
    //           '", "name" : "' +
    //           siteManager[0]["name"] +
    //           '", "phoneNumber" : "' +
    //           siteManager[0]["phoneNumber"] +
    //           '", "email" : "' +
    //           siteManager[0]["email"] +
    //           '", "password" : "' +
    //           siteManager[0]["password"] +
    //           '", "userRole" : "' +
    //           siteManager[0]["userRole"] +
    //           '", "siteID" : "' +
    //           siteManager[0]["siteID"] +
    //           '", "location" : "' +
    //           siteManager[0]["location"] +
    //           '"}';
    //       final directory = await getApplicationDocumentsDirectory();
    //       final path = directory.path;
    //       File file = File('$path/userdata.txt');
    //       file.writeAsString(userData);
    //
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) =>
    //               SiteManagerHomePage(widget._width, widget._height, user)));
    //     } else {
    //       Fluttertoast.showToast(
    //           msg: "Unauthorized!",
    //           toastLength: Toast.LENGTH_SHORT,
    //           gravity: ToastGravity.CENTER,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.red,
    //           textColor: Colors.white,
    //           fontSize: 16.0);
    //     }
    //   }
  }

  Future<Employee> _saveCredentials(QueryDocumentSnapshot doc) async {
    // String user = '{
    //   "department": "' + doc["department"] + '",
    //   "email": doc["email"],
    //   "emp_grade": doc["emp_grade"],
    //   "emp_no": doc["emp_no"],
    //   "emp_type": doc["emp_type"],
    //   "first_login": doc["first_login"],
    //   "name": doc["name"],
    //   "password": doc["password"],
    //   "phone": doc["phone"],
    // }';

    String userData = '{"department" : "' +
        doc["department"] +
        '", "email" : "' +
        doc["email"] +
        '", "emp_grade" : "' +
        doc["emp_grade"] +
        '", "emp_no" : "' +
        doc["emp_no"] +
        '", "emp_type" : "' +
        doc["emp_type"] +
        '", "first_login" : "' +
        doc["first_login"].toString() +
        '", "name" : "' +
        doc["name"] +
        '", "password" : "' +
        doc["password"] +
        '", "phone" : "' +
        doc["phone"] +
        '"}';

    Employee employee = Employee(
        doc["emp_no"],
        doc["name"],
        doc["department"],
        doc["email"],
        doc["emp_grade"],
        doc["emp_type"],
        doc["first_login"],
        doc["password"],
        doc["phone"]);

    if(employee.firstLogin == false){
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      File file = File('$path/userdata.txt');
      file.writeAsString(userData);
    }

    return employee;
  }

  void _navigate(Employee employee, BuildContext context) {
    if (employee.empType == "finadmin") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              FinanceAdminHomeScreen(widget._width, widget._height, employee)));
    } else if (employee.empType == "hod") {
      if(employee.firstLogin == false){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                ApproverDashboardScreen(widget._width, widget._height, employee)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangePasswordScreen(widget._width, widget._height, employee)));
      }
    } else {
      if(employee.firstLogin == false){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                EmployeeHomeScreen(widget._width, widget._height, employee)));
      }else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChangePasswordScreen(widget._width, widget._height, employee)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: widget._height / 26.76363636363636,
                  left: widget._width / 6.545454545454545,
                  right: widget._width / 6.545454545454545),
              child: Image.asset(
                "assets/logo.png",
                // scale: 3,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 7.854545454545454),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: _emailController,
                        validator: (text) {
                          return _validateEmail(text!);
                        },
                        onSaved: (text) {},
                        decoration: InputDecoration(
                          hintText: 'name@gmail.com',
                          prefixIcon: Icon(Icons.mail),
                          suffixIcon: _emailController.text.isEmpty
                              ? Container(width: 0)
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => _emailController.clear(),
                                ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (text) {
                          return _validatePassword(text!);
                        },
                        onSaved: (text) {},
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: widget._height / 26.76363636363636),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            _validateLogin(context);
                          }
                        },
                        child: const Text("Login"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
