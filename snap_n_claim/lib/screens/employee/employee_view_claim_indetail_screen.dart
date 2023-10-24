import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/employee/employee_add_modify_claim_screen.dart';
import '../../models/employee.dart';

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
  final double deviceWidth = 392.72727272727275;
  final double deviceHeight = 783.2727272727273;

  @override
  void initState() {
    super.initState();
  }

  void _onTapEditBtn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EmployeeAddNewClaim(
            widget._width, widget._height, widget._user,
            requestClaimNo: widget._request["claimNo"]),
      ),
    );
  }

  void _onTapBackBtn(BuildContext context) {
    Navigator.of(context).pop();
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09,
                  vertical: widget._height / 97.909,
                ),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / 1.05,
                  height: widget._height / (deviceHeight / 30),
                  child: const Center(child: Text('Claim header Information')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09,
                  vertical: widget._height / 97.909,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Claim No'),
                          SizedBox(
                            width: widget._width / 3.38,
                            height: widget._height / 20.07,
                            child: TextField(
                              style: TextStyle(
                                fontSize: widget._width / 32.727,
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
                            width: widget._width / 3.38,
                            height: widget._height / 20.07,
                            child: TextField(
                              style:
                                  TextStyle(fontSize: widget._width / 32.727),
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
                            width: widget._width / 3.38,
                            height: widget._height / 20.07,
                            child: TextField(
                                style:
                                    TextStyle(fontSize: widget._width / 32.727),
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
                  horizontal: widget._width / 25.09,
                  vertical: widget._height / 97.909,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Status : "),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget._request["status"] == "Pending"
                            ? const Color(0xFFD2D060)
                            : widget._request["status"] == "Rejected"
                                ? const Color(0xFFBD7171)
                                : widget._request["status"] == "Approved"
                                    ? const Color(0xFF94B698)
                                    : const Color(0xFF98B4F2),
                      ),
                      width: widget._width / 3.27,
                      height: widget._height / 26.76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget._request["status"]),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: widget._width / 7.85,
                    )
                  ],
                ),
              ),
              widget._request["status"] == "Rejected"
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget._width / 25.09,
                        vertical: widget._height / 97.909,
                      ),
                      child: Row(
                        children: [
                          const Text("Reject Reason : "),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red,
                                    width: widget._width / (deviceWidth / 2.0)),
                              ),
                              height: widget._height / (deviceHeight / 60),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          widget._width / (deviceWidth / 2.0)),
                                  child: TextField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: widget._request["rejectReason"]),
                                    minLines: 1,
                                    maxLines: 20,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09,
                  vertical: widget._height / 97.909,
                ),
                child: Container(
                  color: Colors.grey,
                  width: widget._width / 1.05,
                  height: widget._height / (deviceHeight / 30),
                  child: const Center(child: Text('Added Expenses')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget._width / (deviceWidth / 8.0),
                    vertical: widget._height / (deviceHeight / 8.0)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  height: widget._request["status"] != "Rejected"
                      ? widget._height / 1.9
                      : widget._height / 2.3,
                  child: ListView(
                    children: widget._request["lineItems"]
                        .map<Widget>((e) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: widget._height / 100.36,
                                horizontal: widget._width / 39.27,
                              ),
                              child: Container(
                                height: widget._height / 8.029,
                                color: const Color(0x9A5987EF),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: widget._width / 49.09),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(e["invoiceNo"]),
                                        Text(
                                            'Rs.${e["invoiceAmount"].toStringAsFixed(2)}'),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: widget._width / 19.636,
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget._width / 49.09,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: widget._width / 49.09,
                          top: widget._height / 97.909,
                          bottom: widget._height / 97.909),
                      child: ElevatedButton(
                        onPressed: () {
                          _onTapBackBtn(context);
                        },
                        child: const Text('Back'),
                      ),
                    ),
                    widget._request["status"] == "Draft"
                        ? ElevatedButton(
                            onPressed: () {
                              _onTapEditBtn(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Edit'),
                          )
                        : Container(),
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
