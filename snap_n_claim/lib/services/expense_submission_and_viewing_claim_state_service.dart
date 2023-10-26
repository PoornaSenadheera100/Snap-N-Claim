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

  static Future<QuerySnapshot<Object?>> getSingleClaimDetails(String claimNo) {
    return requestCollectionReference
        .where("claimNo", isEqualTo: claimNo)
        .limit(1)
        .get();
  }

  static Stream<QuerySnapshot> getPendingRequests(String empNo) {
    return requestCollectionReference
        .where('empNo', isEqualTo: empNo)
        .where("status", isEqualTo: "Pending")
        .snapshots();
  }

  static Stream<QuerySnapshot> getApprovedRequests(String empNo) {
    return requestCollectionReference
        .where('empNo', isEqualTo: empNo)
        .where("status", isEqualTo: "Approved")
        .where("paymentStatus", isEqualTo: "Paid")
        .snapshots();
  }

  static Stream<QuerySnapshot> getRejectedRequests(String empNo) {
    return requestCollectionReference
        .where('empNo', isEqualTo: empNo)
        .where("status", isEqualTo: "Rejected")
        .snapshots();
  }

  static Stream<QuerySnapshot> getDraftRequests(String empNo) {
    return requestCollectionReference
        .where('empNo', isEqualTo: empNo)
        .where("status", isEqualTo: "Draft")
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
      response.message = "Expense added";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> updateRequest(
      Map<String, dynamic> request, String claimNo) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        await document.reference.update(request);
        response.code = 200;
        response.message = "Expense added";
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

  static Future<Response> deleteLineItem(
      String claimNo, String invoiceNo) async {
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
        Iterable lItem =
            l.where((element) => element["invoiceNo"] == invoiceNo);

        invoiceAmount = double.parse((lItem.first["invoiceAmount"]).toString());
        initialTotal = double.parse((document['total']).toString());
        total = initialTotal - invoiceAmount;

        l.removeWhere((element) => element["invoiceNo"] == invoiceNo);

        Map<String, dynamic> newData = {
          "claimNo": document["claimNo"],
          "date": document["date"],
          "category": document["category"],
          "empNo": document["empNo"],
          "empName": document["empName"],
          "department": document["department"],
          "total": total,
          "status": document["status"],
          "rejectReason": document["rejectReason"],
          "paymentStatus": document["paymentStatus"],
          "lineItems": l,
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
        response.message = "Claim request could not be deleted";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Response> updateClaimStatus(String claimNo) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: claimNo)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        Map<String, dynamic> newData = {
          "claimNo": document["claimNo"],
          "date": document["date"],
          "category": document["category"],
          "empNo": document["empNo"],
          "empName": document["empName"],
          "department": document["department"],
          "total": document["total"],
          "status": "Pending",
          "rejectReason": document["rejectReason"],
          "paymentStatus": document["paymentStatus"],
          "lineItems": document["lineItems"],
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

  static Future<Map<String, dynamic>> getLimitInfo(String glName) async {
    try {
      QuerySnapshot querySnapshot = await expenseCollectionReference
          .where("gl_name", isEqualTo: glName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];
        Map<String, dynamic> result = {
          "gl_code": document["gl_code"],
          "gl_name": document["gl_name"],
          "monthly_limit": document["monthly_limit"],
          "transaction_limit": document["transaction_limit"]
        };
        return result;
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  static Future<double> getCurrentCostInMonth(
      String department, String category) async {
    String currentDate = DateTime.now().toString().substring(0, 10);
    int year = int.parse(currentDate.substring(0, 4));
    int month = int.parse(currentDate.substring(5, 7));
    double cost = 0;
    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("department", isEqualTo: department)
          .where("category", isEqualTo: category)
          .where("status", whereIn: ["Approved", "Pending", "Draft"])
          .where('date', isGreaterThanOrEqualTo: DateTime(year, month, 1))
          .where('date', isLessThanOrEqualTo: DateTime(year, month, 31))
          .get();

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        cost = cost + document["total"].toDouble();
      }
      return cost;
    } catch (e) {
      print(e.toString());
      return cost;
    }
  }
}
