import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  late Stream<QuerySnapshot> _collectionReference1;
  late Stream<QuerySnapshot> _collectionReference2;

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
    _collectionReference1 = BudgetAllocationAndReportingService.getExpenses();
    isInitial = true;
  }

  Future<void> _assigningValues() async {
    if (isInitial == true) {
      _collectionReference2 =
          await BudgetAllocationAndReportingService.getExpenses();
      List<Map<String, dynamic>> documentDataList = [];
      _collectionReference2.forEach((querySnapshot) {
        querySnapshot.docs.forEach((documentSnapshot) {
          Map<String, dynamic> documentData =
              documentSnapshot.data() as Map<String, dynamic>;
          documentData['documentId'] = documentSnapshot.id;
          documentDataList.add(documentData);
        });

        _g001TransLimit.text =
            documentDataList[0]["transaction_limit"].toStringAsFixed(2);
        _g001MonthLimit.text =
            documentDataList[0]["monthly_limit"].toStringAsFixed(2);
        _g002TransLimit.text =
            documentDataList[1]["transaction_limit"].toStringAsFixed(2);
        _g002MonthLimit.text =
            documentDataList[1]["monthly_limit"].toStringAsFixed(2);
        _g003TransLimit.text =
            documentDataList[2]["transaction_limit"].toStringAsFixed(2);
        _g003MonthLimit.text =
            documentDataList[2]["monthly_limit"].toStringAsFixed(2);
        _g004TransLimit.text =
            documentDataList[3]["transaction_limit"].toStringAsFixed(2);
        _g004MonthLimit.text =
            documentDataList[3]["monthly_limit"].toStringAsFixed(2);
        _g005TransLimit.text =
            documentDataList[4]["transaction_limit"].toStringAsFixed(2);
        _g005MonthLimit.text =
            documentDataList[4]["monthly_limit"].toStringAsFixed(2);
        _g006TransLimit.text =
            documentDataList[5]["transaction_limit"].toStringAsFixed(2);
        _g006MonthLimit.text =
            documentDataList[5]["monthly_limit"].toStringAsFixed(2);
      });

      isInitial = false;
    }
  }

  String? _validateAmount(String text) {
    if (text == '') {
      Fluttertoast.showToast(
          msg: "Amount cannot be empty!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Invalid amount!";
    } else if (text.contains(" ") || text.contains(",") || text.contains("-")) {
      Fluttertoast.showToast(
          msg: "Invalid amount!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Invalid amount!";
    } else if (text.startsWith(".")) {
      Fluttertoast.showToast(
          msg: "Invalid amount!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Invalid amount!";
    } else if (text.length < 4) {
      Fluttertoast.showToast(
          msg: "Invalid amount!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Invalid amount";
    } else if (text.substring(text.length - 3, text.length - 2) != ".") {
      Fluttertoast.showToast(
          msg: "Amount must have 2 decimal places!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Invalid amount!";
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
        title: const Text("Expense Configurations"),
      ),
      body: StreamBuilder(
          stream: _collectionReference1,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              (widget._width - widget._width * 3 / 3.2) / 2,
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
                    Expanded(
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
                                      child: Center(child: Text("G001"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g001TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g001MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("G002"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g002TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g002MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("G003"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g003TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g003MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("G004"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g004TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g004MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("G005"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g005TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g005MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(child: Text("G006"))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g006TransLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
                                      ))),
                                  SizedBox(
                                      width: widget._width / 3.2,
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: TextFormField(
                                          controller: _g006MonthLimit,
                                          keyboardType: TextInputType.number,
                                          validator: (text) {
                                            return _validateAmount(text!);
                                          },
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder()),
                                        ),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
