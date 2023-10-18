import 'package:flutter/material.dart';

import 'approver_navbar_widget.dart';


class ApproverDashboardScreen extends StatefulWidget {
  const ApproverDashboardScreen(this._width, this._height, {Key? key})
      : super(key: key);

  final double _width;
  final double _height;

  @override
  State<ApproverDashboardScreen> createState() =>
      _ApproverDashboardScreenState();
}

//Radio Button Group : Radio Button Names
List<String> options = ['Pending', 'Rejected', 'Approved', 'Completed'];

class _ApproverDashboardScreenState extends State<ApproverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true, title: Text("Approver Screen")),drawer:ApproverNavBar(),);
  }
}
String currentOption = options[0];

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

// Widget LoadPurchaseRequests() => ListView(
//   children: purchaseorders2.map((e) {
//     if (e["status"] == "Pending") {
//       return Dismissible(
//         key: UniqueKey(),
//         onDismissed: (direction) {
//           if (direction == DismissDirection.endToStart &&
//               e["status"] == "Pending") {
//             //delete from db
//             deletePendingPO(e['pOrderId']);
//             // Handle the swipe-to-left action (e.g., delete the card).
//             setState(() {
//               purchaseorders2.remove(e);
//               purchaseorders1.remove(e);
//             });
//           }
//         },
//         background: Container(
//           color: Colors.red, // Background color when swiping left
//           alignment: Alignment.centerRight,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Icon(
//               Icons.delete,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         child: Card(
//           elevation: 5,
//           shadowColor: Colors.black,
//           color: Color(0xFFE8E478),
//           child: SizedBox(
//             width: 400,
//             height: 160,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'PO Number : ${e["pOrderId"]}',
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   // Text(
//                   //   'DO Number : ${e["deliveryId"]}',
//                   //   style: TextStyle(
//                   //     fontSize: 15,
//                   //     color: Colors.black,
//                   //     fontWeight: FontWeight.w500,
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Item : ${e["itemName"]}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         'Quantity : ${e["qty"]}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Amount : Rs.10,000',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         'Date : ${e["date"].toString().substring(0, 10)}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return GestureDetector(
//         key: UniqueKey(),
//         child: Card(
//           elevation: 5,
//           shadowColor: Colors.black,
//           color: e["status"] == "Rejected"
//               ? Color(0xFFDA8383)
//               : e["status"] == "Completed"
//               ? Color(0xFF66DE87)
//               : Color(0xFFC8E7F2),
//           child: SizedBox(
//             width: 400,
//             height: 160,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'PO Number : ${e["pOrderId"]}',
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   // Text(
//                   //   'DO Number : ${e["deliveryId"]}',
//                   //   style: TextStyle(
//                   //     fontSize: 15,
//                   //     color: Colors.black,
//                   //     fontWeight: FontWeight.w500,
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Item : ${e["itemName"]}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         'Quantity : ${e["qty"]}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Amount : Rs.10,000',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         'Date : ${e["date"].toString().substring(0, 10)}',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }).toList(),
// );