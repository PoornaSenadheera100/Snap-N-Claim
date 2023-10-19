import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/employee.dart';
import '../../services/expense_submission_and_viewing_claim_state_service.dart';

class EmployeeAddNewClaim extends StatefulWidget {
  const EmployeeAddNewClaim(this._width, this._height, this.user, {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<EmployeeAddNewClaim> createState() => _EmployeeAddNewClaimState();
}

class _EmployeeAddNewClaimState extends State<EmployeeAddNewClaim> {
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

  late Future<QuerySnapshot<Object?>> _collectionReference;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Stream<QuerySnapshot> _collectionReferenceExpenses;

  late final DateTime _currDate;

  @override
  void initState() {
    super.initState();

    _collectionReference =
        ExpenseSubmissionAndViewingClaimStateService.getLatestClaimNo();

    _collectionReference.then((value) {
      _claimNoController.text = value.docs[0].get('claimNo');
      int newClaimNo = int.parse(_claimNoController.text.substring(1)) + 1;

      setState(() {
        _claimNoController.text = 'R' + newClaimNo.toString().padLeft(3, '0');
      });
    });

    _collectionReferenceExpenses =
        ExpenseSubmissionAndViewingClaimStateService.getExpensesByClaimNo(
            _claimNoController.text);

    //set current date
    setState(() {
      _claimDateController.text = DateTime.now().toString().substring(0, 10);
    });

    print('date : ' + _claimDateController.text);
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
                    child: Center(child: Text('Line Item Information'))),
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
                          Text('Invoice Date'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextFormField(
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2101),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _invoiceDateController.text = selectedDate
                                          .toString()
                                          .substring(0, 10);
                                      // _dueDateErrorMsg = '';
                                    });
                                  }
                                },
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _invoiceDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Invoice No.'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextFormField(
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _invoiceNoController,
                                decoration: const InputDecoration(
                                    hintText: 'C001', hintStyle: TextStyle(fontSize: 12),
                                    border: OutlineInputBorder())),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Invoice Amount'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _invoiceAmountController,
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\nClaim Expense'),
                          DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text('Pick Category'),
                                  items: _claimExpenseList.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value, style: TextStyle(fontSize: widget._width / (deviceWidth / 12))),
                                        );
                                      }
                                  ).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _claimExpenseValue = newValue!;
                                    });
                                  },
                                value: _claimExpenseValue.isNotEmpty ? _claimExpenseValue : null,
                              )
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Remaining\nBalance',textAlign: TextAlign.center,),
                          SizedBox(
                            width: widget._width / (deviceWidth / 80),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _remainingBalanceController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Transaction\nLimit' ,textAlign: TextAlign.center,),
                          SizedBox(
                            width: widget._width / (deviceWidth / 80),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                controller: _transactionLimitController,
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: widget._width / (deviceWidth / 50),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo)),
                      ElevatedButton(
                          onPressed: () {
                            validateForm();
                          },
                          child: const Text('Add'))
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
              StreamBuilder(
                  stream: _collectionReferenceExpenses,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (snapshot.data!.docs.length > 0) {
                      return Container(
                        height: widget._height / (deviceHeight / 240),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map(
                                  (e) => Container(child: Text('Data goes here')))
                              .toList(),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: widget._height / (deviceHeight / 240),
                      );
                    }
                  }),
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
