import 'package:flutter/material.dart';

import '../../models/employee.dart';

class FinanceAdminViewClaimStatusScreen extends StatefulWidget {
  const FinanceAdminViewClaimStatusScreen(this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<FinanceAdminViewClaimStatusScreen> createState() =>
      _FinanceAdminViewClaimStatusScreenState();
}

class _FinanceAdminViewClaimStatusScreenState
    extends State<FinanceAdminViewClaimStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Claim Report"),),
    );
  }
}
