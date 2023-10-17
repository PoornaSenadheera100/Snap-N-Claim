import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference expenseCollectionReference =
    _firestore.collection("Expense");
final CollectionReference allocationCollectionReference =
    _firestore.collection("Allocation");
final CollectionReference requestCollectionReference =
    _firestore.collection("Request");

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

  static Future<Response> updateAllExpenses(
      List<Map<String, dynamic>> updatedExpenseData) async {
    Response response = Response();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var expenseData in updatedExpenseData) {
      String docId = expenseData['docId'];
      DocumentReference documentReference =
          expenseCollectionReference.doc(docId);

      Map<String, dynamic> data = <String, dynamic>{
        "gl_code": expenseData['gl_code'],
        "gl_name": expenseData['gl_name'],
        "transaction_limit": expenseData['transaction_limit'],
        "monthly_limit": expenseData['monthly_limit'],
      };

      batch.update(documentReference, data);
    }

    try {
      await batch.commit();
      response.code = 200;
      response.message = "Expenses updated!";
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Map<String, dynamic>> getEmpReportData(
      String empNo, int year) async {
    final Map<String, dynamic> result = {
      "JAN": 0,
      "FEB": 0,
      "MAR": 0,
      "APR": 0,
      "MAY": 0,
      "JUN": 0,
      "JUL": 0,
      "AUG": 0,
      "SEP": 0,
      "OCT": 0,
      "NOV": 0,
      "DEC": 0,
      "MAX": 0
    };

    try {
      final QuerySnapshot querySnapshot = await requestCollectionReference
          .where('empNo', isEqualTo: empNo)
          .where('paymentStatus', isEqualTo: "Paid")
          .where('date', isGreaterThanOrEqualTo: DateTime(year, 1, 1))
          .where('date', isLessThanOrEqualTo: DateTime(year, 12, 31))
          .get();

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        final DateTime claimDate = (document['date'] as Timestamp).toDate();
        final String month = DateFormat('MMM').format(claimDate).toUpperCase();
        final double total = document['total'].toDouble();

        if (result.containsKey(month)) {
          result[month] += total;
          if (result["MAX"] < result[month]) {
            result["MAX"] = result[month];
          }
        }
      }

      return result;
    } catch (e) {
      return result; // Return the initialized result with zeros if there's an error
    }
  }

  static Future<Map<String, dynamic>> getDeptReportData(
      int year, int month) async {
    final Map<String, dynamic> result = {
      "Production Department": 0,
      "IT Department": 0,
      "Finance Department": 0,
      "HR Department": 0,
      "Marketing Department": 0,
      "Safety and Security Department": 0
    };

    try {
      final QuerySnapshot querySnapshot = await requestCollectionReference
          .where('paymentStatus', isEqualTo: "Paid")
          .where('date', isGreaterThanOrEqualTo: DateTime(year, month, 1))
          .where('date', isLessThanOrEqualTo: DateTime(year, month, 31))
          .get();

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        final department = document['department'];
        final double total = document['total'].toDouble();
        if (result.containsKey(department)) {
          result[department] += total;
        }
      }
      return result;
    } catch (e) {
      return result; // Return the initialized result with zeros if there's an error
    }
  }

  static Future<Map<String, dynamic>> getExpenseReportData(
      int year, int month) async {
    final Map<String, dynamic> result = {
      "Transportation": 0,
      "Meals and Food": 0,
      "Accommodation": 0,
      "Equipment and Supplies": 0,
      "Communication": 0,
      "Health and Safety": 0,
      "MAX": 0,
    };

    try {
      final QuerySnapshot querySnapshot = await requestCollectionReference
          .where('paymentStatus', isEqualTo: "Paid")
          .where('date', isGreaterThanOrEqualTo: DateTime(year, month, 1))
          .where('date', isLessThanOrEqualTo: DateTime(year, month, 31))
          .get();

      for (final QueryDocumentSnapshot document in querySnapshot.docs) {
        final category = document['category'];
        final double total = document['total'].toDouble();
        if (result.containsKey(category)) {
          result[category] += total;
          if (result["MAX"] < result[category]) {
            result["MAX"] = result[category];
          }
        }
      }
      return result;
    } catch (e) {
      return result; // Return the initialized result with zeros if there's an error
    }
  }
}
