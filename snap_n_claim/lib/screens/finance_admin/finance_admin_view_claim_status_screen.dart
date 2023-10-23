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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Claim Report"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget._height / 100.3636363636364,
                horizontal: widget._width / 49.09090909090909,
              ),
              child: Container(
                height: widget._height / 11.47012987012987,
                color: const Color(0xFFD7D7D7),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget._width / 98.18181818181818,
                      ),
                      child: const Text("Search"),
                    ),
                    Expanded(
                        child: SizedBox(
                            child: TextField(
                      controller: _empNoController,
                      onChanged: (value) {
                        _filterClaims(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Emp No",
                      ),
                    ))),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget._width / 98.18181818181818,
                      ),
                      child: const Text("Filter"),
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
                                  fontSize: widget._width / 26.18181818181818,
                                ),
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget._width / 49.09090909090909,
              ),
              child: Container(
                  height: widget._height / 1.338181818181818,
                  width: widget._width / 1.006993006993007,
                  color: const Color(0xFFD7D7D7),
                  child: StreamBuilder(
                    stream: _requestsCollectionReference,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator.adaptive(),
                            Padding(
                              padding: EdgeInsets.only(
                                top: widget._height / 40.14545454545455,
                              ),
                              child: const Text("Loading..."),
                            ),
                          ],
                        );
                      } else if (snapshot.data!.docs.isNotEmpty) {
                        return SingleChildScrollView(
                          child: DataTable(
                            dividerThickness: 3,
                            horizontalMargin: 25,
                            border: TableBorder.all(color: Colors.grey),
                            showBottomBorder: true,
                            columnSpacing: 6,
                            columns: const [
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
                            rows: snapshot.data!.docs
                                .map((e) => DataRow(
                                        cells: [
                                          DataCell(Text(e["empNo"])),
                                          DataCell(Text(e["empName"])),
                                          DataCell(
                                            Center(
                                              child: Text(e["category"]),
                                            ),
                                          ),
                                          DataCell(
                                            Text("Rs." +
                                                e["total"].toStringAsFixed(2)),
                                          )
                                        ],
                                        color:
                                            MaterialStateProperty.resolveWith(
                                                (states) =>
                                                    const Color(0x98A2C5FF))))
                                .toList(),
                          ),
                        );
                      } else {
                        return const Center(child: Text("No Data"));
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
