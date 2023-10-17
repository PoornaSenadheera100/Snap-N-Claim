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
  List<String> _statusDropdownItems = ["Approved", "Rejected"];
  String _statusDropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Claim Report"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 70,
              color: Color(0xFFD7D7D7),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text("Search"),
                  ),
                  Expanded(
                      child: SizedBox(
                          child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Emp No",),
                  ))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text("Filter"),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: _statusDropdownValue.isNotEmpty
                            ? _statusDropdownValue
                            : null,
                        hint: const Text("Status"),
                        items: _statusDropdownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: widget._width / 26.18181818181818),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _statusDropdownValue = newValue!;
                          });
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
