import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text("Loading..."),
                ),
              ],
            );
          } else if (snapshot.data!.docs.length > 0) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.docs
                    .map((e) => Text(e["date"].toDate().toString()))
                    .toList(),
              ),
            );
          } else {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tag_faces_rounded, size: 100, color: Colors.green,),
                Text("No Pending Claims"),
              ],
            ));
          }
        },
      ),
    );
  }
}
