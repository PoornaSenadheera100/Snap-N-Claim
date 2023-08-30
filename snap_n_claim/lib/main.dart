import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/approver_dashboard_screen.dart';


void main(){
  runApp(SnapNClaim());
}

class SnapNClaim extends StatelessWidget {
  SnapNClaim({super.key});

  late double _width;
  late double _height;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: ApproverDashboardScreen(_width, _height),
    );
  }
}
