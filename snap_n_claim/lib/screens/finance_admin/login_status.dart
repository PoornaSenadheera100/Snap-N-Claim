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
  final double _deviceWidth = 392.7272727272727;
  final double _deviceHeight = 802.9090909090909;
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
      width: widget._width / 16.36363636363636, // Adjust the size as needed
      height: widget._height / 33.45454545454545,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Creation and Management",
          style: TextStyle(fontSize: widget._width / 21.81818181818182),
        ),
      ),
      drawer: FinanceAdminMenuDrawer(widget._width, widget._height,
          "User Configuration Screen", widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //CREATE ACCOUNT BUTTON.
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Padding(
            //       padding:
            //           EdgeInsets.only(right: widget._width / 49.09090909090909),
            //       child: ElevatedButton(
            //           onPressed: () {
            //             _navigate();
            //           },
            //           child: const Text("Create Account")),
            //     ),
            //   ],
            // ),
            Container(
              width: widget._width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: widget._width / 3.1,
                      height: widget._height / 6.176223776223776,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0x860C3486),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: _deviceHeight / (_deviceHeight / 8)),
                            child: Text(
                              _accLoginInfo["total"].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _deviceWidth / (_deviceWidth / 30),
                              ),
                            ),
                          ),
                          Text(
                            "Accounts Created",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _deviceWidth / (_deviceWidth / 14),
                            ),
                          ),
                        ],
                      )),
                  Container(
                      width: widget._width / 3.1,
                      height: widget._height / 6.176223776223776,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0x4C030D60),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: _deviceHeight / (_deviceHeight / 8)),
                            child: Text(
                              _accLoginInfo["loggedInCount"].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _deviceWidth / (_deviceWidth / 30),
                              ),
                            ),
                          ),
                          Text(
                            "Successful Logins",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _deviceWidth / (_deviceWidth / 14),
                            ),
                          ),
                        ],
                      )),
                  Container(
                      width: widget._width / 3.1,
                      height: widget._height / 6.176223776223776,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0x4C1A48FF),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: _deviceHeight / (_deviceHeight / 8)),
                            child: Text(
                              (_accLoginInfo["total"] -
                                      _accLoginInfo["loggedInCount"])
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _deviceWidth / (_deviceWidth / 30),
                              ),
                            ),
                          ),
                          Text(
                            "Awaiting Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _deviceWidth / (_deviceWidth / 14),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _navigate();
                },
                child: const Text("Create Account")),
            // Container(
            //     width: widget._width / 2.181818181818182,
            //     height: widget._height / 6.176223776223776,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       color: Colors.green,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         const Text("No of Accounts Created",
            //             textAlign: TextAlign.center),
            //         Text(_accLoginInfo["total"].toString()),
            //       ],
            //     )),
            // Padding(
            //   padding: EdgeInsets.only(top: widget._height / 100.3636363636364),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Container(
            //             width: widget._width / 2.181818181818182,
            //             height: widget._height / 6.176223776223776,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               color: Colors.purple,
            //             ),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 const Text("Successfully Logged In Users",
            //                     textAlign: TextAlign.center),
            //                 Text(_accLoginInfo["loggedInCount"].toString()),
            //               ],
            //             )),
            //         Container(
            //             width: widget._width / 2.181818181818182,
            //             height: widget._height / 6.176223776223776,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(20),
            //               color: Colors.red,
            //             ),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 const Text("Users to be Logged In",
            //                     textAlign: TextAlign.center),
            //                 Text((_accLoginInfo["total"] -
            //                         _accLoginInfo["loggedInCount"])
            //                     .toString()),
            //               ],
            //             )),
            //       ]),
            // ),
            Padding(
              padding: EdgeInsets.only(top: widget._height / 80.29090909090909),
              child: StreamBuilder(
                  stream: employeeCollectionReference,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (snapshot.data!.docs.isNotEmpty) {
                      return SizedBox(
                        height: widget._height / 2.058741258741259,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              dividerThickness: 3,
                              horizontalMargin: 25,
                              border: TableBorder.all(color: Colors.grey),
                              showBottomBorder: true,
                              columnSpacing: 6,
                              columns: const [
                                DataColumn(
                                    label: Expanded(
                                  child: Center(
                                    child: Text(
                                      "Emp No ",
                                    ),
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
                                        (states) => const Color(0x98A2C5FF)));
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text('No Data');
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
