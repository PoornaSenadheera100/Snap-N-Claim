import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';

class HodHomeScreen extends StatelessWidget {
  const HodHomeScreen(this._width, this._height, this._user,{super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HoD Home"),),
      body: const Center(child: Text("Welcome"),),
      floatingActionButton: FloatingActionButton(onPressed: (){}, child: const Icon(Icons.add)),
    );
  }
}
