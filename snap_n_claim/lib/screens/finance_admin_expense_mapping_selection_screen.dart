import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/finance_admin_expense_mapping_screen.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

class FinanceAdminExpenseMappingSelectionScreen extends StatefulWidget {
  FinanceAdminExpenseMappingSelectionScreen(this._width, this._height,
      {super.key});

  double _width;
  double _height;

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
            monthlyLimit)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Mapping"),
      ),
      body: StreamBuilder(
        stream: _collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  children: [
                    Text("GL Code"),
                    Text("GL Name"),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView(
                      children: snapshot.data!.docs
                          .map((e) => Card(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(e["gl_code"]),
                                        Text(e["gl_name"]),
                                        ElevatedButton(
                                            onPressed: () {
                                              _onTapConfigureBtn(
                                                  context,
                                                  e["gl_code"],
                                                  e["gl_name"],
                                                  e["transaction_limit"].toDouble(),
                                                  e["monthly_limit"].toDouble());
                                            },
                                            child: Text("Configure")),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Text("NO DATA");
          }
        },
      ),
    );
  }
}
