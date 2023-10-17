import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import '../../models/employee.dart';

class FinanceAdminViewClaimStatusScreen extends StatefulWidget {
  const FinanceAdminViewClaimStatusScreen(this._width, this._height, this._user,
      {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<FinanceAdminViewClaimStatusScreen> createState() =>
      _FinanceAdminViewClaimStatusScreenState();
}

class _FinanceAdminViewClaimStatusScreenState
    extends State<FinanceAdminViewClaimStatusScreen> {
  final List<String> _statusDropdownItems = ["Approved", "Rejected"];
  String _statusDropdownValue = "Approved";
  late Stream<QuerySnapshot> _requestsCollectionReference;
  final TextEditingController _empNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestsCollectionReference =
        BudgetAllocationAndReportingService.getApprovedClaims();
  }

  void _filterClaims(String empNo) {
    setState(() {
      if (empNo == '' && _statusDropdownValue == _statusDropdownItems[0]) {
        _requestsCollectionReference =
            BudgetAllocationAndReportingService.getApprovedClaims();
      } else if (empNo == '' &&
          _statusDropdownValue == _statusDropdownItems[1]) {
        _requestsCollectionReference =
            BudgetAllocationAndReportingService.getRejectedClaims();
      } else if (empNo != '' &&
          _statusDropdownValue == _statusDropdownItems[0]) {
        _requestsCollectionReference =
            BudgetAllocationAndReportingService.getApprovedClaimsWithEmpNo(
                empNo.toUpperCase());
      } else if (empNo != '' &&
          _statusDropdownValue == _statusDropdownItems[1]) {
        _requestsCollectionReference =
            BudgetAllocationAndReportingService.getRejectedClaimsWithEmpNo(
                empNo.toUpperCase());
      }
    });
  }

  // void _searchByEmpNo(String empNo) {
  //   setState(() {
  //     if (empNo != '' && _statusDropdownValue == _statusDropdownItems[0]) {
  //       _requestsCollectionReference =
  //           BudgetAllocationAndReportingService.getApprovedClaimsWithEmpNo(
  //               empNo.toUpperCase());
  //     } else if (empNo != '' &&
  //         _statusDropdownValue == _statusDropdownItems[1]) {}
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Claim Report"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                color: Color(0xFFD7D7D7),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Search"),
                    ),
                    Expanded(
                        child: SizedBox(
                            child: TextField(
                      controller: _empNoController,
                      onChanged: (value) {
                        _filterClaims(value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Emp No",
                      ),
                    ))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text("Filter"),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          value: _statusDropdownValue.isNotEmpty
                              ? _statusDropdownValue
                              : null,
                          hint: const Text("Status"),
                          items: _statusDropdownItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize:
                                        widget._width / 26.18181818181818),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _statusDropdownValue = newValue!;
                            });
                            _filterClaims(_empNoController.text);
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
                height: 600,
                color: Color(0xFFD7D7D7),
                child: StreamBuilder(
                  stream: _requestsCollectionReference,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: DataTable(
                          dividerThickness: 3,
                          horizontalMargin: 25,
                          border: TableBorder.all(color: Colors.grey),
                          showBottomBorder: true,
                          columnSpacing: 6,
                          columns: [
                            DataColumn(
                                label: Expanded(
                              child: Text(
                                "Emp No",
                              ),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Center(child: Text("Name")),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Center(child: Text("Expense Type")),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Center(child: Text("Cost")),
                            ))
                          ],
                          // rows: [
                          // DataRow(
                          //     cells: [
                          //       DataCell(Text("Test")),
                          //       DataCell(Text("Test")),
                          //       DataCell(Center(child: Text("Test"))),
                          //       DataCell(Text("Test"))
                          //     ],
                          //     color: MaterialStateProperty.resolveWith(
                          //             (states) => Color(0x98A2C5FF))),
                          // DataRow(
                          //     cells: [
                          //       DataCell(Text("Test")),
                          //       DataCell(Text("Test")),
                          //       DataCell(Center(child: Text("Test"))),
                          //       DataCell(Text("Test"))
                          //     ],
                          //     color: MaterialStateProperty.resolveWith(
                          //             (states) => Color(0x98A2C5FF))),
                          // ],
                          rows: snapshot.data!.docs
                              .map((e) => DataRow(
                                      cells: [
                                        DataCell(Text(e["empNo"])),
                                        DataCell(Text(e["empName"])),
                                        DataCell(
                                            Center(child: Text(e["category"]))),
                                        DataCell(Text("Rs." +
                                            e["total"].toStringAsFixed(2)))
                                      ],
                                      color: MaterialStateProperty.resolveWith(
                                          (states) => Color(0x98A2C5FF))))
                              .toList(),
                        ),
                      );
                    } else {
                      return Text("No Data");
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }
}
