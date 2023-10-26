import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/models/response.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';
import 'package:snap_n_claim/services/email_service.dart';

import '../../models/employee.dart';

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
  final double _widthDenominator1 = 1.05;
  final double deviceWidth = 392.72727272727275;
  final double deviceHeight = 783.2727272727273;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        EmailService.mailPayment(
            widget._request["claimNo"], widget._request["total"]);
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

  Future<void> _loadImg(BuildContext context, String url) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Image.network(
          url,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return AlertDialog(content: child);
            }
            return AlertDialog(
              content: SizedBox(
                height: widget._height / (deviceHeight / 300),
                width: widget._width / (deviceWidth / 300),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  vertical: widget._height / 97.9090909090909125,
                ),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / _widthDenominator1,
                  height: widget._height / 26.76363636363636,
                  child: const Center(child: Text('Claim header Information')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09090909090909375,
                  vertical: widget._height / 97.9090909090909125,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Claim No'),
                          SizedBox(
                            width: widget._width / 3.385579937304075,
                            height: widget._height / 20.07272727272727,
                            child: TextField(
                              style: TextStyle(
                                fontSize: widget._width / 32.72727272727273,
                              ),
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                text: widget._request["claimNo"],
                              ),
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Claim Date'),
                          SizedBox(
                            width: widget._width / 3.385579937304075,
                            height: widget._height / 20.07272727272727,
                            child: TextField(
                              style: TextStyle(
                                  fontSize: widget._width / 32.72727272727273),
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
                          const Text('Total Amount'),
                          SizedBox(
                            width: widget._width / 3.385579937304075,
                            height: widget._height / 20.07272727272727,
                            child: TextField(
                                style: TextStyle(
                                    fontSize:
                                        widget._width / 32.72727272727273),
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
                  height: widget._height / 26.76363636363636,
                  child: const Center(child: Text('Added Expenses')),
                ),
              ),
              SizedBox(
                height: widget._height / 1.574331550802139,
                child: ListView(
                  children: widget._request["lineItems"]
                      .map<Widget>((e) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: widget._height / 100.3636363636364,
                              horizontal: widget._width / 39.27272727272727,
                            ),
                            child: Container(
                              height: widget._height / 8.029090909090909,
                              color: const Color(0x9A5987EF),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            widget._width / 49.09090909090909),
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
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(e["invoiceNo"]),
                                      Text(
                                          'Rs.${e["invoiceAmount"].toStringAsFixed(2)}'),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: widget._width / 19.63636363636364,
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _loadImg(
                                                context, e["invoiceImage"]);
                                          },
                                          icon: const Icon(Icons.image_rounded),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09090909090909,
                ),
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
                        child: const Text('Cancel'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _onTapPayBtn(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Mark as Paid'),
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
