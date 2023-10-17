import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/screens/finance_admin/finance_admin_expense_mapping_screen.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

class FinanceAdminExpenseMappingSelectionScreen extends StatefulWidget {
  const FinanceAdminExpenseMappingSelectionScreen(this._width, this._height, this.user,
      {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<FinanceAdminExpenseMappingSelectionScreen> createState() =>
      _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState
    extends State<FinanceAdminExpenseMappingSelectionScreen> {
  late Stream<QuerySnapshot> _collectionReference;

  @override
  void initState() {
    super.initState();
    _collectionReference = BudgetAllocationAndReportingService.getExpenses();
  }

  void _onTapConfigureBtn(BuildContext context, String glCode, String glName,
      double transactionLimit, double monthlyLimit) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => FinanceAdminExpenseMappingScreen(
            widget._width,
            widget._height,
            glCode,
            glName,
            transactionLimit,
            monthlyLimit, widget.user)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Mapping"),
      ),
      body: StreamBuilder(
        stream: _collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (widget._width - widget._width * 3 / 3.2) / 3,
                      vertical: widget._height / 80.29090909090909),
                  child: Row(
                    children: [
                      SizedBox(
                          width: widget._width / 3.2,
                          child: Center(
                              child: Text(
                            "GL Code",
                            style: TextStyle(
                                fontSize: widget._width / 23.10160427807486,
                                fontWeight: FontWeight.bold),
                          ))),
                      SizedBox(
                          width: widget._width / 3.2,
                          child: Center(
                              child: Text(
                            "GL Name",
                            style: TextStyle(
                                fontSize: widget._width / 23.10160427807486,
                                fontWeight: FontWeight.bold),
                          ))),
                      Container(
                        width: widget._width / 3.2,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              (widget._width - widget._width * 3 / 3.2) / 3),
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((e) => Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: widget._width / 3.2,
                                              child: Center(
                                                  child: Text(e["gl_code"]))),
                                          SizedBox(
                                              width: widget._width / 3.2,
                                              child: Center(
                                                  child: Text(
                                                e["gl_name"],
                                                textAlign: TextAlign.center,
                                              ))),
                                          SizedBox(
                                            width: widget._width / 3.2,
                                            child: Center(
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    _onTapConfigureBtn(
                                                        context,
                                                        e["gl_code"],
                                                        e["gl_name"],
                                                        e["transaction_limit"]
                                                            .toDouble(),
                                                        e["monthly_limit"]
                                                            .toDouble());
                                                  },
                                                  child: const Text("Configure")),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("NO DATA");
          }
        },
      ),
    );
  }
}
