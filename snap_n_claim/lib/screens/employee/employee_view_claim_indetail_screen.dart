import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/services/expense_approval_process_and_sla_calculation_service.dart';
import '../../models/employee.dart';
import '../../models/response.dart';

class EmployeeViewClaimIndetailScreen extends StatefulWidget {
  const EmployeeViewClaimIndetailScreen(
      this._width, this._height, this._user, this._request,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;
  final QueryDocumentSnapshot<Object?> _request;

  @override
  State<EmployeeViewClaimIndetailScreen> createState() => _ViewClaimInDetail();
}

class _ViewClaimInDetail extends State<EmployeeViewClaimIndetailScreen> {
  final double _widthDenominator1 = 1.05;
  bool _isTappedRejectBtn = false;
  late bool _isPending;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rejectReasonController = TextEditingController();

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

      // Response response = await ExpenseApprovalProcessAndSlaCalculationService
      //     .updateRequestApprovalStatus(updatedClaim);
      // if (response.code == 200) {
      //   Fluttertoast.showToast(
      //       msg: "Request Rejected!",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.green,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   Navigator.of(context).pop();
      // } else {
      //   Fluttertoast.showToast(
      //       msg: "Something went wrong!",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.red,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
    }
  }

  void _onTapEditBtn(BuildContext context) {}

  void _onTapBackBtn(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _loadImg(BuildContext context, String url) async {
    var dialogRes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                height: widget._height / 2.676363636363636,
                width: widget._width / 1.309090909090909,
                child: Image.network(url),
              ),
            ));
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget._width / 25.09090909090909375,
                    vertical: widget._height / 97.9090909090909125,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Status : "),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: widget._request["status"] == "Pending"
                              ? Colors.yellow
                              : widget._request["status"] == "Rejected"
                                  ? Colors.red
                                  : widget._request["status"] == "Approved"
                                      ? Colors.green
                                      : Colors.blueAccent,
                        ),
                        width: 120,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget._request["status"]),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  ),
                ),
                widget._request["status"] == "Rejected"
                    ? Padding(
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
                              controller: TextEditingController(
                                  text: widget._request["rejectReason"]),
                              minLines: 1,
                              maxLines: 20,
                              style: TextStyle(color: Colors.red),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )))
                          ],
                        ),
                      )
                    : Container(),
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
                  height: widget._height / 1.674331550802139,
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
                                        right:
                                            widget._width / 19.63636363636364,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _loadImg(
                                                  context, e["invoiceImage"]);
                                            },
                                            icon:
                                                const Icon(Icons.image_rounded),
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
                            _onTapBackBtn(context);
                          },
                          child: const Text('Back'),
                        ),
                      ),
                      widget._request["status"] == "Draft" ?
                      ElevatedButton(
                        onPressed: () {
                          _onTapEditBtn(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Edit'),
                      ) : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
