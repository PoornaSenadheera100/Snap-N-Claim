import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_claims_payment_screen.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_menu_drawer.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

class FinanceAdminHomeScreen extends StatefulWidget {
  const FinanceAdminHomeScreen(this._width, this._height, this.user,
      {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<FinanceAdminHomeScreen> createState() => _FinanceAdminHomeScreenState();
}

class _FinanceAdminHomeScreenState extends State<FinanceAdminHomeScreen> {
  late Stream<QuerySnapshot> _pendingClaimsReference;

  @override
  void initState() {
    super.initState();
    _getFinancePendingClaims();
  }

  void _getFinancePendingClaims() {
    _pendingClaimsReference =
        BudgetAllocationAndReportingService.getFinancePendingClaims();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Pending Claims"),
      ),
      drawer: FinanceAdminMenuDrawer(
          widget._width, widget._height, "Finance Pending Claims", widget.user),
      body: StreamBuilder(
        stream: _pendingClaimsReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: widget._width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text("Loading..."),
                  ),
                ],
              ),
            );
          } else if (snapshot.data!.docs.length > 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: widget._width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!.docs
                        .map((e) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FinanceAdminClaimsPaymentScreen(
                                            widget._width,
                                            widget._height,
                                            widget.user, e)));
                              },
                              key: UniqueKey(),
                              child: Card(
                                elevation: 5,
                                shadowColor: Colors.black,
                                color: Color(0x81A2C5FF),
                                child: SizedBox(
                                  width: 350,
                                  height: 105,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateTime.parse(e["date"]
                                                      .toDate()
                                                      .toString())
                                                  .toString()
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Rs.${e["total"].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              e["claimNo"],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Status : ${e["status"]}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${e["category"]}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              e["empName"],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.tag_faces_rounded,
                  size: 100,
                  color: Colors.green,
                ),
                Text("No Pending Claims"),
              ],
            ));
          }
        },
      ),
    );
  }
}
