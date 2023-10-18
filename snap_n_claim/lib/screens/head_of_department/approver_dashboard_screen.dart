import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/employee.dart';
import '../../services/expense_approval_process_and_sla_calculation_service.dart';
import 'approver_navbar_widget.dart';


class ApproverDashboardScreen extends StatefulWidget {
  const ApproverDashboardScreen(this._width, this._height, this._user, {Key? key})
      : super(key: key);

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<ApproverDashboardScreen> createState() =>
      _ApproverDashboardScreenState();
}

//Radio Button Group : Radio Button Names
List<String> options = ['Pending', 'Rejected', 'Approved', 'Completed'];

class _ApproverDashboardScreenState extends State<ApproverDashboardScreen> {

  late Stream <QuerySnapshot> PendingClaims;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: Text("Approver Screen")),
      drawer: ApproverNavBar(widget._user),);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingPurchaseOrders();
  }

  String currentOption = options[0];


//Method : Get all pending requests
  Future<void> getPendingPurchaseOrders() async {
    PendingClaims =
    await ExpenseApprovalProcessAndSlaCalculationService.getPendingClaims(
        widget._user.empNo);
  }


  void filter(String option) {

    /*setState(() {
    purchaseorders2 = purchaseorders1
        .where((element) => element["status"] == option)
        .toList();
  });*/
  }


  Widget radioButtonGroup() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: options.map((option) {
          return Column(
            children: [
              Radio(
                value: option,
                groupValue: currentOption,
                onChanged: (value) {
                  /*setState(() {
                  currentOption = value.toString();
                });*/
                  filter(value!);
                },
              ),
              Text(
                option,
                style: TextStyle(
                    fontSize: 10), // You can adjust the font size here
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

Widget LoadPurchaseRequests() => StreamBuilder(
  stream: PendingClaims,
  builder : (BuildContext context,AsyncSnapshot <QuerySnapshot> snapShot) {
    if (snapShot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator.adaptive();
    }
    else if (snapShot.data!.docs.length>0){
  return ListView(children:snapShot.data!.docs.map((e) => GestureDetector(
  key: UniqueKey(),
  child: Card(
  elevation: 5,
  shadowColor: Colors.black,
  color: e["status"] == "Rejected"
  ? Color(0xFFDA8383)
      : e["status"] == "Completed"
  ? Color(0xFF66DE87)
      : Color(0xFFC8E7F2),
  child: SizedBox(
  width: 400,
  height: 160,
  child: Padding(
  padding: const EdgeInsets.all(20.0),
  child: Column(
  children: [
  const SizedBox(
  height: 10,
  ),
  Text(
  'PO Number : ${e["pOrderId"]}',
  style: TextStyle(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  ),
  ),
  // Text(
  //   'DO Number : ${e["deliveryId"]}',
  //   style: TextStyle(
  //     fontSize: 15,
  //     color: Colors.black,
  //     fontWeight: FontWeight.w500,
  //   ),
  // ),
  const SizedBox(
  height: 10,
  ),
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  'Item : ${e["itemName"]}',
  style: TextStyle(
  fontSize: 15,
  color: Colors.black,
  ),
  ),
  Text(
  'Quantity : ${e["qty"]}',
  style: TextStyle(
  fontSize: 15,
  color: Colors.black,
  ),
  ),
  ],
  ),
  const SizedBox(
  height: 10,
  ),
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  'Amount : Rs.10,000',
  style: TextStyle(
  fontSize: 15,
  color: Colors.black,
  ),
  ),
  Text(
  'Date : ${e["date"].toString().substring(0, 10)}',
  style: TextStyle(
  fontSize: 15,
  color: Colors.black,
  ),
  ),
  ],
  ),
  const SizedBox(
  height: 10,
  ),
  ],
  ),
  ),
  ),
  ),
  )
  ).toList()
  );
  }
    else{
      return Text("Hurray There are no Pending Claims");
    }
  }
  );
}