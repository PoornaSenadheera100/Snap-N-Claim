
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/services/employee_onboarding_service.dart';

import '../../models/employee.dart';
import 'create_account_screen.dart';
import 'finance_admin_menu_drawer.dart';

class LoginStatusScreen extends StatefulWidget {
  const LoginStatusScreen(this._width,this._height,this.user,{super.key});
  final double _width;
  final double _height;
  final Employee user;

  @override
  State<LoginStatusScreen> createState() => _LoginStatusScreenState();
}

class _LoginStatusScreenState extends State<LoginStatusScreen> {
  late Stream<QuerySnapshot> employeeCollectionReference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeCollectionReference = EmployeeOnboardingService.getAllEmployees();


  }
  Widget getStatusIndicator(bool isFirstLogin) {
    return Container(
      width: 24, // Adjust the size as needed
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFirstLogin ? Colors.green : Colors.red,
      ),
    );
  }

  void _navigate() {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => CreateAccountScreen(
              widget._width, widget._height, widget.user)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Status"),
      ),
      drawer: FinanceAdminMenuDrawer(widget._width, widget._height,
          "User Configuration Screen", widget.user),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //CREATE ACCOUNT BUTTON.
            ElevatedButton(
                onPressed: () {
                  _navigate();
                },
                child: const Text("Create Account")),
            Container(
                width: 120,
                height: widget._height / 6.176223776223776,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No of Accounts Created"),
                    Text("5"),
                  ],
                )
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 120,
                      height: widget._height / 6.176223776223776,
                      color: Colors.purple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Successfully Logged In Users"),
                          Text("5"),
                        ],
                      )
                  ),
                  Container(
                      width: 120,
                      height: widget._height / 6.176223776223776,
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Users to be Logged In"),
                          Text("5"),
                        ],
                      )
                  ),
                ]
            ),
            StreamBuilder(
                stream: employeeCollectionReference,
                builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator.adaptive();
                  }else if(snapshot.data!.docs.length > 0){
                    return DataTable(
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
                      rows: snapshot.data!.docs
                          .map((e) => DataRow(
                          cells: [
                            DataCell(Text(e["empNo"])),
                            DataCell(Text(e["empName"])),
                            DataCell(Center(
                                child: Text(e["email"]))),
                            // DataCell(Text(e["firstLogin"].toString()))
                            DataCell(getStatusIndicator(e["firstLogin"])),
                          ],
                          // color: MaterialStateProperty.resolveWith(
                          //         (states) => Color(0x98A2C5FF)),
                          color:
                          MaterialStateProperty.resolveWith(
                                  (states) => Color(0x98A2C5FF))))
                          .toList(),
                    );
                  }else{
                    return Text('No Data');
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
