import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snap_n_claim/models/response.dart';
import 'package:snap_n_claim/screens/head_of_department/approver_dashboard_screen.dart';
import 'package:snap_n_claim/services/employee_onboarding_service.dart';

import '../../models/employee.dart';
import '../employee/employee_home_screen.dart';
import 'finance_admin_menu_drawer.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen(this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreen();
}

class _CreateAccountScreen extends State<CreateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeNoController = TextEditingController();
  final TextEditingController _employeeEmailController =
  TextEditingController();
  final TextEditingController _employeeNameController =
  TextEditingController();
  final TextEditingController _employeeInitialPasswordController =
  TextEditingController();
  final List<String> employeeDepartmentList = <String>['Production Department', 'IT Department', 'Finance Department', 'HR Department','Marketing Department','Safety and Security Department'];
  final List<String> employeeGradesList = <String>['Junior', 'Senior', 'Manager', 'Executive','Senior Executive'];
  String _departmentDropdownValue = "";
  String _employeeGradeDropdownValue = '';
  String? _validateEmployeeNo(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (value.length != 4 || !RegExp(r'^E\d{3}$').hasMatch(value)) {
      return "Employee number should follow the pattern 'E001', 'E002', etc.";
    }
    return null;
  }

  String? _validateEmployeeName(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (RegExp(r'\d').hasMatch(value)) {
      return "Employee name should not contain numerical values!";
    }
    return null;
  }
  String? _validateEmployeeInitialPassword(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (value.length < 8) {
      return "Password should have minimum 8 characters!";
    }
    return null;
  }

  String? _validateEmployeeEmail(String value) {
    if (value == '') {
      return "This field is required!";
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
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
        title: const Text("Create Account"),
      ),
      drawer: FinanceAdminMenuDrawer(
          widget._width, widget._height, "User Configuration Screen", widget._user),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Please change your password from the initial password.",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: _employeeNoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Employee No"),
                validator: (value) {
                  return _validateEmployeeNo(value!);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _employeeNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Employee Name"),
                  validator: (value) {
                    return _validateEmployeeName(value!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _employeeEmailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Employee Email"),
                  validator: (value) {
                    return _validateEmployeeEmail(value!);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _employeeInitialPasswordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Initial Password"),
                  validator: (value) {
                    return _validateEmployeeInitialPassword(value!);
                  },
                ),
              ),
 // Add some spacing between the TextFormField and Dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: _employeeGradeDropdownValue.isNotEmpty
                        ? _employeeGradeDropdownValue
                        : null,
                    hint: const Text("Employee Grade"),
                    items: employeeGradesList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize:
                              widget._width / 26.18181818181818),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _employeeGradeDropdownValue = newValue!;
                      });
                      // _filterClaims(_empNoController.text);
                    }),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: _departmentDropdownValue.isNotEmpty
                        ? _departmentDropdownValue
                        : null,
                    hint: const Text("Departments"),
                    items: employeeDepartmentList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize:
                              widget._width / 26.18181818181818),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _departmentDropdownValue = newValue!;
                      });
                      // _filterClaims(_empNoController.text);
                    }),
              ),
              // DropdownButton<String>(
              //   value: _selectedEmployeeGrade,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       _selectedEmployeeGrade = newValue!; // Use the null assertion operator
              //     });
              //   },
              //   items: employeeGradesList
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   })
              //       .toList(),
              // ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // _updateUser();
                    }
                  },
                  child: const Text("Create Account"))
            ],
          ),
        ),
      ),
    );
  }
}
