import 'package:flutter/material.dart';

class FinanceAdminExpenseMappingScreen extends StatefulWidget {
  FinanceAdminExpenseMappingScreen(this._width, this._height, this._glCode,
      {super.key});

  double _width;
  double _height;
  String _glCode;

  @override
  State<FinanceAdminExpenseMappingScreen> createState() =>
      _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState
    extends State<FinanceAdminExpenseMappingScreen> {
  final TextEditingController _glCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _glCodeController.text = widget._glCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Mapping"),
      ),
      body: Column(
        children: [
          Text("Expense Info"),
          Row(
            children: [
              Container(
                width: widget._width / 2,
                child: Column(
                  children: [
                    Text("GL Code"),
                    TextField(
                      controller: _glCodeController,
                      readOnly: true,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Text("Transaction Limit"),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              Container(
                width: widget._width / 2,
                child: Column(
                  children: [
                    Text("GL Name"),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Text("Monthly Limit"),
                    TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text("Eligible Employees"),
        ],
      ),
    );
  }
}
