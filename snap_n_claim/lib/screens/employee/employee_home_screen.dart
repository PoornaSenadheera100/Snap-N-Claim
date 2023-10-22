import 'package:flutter/material.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

import '../../models/employee.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen(this._width, this._height, this._user, {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  // TODO - Remove
  void sendMail() async {
    final mailer = Mailer(
        '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');
    final toAddress = Address('poornasenadheeraonline@gmail.com');
    final fromAddress = Address('poornasenadheera100@gmail.com');
    final content = Content('text/plain', 'Hello World!');
    final subject = 'Hello Subject!';
    final personalization = Personalization([toAddress]);

    final email = Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      print(result.toString());
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Home"),
      ),
      body: const Center(
        child: Text("Welcome"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            sendMail();
          },
          child: const Icon(Icons.add)),
    );
  }
}
