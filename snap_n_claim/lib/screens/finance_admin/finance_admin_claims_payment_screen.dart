import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/employee.dart';
import '../../services/expense_submission_and_viewing_claim_state_service.dart';

class FinanceAdminClaimsPaymentScreen extends StatefulWidget {
  const FinanceAdminClaimsPaymentScreen(this._width, this._height, this.user, {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<FinanceAdminClaimsPaymentScreen> createState() => _FinanceAdminClaimsPaymentScreenState();
}

class _FinanceAdminClaimsPaymentScreenState extends State<FinanceAdminClaimsPaymentScreen> {
  final double _heightDenominator1 = 40.14545454545455;
  final double _heightDenominator2 = 80.29090909090909;
  final double _widthDenominator1 = 1.05;

  final double deviceWidth = 392.72727272727275;
  final double deviceHeight = 783.2727272727273;

  final TextEditingController _claimNoController = TextEditingController();
  final TextEditingController _claimDateController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _invoiceAmountController =
      TextEditingController();
  late String _claimExpenseValue = '';
  final TextEditingController _remainingBalanceController =
      TextEditingController();
  final TextEditingController _transactionLimitController =
      TextEditingController();

  final List<String> _claimExpenseList = [
    "Transportation",
    "Accommodation",
    "Meals and Food",
    "Health and Safety",
    "Equipment and Supplies",
    "Communication"
  ];

  // late Future<QuerySnapshot<Object?>> _collectionReference;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Stream<QuerySnapshot> _collectionReferenceExpenses;

  late final DateTime _currDate;

  @override
  void initState() {
    super.initState();

    // _collectionReference =
    //     ExpenseSubmissionAndViewingClaimStateService.getLatestClaimNo();

    // _collectionReference.then((value) {
    //   _claimNoController.text = value.docs[0].get('claimNo');
    //   int newClaimNo = int.parse(_claimNoController.text.substring(1)) + 1;

    //   setState(() {
    //     _claimNoController.text = 'R' + newClaimNo.toString().padLeft(3, '0');
    //   });
    // });

    // _collectionReferenceExpenses =
    //     ExpenseSubmissionAndViewingClaimStateService.getExpensesByClaimNo(
    //         _claimNoController.text);

    //set current date
    // setState(() {
    //   _claimDateController.text = DateTime.now().toString().substring(0, 10);
    // });
    //
    // print('date : ' + _claimDateController.text);
  }

  void callToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void validateForm() {
    String invoiceAmountString = _invoiceAmountController.text;
    String transactionLimitString = _transactionLimitController.text;

    double invoiceAmount = 0.0;
    double transactionLimit = 0.0;

    if(invoiceAmountString != ''){
      invoiceAmount = double.parse(invoiceAmountString);
    }

    if(transactionLimitString != ''){
      transactionLimit = double.parse(transactionLimitString);

    }

    DateTime currDate = DateTime.now();
    DateTime invoiceDate = DateTime.now();

    if(_invoiceDateController.text != ''){
      invoiceDate = DateTime.parse(_invoiceDateController.text);
    }

    int balance = 0;

    if(_remainingBalanceController.text != ''){
      balance = int.parse(_remainingBalanceController.text);
    }

    if (_invoiceDateController.text == '') {
      callToast('Invoice date cannot be empty!');
    } else if (invoiceDate.isAfter(currDate)) {
      callToast('Invoice date cannot be after claim date!');
    } else if (_invoiceNoController.text == '') {
      callToast('Invoice number cannot be empty!');
    } else if (_invoiceAmountController.text == '') {
      callToast('Invoice amount cannot be empty!');
    } else if (invoiceAmount > transactionLimit) {
      callToast('Invoice amount cannot be greater than limit!');
    } else if (_claimExpenseValue == '') {
      callToast('Claim expense cannot be empty!');
    } else if (balance < 0 ){
      callToast('Claim expense too high, insufficient balance');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Claim"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909375,
                    vertical: widget._height / 97.9090909090909125),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / _widthDenominator1,
                  child: Center(child: Text('Claim header Information')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909375,
                    vertical: widget._height / 97.9090909090909125),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('Claim No'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _claimNoController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Claim Date'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              controller: _claimDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Total Amount'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _totalAmountController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                        ],
                      ),
                    ]),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909375,
                    vertical: widget._height / 97.9090909090909125),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / _widthDenominator1,
                  child: Center(child: Text('Added Expenses')),
                ),
              ),
              // ListView(children: [Text("data")],),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / (deviceWidth / 8)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget._width / 49.09090909090909375,
                          vertical: widget._height / 97.9090909090909125),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Cancel'),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Submit'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
