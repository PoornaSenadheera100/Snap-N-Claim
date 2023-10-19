import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/models/response.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import '../../models/employee.dart';
import '../../services/expense_submission_and_viewing_claim_state_service.dart';

class FinanceAdminClaimsPaymentScreen extends StatefulWidget {
  const FinanceAdminClaimsPaymentScreen(
      this._width, this._height, this.user, this._request,
      {super.key});

  final double _width;
  final double _height;
  final Employee user;
  final QueryDocumentSnapshot<Object?> _request;

  @override
  State<FinanceAdminClaimsPaymentScreen> createState() =>
      _FinanceAdminClaimsPaymentScreenState();
}

class _FinanceAdminClaimsPaymentScreenState
    extends State<FinanceAdminClaimsPaymentScreen> {
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

  void _onTapCancelBtn(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _onTapPayBtn(BuildContext context) async {
    var dialogRes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to mark this claim request as paid?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (dialogRes == true) {
      Map<String, dynamic> updatedClaim = {
        "category": widget._request["category"],
        "claimNo": widget._request["claimNo"],
        "date": widget._request["date"],
        "department": widget._request["department"],
        "empName": widget._request["empName"],
        "empNo": widget._request["empNo"],
        "lineItems": widget._request["lineItems"],
        "paymentStatus": "Paid",
        "rejectReason": widget._request["rejectReason"],
        "status": widget._request["status"],
        "total": widget._request["total"]
      };
      Response response =
          await BudgetAllocationAndReportingService.updateRequestPaymentStatus(
              updatedClaim);
      if (response.code == 200) {
        Fluttertoast.showToast(
            msg: "Marked as Paid!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim ${widget._request["claimNo"]}'),
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
                                controller: TextEditingController(
                                    text: widget._request["claimNo"]),
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
                              controller: TextEditingController(
                                  text: widget._request["date"]
                                      .toDate()
                                      .toString()
                                      .substring(0, 10)),
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
                                controller: TextEditingController(
                                    text:
                                        'Rs.${widget._request["total"].toStringAsFixed(2)}'),
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
              Container(
                  height: 510,
                  child: ListView(
                    children: widget._request["lineItems"]
                        .map<Widget>((e) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: Container(
                                height: 100,
                                color: Color(0x9A5987EF),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(e["invoiceDate"]
                                                .toDate()
                                                .toString()
                                                .substring(0, 10)),
                                            Text(widget._request["category"])
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(e["invoiceNo"]),
                                          Text(
                                              'Rs.${e["invoiceAmount"].toStringAsFixed(2)}'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.attach_file),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  )),
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
                          _onTapCancelBtn(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _onTapPayBtn(context);
                      },
                      child: Text('Mark as Paid'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
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
