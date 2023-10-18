import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/common/login_exchange_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: LoginExchangeScreen(_width, _height),
    );
  }
}
