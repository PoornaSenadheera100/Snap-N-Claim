import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/services/employee_onboarding_service.dart';

import '../../models/employee.dart';
import 'create_account_screen.dart';
import 'finance_admin_menu_drawer.dart';

class LoginStatusScreen extends StatefulWidget {
  const LoginStatusScreen(this._width, this._height, this.user, {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<LoginStatusScreen> createState() => _LoginStatusScreenState();
}

class _LoginStatusScreenState extends State<LoginStatusScreen> {
  late Stream<QuerySnapshot> employeeCollectionReference;
  Map<String, dynamic> _accLoginInfo = {"total": 0, "loggedInCount": 0};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeCollectionReference = EmployeeOnboardingService.getAllEmployees();
    _getAccountLoginInfo();
  }

  Future<void> _getAccountLoginInfo() async {
    Map<String, dynamic> res =
        await EmployeeOnboardingService.getAccountLoginInfo();
    setState(() {
      _accLoginInfo = res;
    });
  }

  Widget getStatusIndicator(bool isFirstLogin) {
    return Container(
      width: 24, // Adjust the size as needed
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFirstLogin ? Colors.red : Colors.green,
      ),
    );
  }

  void _navigate() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            CreateAccountScreen(widget._width, widget._height, widget.user)));
  }

  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Creation and Management"),
      ),
      drawer: FinanceAdminMenuDrawer(widget._width, widget._height,
          "User Configuration Screen", widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //CREATE ACCOUNT BUTTON.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _navigate();
                      },
                      child: const Text("Create Account")),
                ),
              ],
            ),
            Container(
                width: 180,
                height: widget._height / 6.176223776223776,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No of Accounts Created", textAlign: TextAlign.center),
                    Text(_accLoginInfo["total"].toString()),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 180,
                        height: widget._height / 6.176223776223776,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Successfully Logged In Users",
                                textAlign: TextAlign.center),
                            Text(_accLoginInfo["loggedInCount"].toString()),
                          ],
                        )),
                    Container(
                        width: 180,
                        height: widget._height / 6.176223776223776,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Users to be Logged In",
                                textAlign: TextAlign.center),
                            Text((_accLoginInfo["total"] -
                                    _accLoginInfo["loggedInCount"])
                                .toString()),
                          ],
                        )),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: StreamBuilder(
                  stream: employeeCollectionReference,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator.adaptive();
                    } else if (snapshot.data!.docs.length > 0) {
                      return Container(
                        height: 390,
                        child: SingleChildScrollView(
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
                                  "EPF No",
                                ),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Center(child: Text("Name")),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Center(child: Text("Email")),
                              )),
                              DataColumn(
                                  label: Expanded(
                                child: Center(child: Text("Status")),
                              ))
                            ],
                            rows: snapshot.data!.docs.map((e) {
                              return DataRow(
                                  cells: [
                                    DataCell(Text(e["emp_no"])),
                                    DataCell(Text(e["name"])),
                                    DataCell(Center(child: Text(e["email"]))),
                                    // DataCell(Text(e["firstLogin"].toString()))
                                    DataCell(Center(
                                        child: getStatusIndicator(
                                            e["first_login"]))),
                                  ],
                                  // color: MaterialStateProperty.resolveWith(
                                  //         (states) => Color(0x98A2C5FF)),
                                  color: MaterialStateProperty.resolveWith(
                                      (states) => Color(0x98A2C5FF)));
                            }).toList(),
                          ),
                        ),
                      );
                    } else {
                      return Text('No Data');
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
