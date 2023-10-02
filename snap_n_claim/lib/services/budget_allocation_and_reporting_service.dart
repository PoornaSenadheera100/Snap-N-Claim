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
    return expenseCollectionReference.orderBy("gl_code").snapshots();
  }

  static Stream<QuerySnapshot<Object?>> getEligibleEmps(String glCode) {
    return allocationCollectionReference
        .where("gl_code", isEqualTo: glCode)
        .orderBy("emp_grade")
        .orderBy("department")
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

  static Future<bool> hasAllocation(
      String glCode, String empGrade, String costCenter) async {
    QuerySnapshot querySnapshot = await allocationCollectionReference
        .where("gl_code", isEqualTo: glCode)
        .where("emp_grade", isEqualTo: empGrade)
        .where("department", isEqualTo: costCenter)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // TODO - Modify
  static Future<Response> updateAllExpenses(List<Map<String, dynamic>> updatedExpenseData) async {
    Response response = Response();
    WriteBatch batch = FirebaseFirestore.instance.batch(); // Create a WriteBatch

    for (var expenseData in updatedExpenseData) {
      String docId = expenseData['docId']; // Assuming each data map has a 'docId' field
      DocumentReference documentReference = expenseCollectionReference.doc(docId);

      Map<String, dynamic> data = <String, dynamic>{
        "gl_code": expenseData['gl_code'],
        "gl_name": expenseData['gl_name'],
        "transaction_limit": expenseData['transaction_limit'],
        "monthly_limit": expenseData['monthly_limit'],
      };

      batch.update(documentReference, data); // Queue up the update for this document
    }

    try {
      await batch.commit(); // Commit all updates in the batch
      response.code = 200;
      response.message = "Expenses updated!";
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

}
