import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/budget_allocation_and_reporting_service.dart';

class FinanceAdminExpenseConfigurationsScreen extends StatefulWidget {
  const FinanceAdminExpenseConfigurationsScreen(this._width, this._height,
      {super.key});

  final double _width;
  final double _height;

  @override
  State<FinanceAdminExpenseConfigurationsScreen> createState() =>
      _FinanceAdminExpenseConfigurationsScreenState();
}

class _FinanceAdminExpenseConfigurationsScreenState
    extends State<FinanceAdminExpenseConfigurationsScreen> {
  late Stream<QuerySnapshot> _collectionReference;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _g001TransLimit = TextEditingController();
  final TextEditingController _g002TransLimit = TextEditingController();
  final TextEditingController _g003TransLimit = TextEditingController();
  final TextEditingController _g004TransLimit = TextEditingController();
  final TextEditingController _g005TransLimit = TextEditingController();
  final TextEditingController _g006TransLimit = TextEditingController();

  final TextEditingController _g001MonthLimit = TextEditingController();
  final TextEditingController _g002MonthLimit = TextEditingController();
  final TextEditingController _g003MonthLimit = TextEditingController();
  final TextEditingController _g004MonthLimit = TextEditingController();
  final TextEditingController _g005MonthLimit = TextEditingController();
  final TextEditingController _g006MonthLimit = TextEditingController();

  late bool isInitial;

  @override
  void initState() {
    super.initState();
    _collectionReference = BudgetAllocationAndReportingService.getExpenses();
    isInitial = true;
  }

  void _assigningValues(){
    if(isInitial == true){
      print("working");

      isInitial = false;
    }
  }

  String? _validateAmount(String text) {
    if (text == '') {
      return "Amount cannot be empty!";
    } else if (text.contains(" ") || text.contains(",") || text.contains("-")) {
      return "Invalid amount!";
    } else if (text.startsWith(".")) {
      return "Invalid amount!";
    } else if (text.length < 4) {
      return "Invalid amount";
    } else if (text.substring(text.length - 3, text.length - 2) != ".") {
      return "Amount must have 2 decimal places!";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Configurations"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (widget._width - widget._width * 3 / 3.2) / 2,
                  vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: widget._width / 3.2,
                      child: Center(
                          child: Text(
                        "GL Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
                  SizedBox(
                      width: widget._width / 3.2,
                      child: Center(
                          child: Text(
                        "Transaction Limit (Rs.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
                  SizedBox(
                      width: widget._width / 3.2,
                      child: Center(
                          child: Text(
                        "Monthly Limit (Rs.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
                ],
              ),
            ),
            StreamBuilder(
                stream: _collectionReference,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator.adaptive(),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("Loading..."),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _assigningValues();
                    return Expanded(
                      child: SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (widget._width - widget._width * 3 / 3.2) /
                                      2),
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("gl_code"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Text("transaction_limit"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: TextFormField(
                                            controller: _g001MonthLimit,
                                        keyboardType: TextInputType.number,
                                        validator: (text) {
                                          return _validateAmount(text!);
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder()),
                                      ))),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState?.save();
                                    }
                                  },
                                  child: Text("Save"))
                            ],
                            // children: snapshot.data!.docs.map((e) {
                            //   return Row(
                            //     children: [
                            //       SizedBox(
                            //           width: widget._width / 3.2,
                            //           child: Center(child: Text(e["gl_code"]))),
                            //       SizedBox(
                            //           width: widget._width / 3.2,
                            //           child: Center(
                            //               child: Text(e["transaction_limit"]
                            //                   .toString()))),
                            //       SizedBox(
                            //           width: widget._width / 3.2,
                            //           child: Center(
                            //               child: TextFormField(
                            //             decoration: InputDecoration(
                            //                 border: OutlineInputBorder()),
                            //           ))),
                            //     ],
                            //   );
                            // }).toList(),
                          ),
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
