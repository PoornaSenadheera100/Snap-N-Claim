import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference expenseCollectionReference =
    _firestore.collection("Expense");
final CollectionReference allocationCollectionReference =
    _firestore.collection("Allocation");

class BudgetAllocationAndReportingService {
  static Stream<QuerySnapshot> getExpenses() {
    return expenseCollectionReference.snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getEligibleEmps(String glCode) {
    return allocationCollectionReference
        .where("gl_code", isEqualTo: glCode)
        .snapshots();
  }

  static Future<Response> addAllocation(
      String glCode, String empGrade, String costCenter) async {
    Response response = Response();
    Map<String, dynamic> data = <String, dynamic>{
      "gl_code": glCode,
      "emp_grade": empGrade,
      "department": costCenter
    };

    await allocationCollectionReference.doc().set(data).whenComplete(() {
      response.code = 200;
      response.message = "Allocation Added";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteAllocation(
      String glCode, String empGrade, String costCenter) async {
    Response response = Response();
    try {
      QuerySnapshot querySnapshot = await allocationCollectionReference
          .where("gl_code", isEqualTo: glCode)
          .where("emp_grade", isEqualTo: empGrade)
          .where("department", isEqualTo: costCenter)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Object?> document in querySnapshot.docs) {
          await document.reference.delete();
        }
        response.code = 200;
        response.message = "Allocation deleted";
      } else {
        response.code = 404;
        response.message = "No matching allocation found";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }
    return response;
  }
}
