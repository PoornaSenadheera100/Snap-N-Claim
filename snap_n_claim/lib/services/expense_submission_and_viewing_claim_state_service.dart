import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference expenseCollectionReference =
    _firestore.collection("Expense");
final CollectionReference allocationCollectionReference =
    _firestore.collection("Allocation");
final CollectionReference requestCollectionReference =
    _firestore.collection("Request");
final CollectionReference employeeCollectionReference =
    _firestore.collection("Employee");

class ExpenseSubmissionAndViewingClaimStateService {

  static Stream<QuerySnapshot> getAllRequestsByEmpNo(String empNo) {
    return requestCollectionReference
        .where('empNo', isEqualTo: empNo)
        .snapshots();
  }

  static Future<QuerySnapshot<Object?>> getLatestClaimNo() {
    return requestCollectionReference
        .orderBy('claimNo', descending: true)
        .limit(1)
        .get();
  }

  static Stream<QuerySnapshot> getPendingRequests(String empNo) {
    return requestCollectionReference
        .where("status", isEqualTo: "Pending")
        .where('empNo', isEqualTo: empNo)
        .snapshots();
  }

  static Stream<QuerySnapshot> getApprovedRequests(String empNo) {
    return requestCollectionReference
        .where("status", isEqualTo: "Approved")
        .where('empNo', isEqualTo: empNo)
        .snapshots();
  }

  static Stream<QuerySnapshot> getRejectedRequests(String empNo) {
    return requestCollectionReference
        .where("status", isEqualTo: "Rejected")
        .where('empNo', isEqualTo: empNo)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDraftRequests(String empNo) {
    return requestCollectionReference
        .where("status", isEqualTo: "Draft")
        .where('empNo', isEqualTo: empNo)
        .snapshots();
  }

  static Stream<QuerySnapshot> getExpensesByClaimNo(String claimNo) {
    return requestCollectionReference
        .where("claimNo", isEqualTo: claimNo)
        .where('status', isEqualTo: 'Draft')
        .snapshots();
  }

  static Future<Response> addRequest(Map<String, dynamic> request) async {
    Response response = Response();

    await requestCollectionReference.doc().set(request).whenComplete(() {
      response.code = 200;
      response.message = "Line Item added";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> updateRequest(Map<String, dynamic> request,
      String claimNo) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        await document.reference.update(request);
        response.code = 200;
        response.message = "Line item added";
      } else {
        response.code = 404;
        response.message =
        "Claim request not found with the specified claim number";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Response> deleteLineItem(String claimNo,
      String invoiceNo) async {
    Response response = Response();
    double invoiceAmount = 0.0;
    double initialTotal = 0.0;
    double total = 0.0;

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        List l = document["lineItems"];

        //find the lineitem that matches the invoice number
        Iterable lItem = l.where((element) => element["invoiceNo"] == invoiceNo);

        invoiceAmount = double.parse((lItem.first["invoiceAmount"]).toString());
        initialTotal = double.parse((document['total']).toString());
        total = initialTotal - invoiceAmount;

        l.removeWhere((element) => element["invoiceNo"] == invoiceNo);

        Map<String, dynamic> newData = {
          "category": document["category"],
          "claimNo": document["claimNo"],
          "date": document["date"],
          "department": document["department"],
          "empName": document["empName"],
          "empNo": document["empNo"],
          "lineItems": l,
          "paymentStatus": document["paymentStatus"],
          "rejectReason": document["rejectReason"],
          "status": document["status"],
          "total": total,
        };

        await requestCollectionReference.doc(document.id).update(newData);
        response.code = 200;
        response.message = "Line item removed";
      } else {
        response.code = 404;
        response.message =
        "Claim request not found with the specified claim number";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Response> deleteClaim(String claimNo) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        await document.reference.delete();

        response.code = 200;
        response.message = "Claim deleted";
      } else {
        response.code = 404;
        response.message =
        "Claim request could not be deleted";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Response> updateClaimStatus(String claimNo) async{
    Response response = Response();

    try{
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        Map<String, dynamic> newData = {
          "category": document["category"],
          "claimNo": document["claimNo"],
          "date": document["date"],
          "department": document["department"],
          "empName": document["empName"],
          "empNo": document["empNo"],
          "lineItems": document["lineItems"],
          "paymentStatus": document["paymentStatus"],
          "rejectReason": document["rejectReason"],
          "status": "Pending",
          "total": document["total"],
        };

        await requestCollectionReference.doc(document.id).update(newData);
        response.code = 200;
        response.message = "Claim status updated";
      } else {
        response.code = 404;
        response.message =
        "Claim request not found with the specified claim number";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }
}