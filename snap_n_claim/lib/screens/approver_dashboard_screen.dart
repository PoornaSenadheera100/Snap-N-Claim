import 'package:flutter/material.dart';

class ApproverDashboardScreen extends StatefulWidget {
  const ApproverDashboardScreen(this._width, this._height, {Key? key})
      : super(key: key);

  final double _width;
  final double _height;

  @override
  State<ApproverDashboardScreen> createState() =>
      _ApproverDashboardScreenState();
}

class _ApproverDashboardScreenState extends State<ApproverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: Text("Approver Dashboard Screen")));
  }
}
