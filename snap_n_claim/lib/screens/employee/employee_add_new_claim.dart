import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_n_claim/models/request.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import '../../models/employee.dart';
import '../../models/response.dart';
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

  late Stream<QuerySnapshot> _collectionReferenceExpenses =
      const Stream.empty();

  double mainBalance = 0.0;
  double mainTransactionLimit = 0.0;

  late final Request request;

  String imageUrl = '';

  bool isDataAvailable = false;

  late List<Map<String, dynamic>> globalLineItems = [];

  double claimTotal = 0;

  bool shouldAddButtonBeDisabled = false;

  Map<String, dynamic> _expenseLimitInfo = {
    "gl_code": "",
    "gl_name": "",
    "monthly_limit": 0.0,
    "transaction_limit": 0.0
  };

  bool _isEligible = false;

  @override
  void initState() {
    super.initState();

    _collectionReference =
        ExpenseSubmissionAndViewingClaimStateService.getLatestClaimNo();

    _collectionReference.then((value) {
      _claimNoController.text = value.docs[0].get('claimNo');
      int newClaimNo = int.parse(_claimNoController.text.substring(1)) + 1;

      setState(() {
        _claimNoController.text = 'R${newClaimNo.toString().padLeft(3, '0')}';

        _collectionReferenceExpenses =
            ExpenseSubmissionAndViewingClaimStateService.getExpensesByClaimNo(
                _claimNoController.text);
      });
    });

    //set current date
    setState(() {
      _claimDateController.text = DateTime.now().toString().substring(0, 10);
    });

    _totalAmountController.text = '0.0';

    _remainingBalanceController.text = mainBalance.toString();

    _transactionLimitController.text = mainTransactionLimit.toString();
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
    double transactionLimit = mainTransactionLimit;

    if (invoiceAmountString != '') {
      invoiceAmount = double.parse(invoiceAmountString);
    }

    if (transactionLimitString != '') {
      transactionLimit = double.parse(transactionLimitString);
    }

    DateTime currDate = DateTime.now();
    DateTime invoiceDate = DateTime.now();

    if (_invoiceDateController.text != '') {
      invoiceDate = DateTime.parse(_invoiceDateController.text);
    }

    //check if invoiceNo exists in globalLineItems
    bool isInvoiceNoExists = false;
    for (int i = 0; i < globalLineItems.length; i++) {
      if (globalLineItems[i]["invoiceNo"] == _invoiceNoController.text) {
        isInvoiceNoExists = true;
        break;
      }
    }

    double balance = 0.0;

    if (_remainingBalanceController.text != '') {
      balance = double.parse(_remainingBalanceController.text);
    }

    if (_invoiceDateController.text == '') {
      callToast('Invoice date cannot be empty!');
    } else if (invoiceDate.isAfter(currDate)) {
      callToast('Invoice date cannot be after claim date!');
    } else if (_invoiceNoController.text == '') {
      callToast('Invoice number cannot be empty!');
    } else if (isInvoiceNoExists) {
      callToast('Cannot add same invoice number');
    } else if (_invoiceAmountController.text == '') {
      callToast('Invoice amount cannot be empty!');
    } else if (invoiceAmount > transactionLimit) {
      callToast('Invoice amount cannot be greater than limit!');
    } else if (_claimExpenseValue == '') {
      callToast('Claim expense cannot be empty!');
    } else if ((balance - invoiceAmount) < 0) {
      callToast('Claim expense too high, insufficient balance');
    } else if (balance < 0) {
      callToast('Claim expense too high, insufficient balance');
    } else if (imageUrl == '') {
      callToast('Please upload an image');
    } else {
      globalLineItems.add({
        "invoiceAmount": invoiceAmount,
        "invoiceDate": DateTime.parse(_invoiceDateController.text),
        "invoiceImage": imageUrl,
        "invoiceNo": _invoiceNoController.text,
      });

      if (isDataAvailable) {
        sendData(globalLineItems, 'update', invoiceAmount);
      } else {
        sendData(globalLineItems, 'add', invoiceAmount);
      }
    }
  }

  Future<void> updateTotal(String invoiceAmount) async {
    double total = 0.0;
    double amount = 0.0;

    if (_totalAmountController.text != '') {
      total = double.parse(_totalAmountController.text);
    }

    if (invoiceAmount != '') {
      amount = double.parse(invoiceAmount);
    }

    total += amount;

    setState(() {
      _totalAmountController.text = total.toString();
    });

    updateBalance(amount.toString());
  }

  void updateBalance(String total) {
    mainBalance -= double.parse(total);

    setState(() {
      _remainingBalanceController.text = mainBalance.toStringAsFixed(2);
    });
  }

  void clearFields() {
    _invoiceDateController.text = '';
    _invoiceNoController.text = '';
    _invoiceAmountController.text = '';
    _claimExpenseValue = '';
    imageUrl = '';
  }

  Future<void> sendData(List<Map<String, dynamic>> lineItems, String operation,
      double invoiceAmount) async {
    await updateTotal(invoiceAmount.toString());

    String totalAmountString = _totalAmountController.text;
    double totalAmount = 0;

    if (totalAmountString != '') {
      totalAmount = double.parse(totalAmountString);
    }

    Map<String, dynamic> req = <String, dynamic>{
      "claimNo": _claimNoController.text,
      "date": DateTime.parse(_claimDateController.text),
      "category": _claimExpenseValue,
      "empNo": widget.user.empNo,
      "empName": widget.user.name,
      "department": widget.user.department,
      "total": totalAmount,
      "status": "Draft",
      "rejectReason": "",
      "paymentStatus": "Pending",
      "lineItems": lineItems,
    };

    Response response = Response();
    if (operation == 'add') {
      response =
          await ExpenseSubmissionAndViewingClaimStateService.addRequest(req);
    } else if (operation == 'update') {
      response =
          await ExpenseSubmissionAndViewingClaimStateService.updateRequest(
              req, _claimNoController.text);
    }

    if (response.code == 200) {
      clearFields();
    } else {
      invoiceAmount = -invoiceAmount;
      updateTotal(invoiceAmount.toString());
    }
    callToast(response.message);
  }

  Future<void> addImage() async {
    //disable add button
    setState(() {
      shouldAddButtonBeDisabled = true;
    });

    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) {
      setState(() {
        shouldAddButtonBeDisabled = false;
      });

      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //upload to firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //file reference
    Reference referenceImageUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageUpload.putFile(File(file.path));

      imageUrl = await referenceImageUpload.getDownloadURL();

      callToast('Image taken successfully');
      setState(() {
        shouldAddButtonBeDisabled = false;
      });
    } catch (e) {
      callToast('Image could not be taken');
    }
  }

  void showImage(BuildContext context, String url) async {
    await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                  height: widget._height / 2.676363636363636,
                  width: widget._width / 1.309090909090909,
                  child: Image.network(url)),
            ));
  }

  void setDataStatus(bool status) {
    isDataAvailable = status;
  }

  void deleteLineItem(BuildContext context, String claimNo, String invoiceNo,
      String invoiceAmount) async {
    var dialogRes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('This expense will be deleted!'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    return Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));
    if (dialogRes == true) {
      Response response =
          await ExpenseSubmissionAndViewingClaimStateService.deleteLineItem(
              claimNo, invoiceNo);

      if (response.code == 200) {
        globalLineItems
            .removeWhere((element) => element["invoiceNo"] == invoiceNo);
        invoiceAmount = '-$invoiceAmount';
        updateTotal(invoiceAmount);
      }

      callToast(response.message);
    }
  }

  void deleteClaim(BuildContext context, String claimNo) async {
    // if(globalLineItems.isEmpty){
    //   Navigator.of(context).pop();
    // } else {
    var dialogRes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: const Text('You will lose your progress!'),
              content: const Text('Are you sure you want to leave?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    return Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ));

    if (dialogRes == true) {
      Response response =
          await ExpenseSubmissionAndViewingClaimStateService.deleteClaim(
              claimNo);

      if (response.code == 200) {
        Navigator.of(context).pop();
        callToast(response.message);
      } else if (response.code == 404) {
        Navigator.of(context).pop();
      } else {
        callToast(response.message);
      }
    }
    // }
  }

  void updateClaimStatus(BuildContext context, String claimNo) async {
    if (globalLineItems.isNotEmpty) {
      var dialogRes = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                actionsAlignment: MainAxisAlignment.spaceBetween,
                title: const Text('This claim will be submitted'),
                content:
                    const Text('Are you sure you want to submit this claim?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      return Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ));

      if (dialogRes == true) {
        Response response = await ExpenseSubmissionAndViewingClaimStateService
            .updateClaimStatus(claimNo);

        if (response.code == 200) {
          Navigator.of(context).pop();
          callToast('Claim added successfully');
        } else if (response.code == 500) {
          callToast('Claim could not be saved, please try again');
        }
      }
    } else {
      callToast('Please add at least one expense');
    }
  }

  Future<void> _checkEligibility(String category) async {
    _expenseLimitInfo = await ExpenseSubmissionAndViewingClaimStateService.getLimitInfo(category);
    double currentCostInMonth = await ExpenseSubmissionAndViewingClaimStateService.getCurrentCostInMonth(widget.user.department, category);
    setState(() {
      mainTransactionLimit = _expenseLimitInfo["transaction_limit"].toDouble();
      mainBalance = _expenseLimitInfo["monthly_limit"].toDouble() - currentCostInMonth;
    });
    _transactionLimitController.text = _expenseLimitInfo["transaction_limit"].toStringAsFixed(2);
    _remainingBalanceController.text = (_expenseLimitInfo["monthly_limit"].toDouble() - currentCostInMonth).toStringAsFixed(2);
    _isEligible = await BudgetAllocationAndReportingService.hasAllocation(_expenseLimitInfo["gl_code"], widget.user.empGrade, widget.user.department);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              deleteClaim(context, _claimNoController.text);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Add New Claim"),
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
                  height: widget._height / (deviceHeight / 30),
                  child: const Center(child: Text('Claim header Information')),
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
                          const Text('Claim No'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: const TextStyle(fontSize: 12),
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
                          const Text('Claim Date'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                              style: const TextStyle(fontSize: 12),
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
                          const Text('Total Amount (Rs.)'),
                          SizedBox(
                            width: widget._width / (deviceWidth / 116),
                            height: widget._height / (deviceHeight / 40),
                            child: TextField(
                                style: const TextStyle(fontSize: 12),
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
                    height: widget._height / (deviceHeight / 30),
                    child: const Center(child: Text('Line Item Information'))),
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
                        const Text('Invoice Date'),
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
                                  });
                                }
                              },
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              controller: _invoiceDateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                  hintText: 'YYYY-MM-DD',
                                  border: OutlineInputBorder())),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Invoice No.'),
                        SizedBox(
                          width: widget._width / (deviceWidth / 116),
                          height: widget._height / (deviceHeight / 40),
                          child: TextFormField(
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              controller: _invoiceNoController,
                              decoration: const InputDecoration(
                                  hintText: 'CXXX',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder())),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Invoice Amount (Rs.)'),
                        SizedBox(
                          width: widget._width / (deviceWidth / 116),
                          height: widget._height / (deviceHeight / 40),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            controller: _invoiceAmountController,
                            onEditingComplete: () {
                              String value = _invoiceAmountController.text;
                              if (value.isNotEmpty) {
                                _invoiceAmountController.text =
                                    double.parse(value).toStringAsFixed(2);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\nClaim Expense'),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Pick Category'),
                            items: _claimExpenseList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                        fontSize: widget._width /
                                            (deviceWidth / 12))),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              setState(
                                () {
                                  _claimExpenseValue = newValue!;
                                },
                              );
                              _checkEligibility(newValue!);
                            },
                            value: _claimExpenseValue.isNotEmpty
                                ? _claimExpenseValue
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Remaining\nBalance (Rs.)',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: widget._width / (deviceWidth / 80),
                          height: widget._height / (deviceHeight / 40),
                          child: TextField(
                              style: const TextStyle(fontSize: 12),
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
                        const Text(
                          'Transaction\nLimit (Rs.)',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: widget._width / (deviceWidth / 80),
                          height: widget._height / (deviceHeight / 40),
                          child: TextField(
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                              controller: _transactionLimitController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder())),
                        ),
                      ],
                    ),
                  ],
                ),
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
                    IconButton(
                        onPressed: () async {
                          await addImage();
                        },
                        icon: const Icon(Icons.add_a_photo)),
                    ElevatedButton(
                        onPressed: shouldAddButtonBeDisabled
                            ? null
                            : () {
                          if(_isEligible == false && _claimExpenseValue != ''){
                            callToast("Not eligible for this category!");

                          }else{
                            validateForm();
                          }

                              },
                        child: const Text('Add'))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909375,
                    vertical: widget._height / 97.9090909090909125),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / _widthDenominator1,
                  height: widget._height / (deviceHeight / 30),
                  child: const Center(child: Text('Added Expenses')),
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
                    } else if (!snapshot.hasData) {
                      setDataStatus(false);

                      return SizedBox(
                        height: widget._height / (deviceHeight / 200),
                        child: Center(
                          child: SizedBox(
                            width: widget._width / (deviceWidth / 123),
                            child: const Text('No expenses added'),
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.isNotEmpty) {
                      setDataStatus(true);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget._width / (deviceWidth / 8)),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey, width: 2.0),
                          ),
                          height: widget._height / (deviceHeight / 200),
                          child: ListView(
                            children: snapshot.data!.docs.map((e) {
                              List<dynamic> lineItems = e['lineItems'];

                              List<Widget> lineItemWidgets =
                                  lineItems.map((lineItem) {
                                return Card(
                                  color: Colors.blueAccent,
                                  child: SizedBox(
                                    width: widget._width / (deviceWidth / 400),
                                    height:
                                        widget._height / (deviceHeight / 55),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: widget._width /
                                                      (deviceWidth / 8)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${lineItem['invoiceDate'].toDate().day}/${lineItem['invoiceDate'].toDate().month}/${lineItem['invoiceDate'].toDate().year}"),
                                                  Text("${e['category']}"),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${lineItem['invoiceNo']}"),
                                                Text(
                                                    "Rs : ${lineItem['invoiceAmount'].toStringAsFixed(2)}"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      deleteLineItem(
                                                          context,
                                                          _claimNoController
                                                              .text,
                                                          "${lineItem['invoiceNo']}",
                                                          "${lineItem['invoiceAmount']}");
                                                    },
                                                    icon: const Icon(
                                                        Icons.cancel_outlined)),
                                                IconButton(
                                                    onPressed: () {
                                                      showImage(
                                                          context,
                                                          lineItem[
                                                              'invoiceImage']);
                                                    },
                                                    icon: const Icon(
                                                        Icons.image_rounded)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList();

                              return Column(
                                children: lineItemWidgets,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      setDataStatus(false);

                      return SizedBox(
                        height: widget._height / (deviceHeight / 200),
                        child: Center(
                          child: SizedBox(
                            width: widget._width / (deviceWidth / 123),
                            child: const Text('No expenses added'),
                          ),
                        ),
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
                        onPressed: () {
                          deleteClaim(context, _claimNoController.text);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Cancel'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: widget._height / 97.9090909090909125,
                          right: widget._width / 49.09090909090909375,
                          top: widget._height / 97.9090909090909125),
                      child: Tooltip(
                        key: tooltipkey,
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: const Duration(seconds: 3),
                        message: 'Add atleast one expense to save as a draft',
                        child: ElevatedButton(
                          onPressed: globalLineItems.isEmpty
                              ? null
                              : () async {
                                  var dialogRes = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            title: const Text(
                                                'This claim will be saved as a draft'),
                                            content: const Text(
                                                'Are you sure you want to save this for later?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  return Navigator.pop(
                                                      context, true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ));

                                  if (dialogRes == true) {
                                    Navigator.of(context).pop();
                                    callToast('Claim saved as a draft');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Draft'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateClaimStatus(context, _claimNoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Submit'),
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
