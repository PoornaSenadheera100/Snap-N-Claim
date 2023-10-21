import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/employee.dart';
import '../../services/expense_approval_process_and_sla_calculation_service.dart';

class approvalHistory extends StatefulWidget {
  const approvalHistory(this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<approvalHistory> createState() => _approvalHistoryState();
}

class _approvalHistoryState extends State<approvalHistory> {

  late Stream<QuerySnapshot> _pendingClaims;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingPurchaseOrders();
  }

  //Method : Get all pending requests
  void getPendingPurchaseOrders() {
    _pendingClaims =
        ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
            widget._user.department);
  }

  bool sla(DateTime date) {
    DateTime currentdate = DateTime.now();
    DateTime dueDate = date.add(Duration(days: 3));
    bool isBreached = dueDate.isBefore(currentdate);
    return isBreached; // Return a boolean value to indicate if breached.
  }

  Widget ApproverHistory() =>
      StreamBuilder(
        stream: _pendingClaims,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          } else if (snapshot.data!.docs.length > 0) {
            return SingleChildScrollView(child: DataTable(
              columns: [
                DataColumn(label: Text('Emp No')),
                DataColumn(label: Text('Emp Name')),
                DataColumn(label: Text('Expense Name')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('SLA Status')),
                DataColumn(label: Text('Claim Status')),
              ],
              rows: snapshot.data!.docs.map<DataRow>((e) {
                bool isBreached = sla(e['date'].toDate());
                return DataRow(
                  selected: isBreached, // Select the row if breached.
                  cells: [
                    DataCell(Text(e['empNo'])),
                    DataCell(Text(e['empName'])),
                    DataCell(Text(e['category'])),
                    DataCell(Text(e['total'].toStringAsFixed(2))),
                    DataCell(
                        Text(e['date'].toDate().toString().substring(0, 10))),
                    DataCell(Text(e['status'])),
                    DataCell(sla(e['date'].toDate()) ? Text('Breached') : Text(
                        'Not Breached')),
                  ],
                );
              }).toList(),
            ));

          } else {
            return Text("No Data");
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approver Claim History'),
      ),
      body: SingleChildScrollView(
        child: Column(

            children: [ApproverHistory()]
        ),
      ),
    );
  }
}
