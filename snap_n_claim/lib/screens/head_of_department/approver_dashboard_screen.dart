import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/head_of_department/approver_menu_drawer.dart';

import '../../models/employee.dart';
import '../../services/expense_approval_process_and_sla_calculation_service.dart';
import 'approver_viewclaimindetail_screen.dart';

class ApproverDashboardScreen extends StatefulWidget {
  const ApproverDashboardScreen(this._width, this._height, this._user,
      {Key? key})
      : super(key: key);

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<ApproverDashboardScreen> createState() =>
      _ApproverDashboardScreenState();
}

//Radio Button Group : Radio Button Names
List<String> options = ['Pending', 'Rejected', 'Approved', 'Completed'];

class _ApproverDashboardScreenState extends State<ApproverDashboardScreen> {
  late Stream<QuerySnapshot> _pendingClaims;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Approver Screen")),
        // drawer: ApproverNavBar(widget._user),
        drawer: ApproverMenuDrawer(
            widget._width, widget._height, "Approver Dashboard", widget._user),
        body: SingleChildScrollView(
          child: Column(
            children: [
              radioButtonGroup(),
              _loadPurchaseRequests(),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingPurchaseOrders();
  }

  String currentOption = options[0];

//Method : Get all pending requests
  void getPendingPurchaseOrders() {
    _pendingClaims =
        ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
            widget._user.department);
  }

  void _filter(String option) {
    if (option == options[0]) {
      _pendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
              widget._user.department);
    } else if (option == options[1]) {
      _pendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getRejectedClaims(
              widget._user.department);
    } else if (option == options[2]) {
      _pendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getApprovedClaims(
              widget._user.department);
    } else {
      _pendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getCompletedClaims(
              widget._user.department);
    }
  }

  Widget radioButtonGroup() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: options.map((option) {
          return Column(
            children: [
              Radio(
                value: option,
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                  _filter(value!);
                },
              ),
              Text(
                option,
                style: TextStyle(
                  fontSize: widget._width / 39.27272727272727,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _loadPurchaseRequests() => StreamBuilder(
      stream: _pendingClaims,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else if (snapShot.data!.docs.isNotEmpty) {
          return SizedBox(
            height: widget._height / 1.247012987012987,
            child: ListView(
                children: snapShot.data!.docs
                    .map((e) => GestureDetector(
                          onTap: () {
                            // Navigate to the my claims page when the item is tapped
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViewClaimInDetail(
                                    widget._width,
                                    widget._height,
                                    widget._user,
                                    e),
                              ),
                            );
                          },
                          key: UniqueKey(),
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            color: e["status"] == "Rejected"
                                ? const Color(0xFFDA8383)
                                : (e["status"] == "Approved" &&
                                        e["paymentStatus"] == "Pending")
                                    ? const Color(0xFF948BB4)
                                    : (e["status"] == "Approved" &&
                                            e["paymentStatus"] == "Paid")
                                        ? const Color(0xFF66DE87)
                                        : const Color(0xFFD6D156),
                            child: SizedBox(
                              width: widget._width / 0.9818181818181818,
                              height: widget._height / 5.018181818181818,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: widget._height / 40.14545454545455,
                                  horizontal: widget._width / 19.63636363636364,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          widget._height / 80.29090909090909,
                                    ),
                                    Text(
                                      'Date : ${e["date"].toDate().toString().substring(0, 10)}',
                                      style: TextStyle(
                                        fontSize:
                                            widget._width / 26.18181818181818,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          widget._height / 80.29090909090909,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${e["empName"]}',
                                          style: TextStyle(
                                            fontSize: widget._width /
                                                26.18181818181818,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${e["claimNo"]}',
                                          style: TextStyle(
                                            fontSize: widget._width /
                                                26.18181818181818,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          widget._height / 80.29090909090909,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs.${e["total"]}.00',
                                          style: TextStyle(
                                            fontSize: widget._width /
                                                26.18181818181818,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${e["category"]}',
                                          style: TextStyle(
                                            fontSize: widget._width /
                                                26.18181818181818,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          widget._height / 80.29090909090909,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList()),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/no_pending_items.png'),
                Text('You have no ${currentOption.toLowerCase()} items'),
              ],
            ),
          );
        }
      });
}
