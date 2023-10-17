import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/models/response.dart';

import '../../services/budget_allocation_and_reporting_service.dart';

class FinanceAdminExpenseMappingScreen extends StatefulWidget {
  const FinanceAdminExpenseMappingScreen(this._width, this._height,
      this._glCode, this._glName, this._transactionLimit, this._monthlyLimit,
      {super.key});

  final double _width;
  final double _height;
  final String _glCode;
  final String _glName;
  final double _transactionLimit;
  final double _monthlyLimit;

  @override
  State<FinanceAdminExpenseMappingScreen> createState() =>
      _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState
    extends State<FinanceAdminExpenseMappingScreen> {
  final TextEditingController _glCodeController = TextEditingController();
  final TextEditingController _glNameController = TextEditingController();
  final TextEditingController _transactionLimitController =
      TextEditingController();
  final TextEditingController _monthlyLimitController = TextEditingController();

  late String _empGradeDropdownValue;
  late String _costCenterDropdownValue;

  final List<String> _empGrades = [
    "Junior",
    "Senior",
    "Manager",
    "Executive",
    "Senior Executive"
  ];
  final List<String> _costCenters = [
    "Production Department",
    "IT Department",
    "Finance Department",
    "HR Department",
    "Marketing Department",
    "Safety and Security Department"
  ];

  late Stream<QuerySnapshot> _collectionReference;

  @override
  void initState() {
    super.initState();
    _glCodeController.text = widget._glCode;
    _glNameController.text = widget._glName;
    _transactionLimitController.text =
        "Rs. ${widget._transactionLimit.toStringAsFixed(2)}";
    _monthlyLimitController.text =
        "Rs. ${widget._monthlyLimit.toStringAsFixed(2)}";
    _empGradeDropdownValue = "";
    _costCenterDropdownValue = "";
    _collectionReference =
        BudgetAllocationAndReportingService.getEligibleEmps(widget._glCode);
  }

  Future<void> _onTapAddBtn() async {
    bool isValidated = _validateDropdownValues();
    if (isValidated == true) {
      bool hasAllocation =
          await BudgetAllocationAndReportingService.hasAllocation(
              widget._glCode, _empGradeDropdownValue, _costCenterDropdownValue);
      if (hasAllocation == true) {
        Fluttertoast.showToast(
            msg: "Already Allocated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Response response =
            await BudgetAllocationAndReportingService.addAllocation(
                widget._glCode,
                _empGradeDropdownValue,
                _costCenterDropdownValue);
        if (response.code == 200) {
          Fluttertoast.showToast(
              msg: "Allocation Added!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // setState(() {});
        }
      }
    }
  }

  bool _validateDropdownValues() {
    if (_empGradeDropdownValue == "") {
      Fluttertoast.showToast(
          msg: "Select Employee Grade!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    } else if (_costCenterDropdownValue == "") {
      Fluttertoast.showToast(
          msg: "Select Cost Center!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }

  Future<void> _onTapDeleteBtn(String empGrade, String costCenter) async {
    var dialogRes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this allocation?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (dialogRes == true) {
      Response response =
          await BudgetAllocationAndReportingService.deleteAllocation(
              widget._glCode, empGrade, costCenter);
      if (response.code == 200) {
        Fluttertoast.showToast(
            msg: "Allocation Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Mapping"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: widget._height / 40.14545454545455),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(bottom: widget._height / 80.29090909090909),
              child: Container(
                width: widget._width / 1.05,
                color: Colors.grey,
                child: const Center(child: Text("Expense Info")),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("GL Code"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          controller: _glCodeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text("Transaction Limit"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _transactionLimitController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("GL Name"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _glNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                        const Divider(
                          color: Colors.transparent,
                        ),
                        const Text("Monthly Limit"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _monthlyLimitController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: widget._height / 40.14545454545455),
              child: Container(
                width: widget._width / 1.05,
                color: Colors.grey,
                child: const Center(child: Text("Eligible Employees")),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("Employee Grade"),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: _empGradeDropdownValue.isNotEmpty
                                  ? _empGradeDropdownValue
                                  : null,
                              hint: const Text("Select Grade"),
                              items: _empGrades.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                                  _empGradeDropdownValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("Employee Cost Center"),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: _costCenterDropdownValue.isNotEmpty
                                  ? _costCenterDropdownValue
                                  : null,
                              hint: const Text("Select Cost Center"),
                              items: _costCenters.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize:
                                            widget._width / 35.70247933884297),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _costCenterDropdownValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: widget._width / 26.18181818181818),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onTapAddBtn();
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            StreamBuilder(
                stream: _collectionReference,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
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
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: SizedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (widget._width - widget._width * 3 / 3.1) /
                                      2),
                          child: ListView(
                            children: snapshot.data!.docs
                                .map((e) => Row(
                                      children: [
                                        SizedBox(
                                            width: widget._width / 3.1,
                                            child: Center(
                                                child: Text(
                                              e["emp_grade"],
                                              textAlign: TextAlign.center,
                                            ))),
                                        SizedBox(
                                            width: widget._width / 3.1,
                                            child: Center(
                                                child: Text(
                                              e["department"],
                                              textAlign: TextAlign.center,
                                            ))),
                                        SizedBox(
                                            width: widget._width / 3.1,
                                            child: Center(
                                                child: IconButton(
                                              onPressed: () {
                                                _onTapDeleteBtn(e["emp_grade"],
                                                    e["department"]);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ))),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Text("NO DATA");
                  }
                })
          ],
        ),
      ),
    );
  }
}
