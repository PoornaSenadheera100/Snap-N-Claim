import 'package:flutter/material.dart';

import '../../models/employee.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen(this._width, this._height, this._user, {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Home"),
      ),
      body: const Center(
        child: Text("Welcome"),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
    );
  }
}
