import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _rejectReasonController = TextEditingController();

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
        width: 370,
        height: 30,
        color: Color(0xD7D7D7FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20,
              ),
              child: Text(
                "Enter Reject Reason",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: TextFormField(
                validator: (value) {
                  return _validateRejectReason(value!);
                },
                controller: _rejectReasonController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Type reject reason here",
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isTappedRejectBtn = false;
                      });
                    },
                    child: Text("Cancel"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _onTapRejectSubmitBtn(context);
                      }
                    },
                    child: Text("Submit"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
                      horizontal: widget._width / 49.09090909090909375,
                      vertical: widget._height / 97.9090909090909125),
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
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.attach_file),
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
                  child: _isTappedRejectBtn == false
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
                      : null,
                )
              ],
            ),
          ),
        ),
      );

  //     Scaffold(
  //   appBar: AppBar(
  //     title: Text("Delivery Note"),
  //   ),
  //   body: Center(
  //     child: ListView(
  //     padding: EdgeInsets.all(32),
  //     children: [
  //     const SizedBox(height: 24),
  //     Padding(
  //     padding: const EdgeInsets.only(bottom: 8),
  //     child: PONumber(),
  //     ),
  //     Padding(
  //            padding: const EdgeInsets.only(bottom: 8),
  //     child: ClaimDate(),
  //          ),
  //          Padding(
  //            padding: const EdgeInsets.only(bottom: 8),
  //            child: Location(),
  //          ),
  //          Padding(
  //            padding: const EdgeInsets.only(bottom: 8),
  //            child: SiteManagerName(),
  //          ),
  //          Padding(
  //            padding: const EdgeInsets.only(bottom: 8),
  //            child: Items(),
  //          ),
  //          Padding(
  //            padding: const EdgeInsets.only(bottom: 8.0),
  //            child: Quantity(),
  //         ),
  //          // Padding(
  //          //   padding: const EdgeInsets.only(bottom: 8.0),
  //          //   child: supplier(),
  //          // ),
  //          // Padding(
  //          //   padding: const EdgeInsets.only(bottom: 8.0),
  //          //   child: Total(),
  //          // ),
  //          // widget._visible==true ?
  //          Row(
  //            mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //            children: [
  //              ElevatedButton(
  //                child: Text('Confirm'),
  //                onPressed: () {
  //                  // _onTapConfirmationBtns(context, "Confirmed");
  //                },
  //              ),
  //              ElevatedButton(
  //                child: Text('Reject'),
  //                onPressed: () {
  //                  // _onTapConfirmationBtns(context, "Rejected");
  //                },
  //              ),
  //            ],
  //          ) ,
  //         const SizedBox(height: 24),
  //          const SizedBox(height: 24),
  //        ],
  //      ),
  //   ),
  // );

  Widget PONumber() => TextField(
        decoration: InputDecoration(
          labelText: 'PO Number',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        controller: TextEditingController(text: widget._request["claimNo"]),
      );

  Widget ClaimDate() {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Claim Date',
        border: OutlineInputBorder(),
      ),
      // controller: TextEditingController(
      //     text: _purchaseOrder2["date"] == null
      //         ? ''
      //         : _purchaseOrder2["date"].toString().substring(0, 10)!),
    );
  }

  Widget Location() => TextField(
        decoration: InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        // controller: TextEditingController(text:["empName"]),
      );

  Widget SiteManagerName() => TextField(
        decoration: InputDecoration(
          labelText: 'Site Manager Name',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        controller: TextEditingController(text: widget._user.name),
      );

  Widget Items() => TextField(
        decoration: InputDecoration(
          labelText: 'Item',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        // controller: TextEditingController(text: widget._deliveryNote["itemName"]),
      );

  Widget Quantity() => TextField(
      decoration: InputDecoration(
        labelText: 'Quantity',
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      controller: null
      // TextEditingController(text: widget._deliveryNote["qty"].toString()),
      );

  Widget buildEmail() => TextField(
        // controller: emailController,
        //   decoration: InputDecoration(
        //     hintText: 'name@gmail.com',
        //  prefixIcon: Icon(Icons.mail),
        //   suffixIcon: emailController.text.isEmpty
        //       ? Container(width: 0)
        //       : IconButton(
        //     icon: Icon(Icons.close),
        //     onPressed: () => emailController.clear(),
        //   ),
        //   border: OutlineInputBorder(),
        // ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,

        // Widget displaySupplier() => DataTable(
        //   columns: const <DataColumn>[
        //     DataColumn(
        //       label: Expanded(
        //         child: Text(
        //           'Name',
        //          style: TextStyle(fontStyle: FontStyle.italic),
        //         ),
        //       ),
        //     ),
        //    DataColumn(
        //       label: Expanded(
        //         child: Text(
        //           'Age',
        //           style: TextStyle(fontStyle: FontStyle.italic),
        //         ),
        //       ),
        //    ),
        //     DataColumn(
        //       label: Expanded(
        //         child: Text(
        //         'Role',
        //           style: TextStyle(fontStyle: FontStyle.italic),
        //          ),
        //        ),
        //      ),
        //    ],
        //    rows: const <DataRow>[
        //      DataRow(
        //        cells: <DataCell>[
        //          DataCell(Text('Sarah')),
        //          DataCell(Text('19')),
        //          DataCell(Text('Student')),
        //        ],
        //      ),
        //      DataRow(
        //        cells: <DataCell>[
        //          DataCell(Text('Janine')),
        //          DataCell(Text('43')),
        //          DataCell(Text('Professor')),
        //        ],
        //      ),
        //      DataRow(
        //        cells: <DataCell>[
        //          DataCell(Text('William')),
        //          DataCell(Text('27')),
        //          DataCell(Text('Associate Professor')),
        //        ],
        //      ),
        //    ],
        //  );

        // Widget supplier() => TextField(
        //     decoration: InputDecoration(
        //       labelText: 'Supplier',
        //       border: OutlineInputBorder(),
        //     ),
        //     readOnly: true,
        //     controller: TextEditingController(
        //       text: widget._deliveryNote["supplierId"],
        //     ));
        //
        // Widget Total() => TextField(
        //   decoration: InputDecoration(
        //     labelText: 'Total',
        //     border: OutlineInputBorder(),
        //   ),
        //   readOnly: true,
        //   controller: TextEditingController(
        //       text: (widget._deliveryNote["qty"] *
        //           widget._deliveryNote["unitPrice"])
        //           .toString()),
      );
}
