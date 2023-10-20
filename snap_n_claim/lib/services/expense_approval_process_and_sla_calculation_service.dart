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

class ExpenseApprovalProcessAndSlaCalculationService {
  static Stream<QuerySnapshot<Object?>> getPendingClaims(String department) {
    return requestCollectionReference
        .where("status", isEqualTo: "Pending")
        .where("department", isEqualTo: department)
        .orderBy("date")
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getRejectedClaims(String department) {
    return requestCollectionReference
        .where("status", isEqualTo: "Rejected")
        .where("department", isEqualTo: department)
        .orderBy("date")
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getApprovedClaims(String department) {
    return requestCollectionReference
        .where("status", isEqualTo: "Approved")
        .where("paymentStatus", isEqualTo: "Pending")
        .where("department", isEqualTo: department)
        .orderBy("date")
        .snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getCompletedClaims(String department) {
    return requestCollectionReference
        .where("status", isEqualTo: "Approved")
        .where("paymentStatus", isEqualTo: "Paid")
        .where("department", isEqualTo: department)
        .orderBy("date")
        .snapshots();
  }

  static Future<Response> updateRequestApprovalStatus(
      Map<String, dynamic> request) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await requestCollectionReference
          .where("claimNo", isEqualTo: request["claimNo"])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        await document.reference.update(request); // Update the document
        response.code = 200;
        response.message = "Claim request updated!";
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
