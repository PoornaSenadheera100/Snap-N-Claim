
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/services/email_service.dart';
import 'package:snap_n_claim/services/expense_approval_process_and_sla_calculation_service.dart';
import '../../models/employee.dart';
import '../../models/response.dart';


class ViewClaimInDetail extends StatefulWidget {
  const ViewClaimInDetail(this._width, this._height, this._user, this._request,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;
  final QueryDocumentSnapshot<Object?> _request;



  @override
  State<ViewClaimInDetail> createState() => _ViewClaimInDetail();
}

class _ViewClaimInDetail extends State<ViewClaimInDetail> {
  final double _widthDenominator1 = 1.05;
  bool _isTappedRejectBtn = false;
  late bool _isPending;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rejectReasonController = TextEditingController();
  final double deviceWidth = 392.72727272727275;
  final double deviceHeight = 783.2727272727273;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget._request["status"] == "Pending") {
        _isPending = true;
      } else {
        _isPending = false;
      }
    });
  }

  String? _validateRejectReason(String value) {
    if (value == '') {
      return "This field is required!";
    }
    return null;
  }

  Future<void> _onTapRejectSubmitBtn(BuildContext context) async {
    var dialogRes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to reject this request?'),
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
        "paymentStatus": widget._request["status"],
        "rejectReason": _rejectReasonController.text,
        "status": "Rejected",
        "total": widget._request["total"]
      };

      Response response = await ExpenseApprovalProcessAndSlaCalculationService
          .updateRequestApprovalStatus(updatedClaim);
      if (response.code == 200) {
        Fluttertoast.showToast(
            msg: "Request Rejected!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        EmailService.mailReject(widget._request['claimNo']);
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

  Future<void> _onTapRejectBtn(BuildContext context) async {
    setState(() {
      _isTappedRejectBtn = true;

    });
  }

  Future<void> _onTapApproveBtn(BuildContext context) async {
    var dialogRes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to approve this request?'),
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
        "paymentStatus": widget._request["status"],
        "rejectReason": widget._request["rejectReason"],
        "status": "Approved",
        "total": widget._request["total"]
      };

      Response response = await ExpenseApprovalProcessAndSlaCalculationService
          .updateRequestApprovalStatus(updatedClaim);
      if (response.code == 200) {
        Fluttertoast.showToast(
            msg: "Request Approved!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        EmailService.mailApprove(widget._request['claimNo']);
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

  void _onTapCancelBtn(BuildContext context) {
    Navigator.of(context).pop();
  }

  Widget _rejectReasonBox() {
    return Form(
      key: _formKey,
      child: Container(
        width: widget._width / 1.061425061425061,
        height: widget._height / 26.76363636363636,
        color: const Color(0xD7D7D7FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget._height / 40.14545454545455,
                horizontal: widget._width / 19.63636363636364,
              ),
              child: Text(
                "Enter Reject Reason",
                style: TextStyle(
                  fontSize: widget._width / 19.63636363636364,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget._height / 40.14545454545455,
                horizontal: widget._width / 19.63636363636364,
              ),
              child: TextFormField(
                validator: (value) {
                  return _validateRejectReason(value!);
                },
                controller: _rejectReasonController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type reject reason here",
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isTappedRejectBtn = false;
                      });
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onTapRejectSubmitBtn(context);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Submit"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _loadImg(BuildContext context, String url) async {
    await showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: _loadImage(), // Replace with actual image loading logic
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AlertDialog(
                content: SizedBox(
                  height: widget._height / (deviceHeight / 300),
                  width: widget._width / (deviceWidth / 300),
                  child: Image.network(url),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                content: SizedBox(
                  height: widget._height / (deviceHeight / 300),
                  width: widget._width / (deviceWidth / 300),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              );
            } else {
              return AlertDialog(
                content: SizedBox(
                  height: widget._height / (deviceHeight / 300),
                  width: widget._width / (deviceWidth / 300),
                  child: const Center(
                    child: Text('Failed to load image'),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _loadImage() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Claim ${widget._request["claimNo"]}'),
        ),
        body: SingleChildScrollView(
          child: Form(
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
                    child:
                        const Center(child: Text('Claim header Information')),
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
                                    fontSize:
                                        widget._width / 32.72727272727273),
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
                widget._request["status"] == "Rejected" ?
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 25.09090909090909375,
                    vertical: widget._height / 97.9090909090909125,
                  ),
                  child: Row(
                    children: [
                      Text("Reject Reason : "),
                      Expanded(
                          child: SizedBox(
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(text: widget._request["rejectReason"]),
                        minLines: 1,
                        maxLines: 20,
                        style: TextStyle(color: Colors.red),
                        decoration:
                            InputDecoration(border: OutlineInputBorder(),),
                      )))
                    ],
                  ),
                ) : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909375,
                    vertical: widget._height / 97.9090909090909125,
                  ),
                  child: Container(
                    color: Colors.grey,
                    width: widget._width / _widthDenominator1,
                    child: const Center(child: Text('Added Expenses')),
                  ),
                ),
                SizedBox(
                  height: widget._height / 1.574331550802139,
                  child: _isTappedRejectBtn == false
                      ? ListView(
                          children: widget._request["lineItems"]
                              .map<Widget>((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          widget._height / 100.3636363636364,
                                      horizontal:
                                          widget._width / 39.27272727272727,
                                    ),
                                    child: Container(
                                      height:
                                          widget._height / 8.029090909090909,
                                      color: const Color(0x9A5987EF),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: widget._width /
                                                    49.09090909090909),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(e["invoiceDate"]
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 10)),
                                                Text(
                                                    widget._request["category"])
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
                                              right: widget._width /
                                                  19.63636363636364,
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    _loadImg(context,
                                                        e["invoiceImage"]);
                                                  },
                                                  icon: const Icon(
                                                      Icons.image_rounded),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : _rejectReasonBox(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 49.09090909090909,
                  ),
                  child: _isPending == true
                      ? _isTappedRejectBtn == false
                          ? Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          widget._width / 49.09090909090909375,
                                      vertical:
                                          widget._height / 97.9090909090909125),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _onTapCancelBtn(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _onTapApproveBtn(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: const Text('Approve'),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          widget._width / 49.09090909090909375,
                                      vertical:
                                          widget._height / 97.9090909090909125),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _onTapRejectBtn(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text('Reject'),
                                  ),
                                ),
                              ],
                            )
                          : null
                      : null,
                )
              ],
            ),
          ),
        ),
      );
}
