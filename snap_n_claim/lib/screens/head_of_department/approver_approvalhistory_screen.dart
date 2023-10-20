import 'package:flutter/material.dart';

import '../../models/employee.dart';

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

  Widget ApproverHistory()=>DataTable(
    columns: [
      DataColumn(label: Text('Emp No')),
      DataColumn(label: Text('Emp Name')),
      DataColumn(label: Text('Expense Name')),
      DataColumn(label: Text('Amount')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('SLA Status')),
      DataColumn(label: Text('Claim Status')),
    ],
  rows: [
    DataRow(cells: [
      DataCell(Text('E001')),
      DataCell(Text('Saman')),
      DataCell(Text('Food')),
      DataCell(Text('Rs.10000.00')),
      DataCell(Text('20.10.2023')),
      DataCell(Text('breeched')),
      DataCell(Text('Pending')),
  ]),
  ],

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

