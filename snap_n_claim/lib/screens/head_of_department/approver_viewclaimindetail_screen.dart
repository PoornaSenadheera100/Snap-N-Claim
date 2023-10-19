import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/employee.dart';


class ViewClaimInDetail extends StatefulWidget {
  const ViewClaimInDetail(this._width, this._height, this._user,this.request,{super.key});

  final double _width;
  final double _height;
  final Employee _user;
  final QueryDocumentSnapshot <Object?> request;

  @override
  State<ViewClaimInDetail> createState() =>
      _ViewClaimInDetail();
}

class _ViewClaimInDetail extends State<ViewClaimInDetail> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Delivery Note"),
    ),
    body: Center(
      child: ListView(
      padding: EdgeInsets.all(32),
      children: [
      const SizedBox(height: 24),
      Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PONumber(),
      ),
      Padding(
             padding: const EdgeInsets.only(bottom: 8),
      child: ClaimDate(),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Location(),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: SiteManagerName(),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Items(),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 8.0),
             child: Quantity(),
          ),
           // Padding(
           //   padding: const EdgeInsets.only(bottom: 8.0),
           //   child: supplier(),
           // ),
           // Padding(
           //   padding: const EdgeInsets.only(bottom: 8.0),
           //   child: Total(),
           // ),
           // widget._visible==true ?
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               ElevatedButton(
                 child: Text('Confirm'),
                 onPressed: () {
                   // _onTapConfirmationBtns(context, "Confirmed");
                 },
               ),
               ElevatedButton(
                 child: Text('Reject'),
                 onPressed: () {
                   // _onTapConfirmationBtns(context, "Rejected");
                 },
               ),
             ],
           ) ,
          const SizedBox(height: 24),
           const SizedBox(height: 24),
         ],
       ),
    ),
  );

   Widget PONumber() => TextField(
     decoration: InputDecoration(
       labelText: 'PO Number',
       border: OutlineInputBorder(),
     ),
     readOnly: true,
     controller:
     TextEditingController(text: widget.request["claimNo"]),
  );

   Widget ClaimDate() {
     return TextFormField(
       readOnly: true,
       decoration: InputDecoration(
         labelText: 'Claim Date',
         border: OutlineInputBorder(),
       ),
       // controller: TextEditingController(
       //     text: _purchaseOrder2["date"] == null
       //         ? ''
       //         : _purchaseOrder2["date"].toString().substring(0, 10)!),
     );
   }

   Widget Location() => TextField(
     decoration: InputDecoration(
       labelText: 'Location',
       border: OutlineInputBorder(),
     ),
    readOnly: true,
   // controller: TextEditingController(text:["empName"]),
   );

   Widget SiteManagerName() => TextField(
     decoration: InputDecoration(
       labelText: 'Site Manager Name',
       border: OutlineInputBorder(),
     ),
     readOnly: true,
     controller: TextEditingController(text: widget._user.name),
   );

   Widget Items() => TextField(
     decoration: InputDecoration(
       labelText: 'Item',
       border: OutlineInputBorder(),
     ),
     readOnly: true,
     // controller: TextEditingController(text: widget._deliveryNote["itemName"]),
   );

   Widget Quantity() => TextField(
     decoration: InputDecoration(
       labelText: 'Quantity',
       border: OutlineInputBorder(),
     ),
     readOnly: true,
     controller:null
     // TextEditingController(text: widget._deliveryNote["qty"].toString()),
  );

   Widget buildEmail() => TextField(
     // controller: emailController,
   //   decoration: InputDecoration(
   //     hintText: 'name@gmail.com',
   //  prefixIcon: Icon(Icons.mail),
   //   suffixIcon: emailController.text.isEmpty
   //       ? Container(width: 0)
   //       : IconButton(
   //     icon: Icon(Icons.close),
   //     onPressed: () => emailController.clear(),
   //   ),
   //   border: OutlineInputBorder(),
   // ),
   keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,



 // Widget displaySupplier() => DataTable(
 //   columns: const <DataColumn>[
 //     DataColumn(
 //       label: Expanded(
 //         child: Text(
 //           'Name',
 //          style: TextStyle(fontStyle: FontStyle.italic),
 //         ),
 //       ),
 //     ),
 //    DataColumn(
 //       label: Expanded(
 //         child: Text(
 //           'Age',
 //           style: TextStyle(fontStyle: FontStyle.italic),
 //         ),
 //       ),
 //    ),
 //     DataColumn(
 //       label: Expanded(
 //         child: Text(
 //         'Role',
 //           style: TextStyle(fontStyle: FontStyle.italic),
 //          ),
 //        ),
 //      ),
 //    ],
 //    rows: const <DataRow>[
 //      DataRow(
 //        cells: <DataCell>[
 //          DataCell(Text('Sarah')),
 //          DataCell(Text('19')),
 //          DataCell(Text('Student')),
 //        ],
 //      ),
 //      DataRow(
 //        cells: <DataCell>[
 //          DataCell(Text('Janine')),
 //          DataCell(Text('43')),
 //          DataCell(Text('Professor')),
 //        ],
 //      ),
 //      DataRow(
 //        cells: <DataCell>[
 //          DataCell(Text('William')),
 //          DataCell(Text('27')),
 //          DataCell(Text('Associate Professor')),
 //        ],
 //      ),
 //    ],
 //  );

  // Widget supplier() => TextField(
  //     decoration: InputDecoration(
  //       labelText: 'Supplier',
  //       border: OutlineInputBorder(),
  //     ),
  //     readOnly: true,
  //     controller: TextEditingController(
  //       text: widget._deliveryNote["supplierId"],
  //     ));
  //
  // Widget Total() => TextField(
  //   decoration: InputDecoration(
  //     labelText: 'Total',
  //     border: OutlineInputBorder(),
  //   ),
  //   readOnly: true,
  //   controller: TextEditingController(
  //       text: (widget._deliveryNote["qty"] *
  //           widget._deliveryNote["unitPrice"])
  //           .toString()),
  );
}



