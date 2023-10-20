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
  late Stream<QuerySnapshot> PendingClaims;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Approver Screen")),
        // drawer: ApproverNavBar(widget._user),
        drawer: ApproverMenuDrawer(widget._width, widget._height, "Approver Dashboard", widget._user),
        body: Column(
          children: [
            radioButtonGroup(),
            LoadPurchaseRequests(),
          ],
        ));
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingPurchaseOrders();
  }

  String currentOption = options[0];

//Method : Get all pending requests
  void getPendingPurchaseOrders() {
    PendingClaims =
        ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
            widget._user.department);
  }

  void _filter(String option) {
    /*setState(() {
    purchaseorders2 = purchaseorders1
        .where((element) => element["status"] == option)
        .toList();
  });*/
    if (option == options[0]) {
      PendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
              widget._user.department);
    } else if (option == options[1]) {
      PendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getRejectedClaims(
              widget._user.department);
    } else if (option == options[2]) {
      PendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getApprovedClaims(
              widget._user.department);
    } else {
      PendingClaims =
          ExpenseApprovalProcessAndSlaCalculationService.getCompletedClaims(
              widget._user.department);
    }
  }

  Widget radioButtonGroup() {
    return Container(
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
                    fontSize: 10), // You can adjust the font size here
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget LoadPurchaseRequests() => StreamBuilder(
      stream: PendingClaims,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        } else if (snapShot.data!.docs.length > 0) {
          return Container(
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
                                ? Color(0xFFDA8383)
                                : (e["status"] == "Approved" &&
                                        e["paymentStatus"] == "Pending")
                                    ? Color(0xFF948BB4)
                                    : (e["status"] == "Approved" &&
                                            e["paymentStatus"] == "Paid")
                                        ? Color(0xFF66DE87)
                                        : Color(0xFFD6D156),
                            child: SizedBox(
                              width: 400,
                              height: 160,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Date : ${e["date"].toDate().toString().substring(0, 10)}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${e["empName"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${e["claimNo"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs.${e["total"]}.00',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${e["category"]}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
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
