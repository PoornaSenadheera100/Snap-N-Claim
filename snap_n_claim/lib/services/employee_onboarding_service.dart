import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee.dart';
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

class EmployeeOnboardingService {
  static Future<QuerySnapshot<Object?>> getUserByEmail(String email) async {
    return await employeeCollectionReference
        .where("email", isEqualTo: email)
        .get();
  }

  static Future<Response> updateEmployee(Employee employee) async {
    Response response = Response();

    try {
      QuerySnapshot querySnapshot = await employeeCollectionReference
          .where("email", isEqualTo: employee.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs[0];

        Map<String, dynamic> data = <String, dynamic>{
          "department": employee.department,
          "emp_grade": employee.empGrade,
          "emp_no": employee.empNo,
          "emp_type": employee.empType,
          "first_login": employee.firstLogin,
          "name": employee.name,
          "password": employee.password,
          "phone": employee.phone,
        };

        await document.reference.update(data); // Update the document
        response.code = 200;
        response.message = "Employee updated!";
      } else {
        response.code = 404;
        response.message = "Employee not found with the specified email";
      }
    } catch (e) {
      response.code = 500;
      response.message = e.toString();
    }

    return response;
  }

  static Future<Response> addAccount(
      String empNo, String name, String department, String empGrade, String password, String email,String phone,String empType) async {
    Response response = Response();
    Map<String, dynamic> data = <String, dynamic>{
      "emp_no": empNo,
      "name": name,
      "department": department,
      "emp_grade": empGrade,
      "password": password,
      "email": email,
      "phone": phone,
      "first_login":true,
      "emp_type": empType
    };

    await employeeCollectionReference.doc().set(data).whenComplete(() {
      response.code = 200;
      response.message = "Account Created";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
  static Stream <QuerySnapshot> getAllEmployees(){
    return employeeCollectionReference.orderBy("emp_no").snapshots();
  }

  //METHOD 1 - COUNT OF LOGGED IN USERS
  // static Stream <QuerySnapshot> getAllLoggedInUsersCount(bool firstLogin){
  //   // return employeeCollectionReference.count().
  //   return employeeCollectionReference
  //       .where("firstLogin", isEqualTo: true)
  //       .snapshots();
  // }


  //METHOD 2 COUNT OF LOGGED IN USERS.
  // static Future<int> countEmployeesWithFirstLogin() async {
  // try {
  // final querySnapshot = await employeeCollectionReference
  //     .where("first_login", isEqualTo: true)
  //     .get();
  //
  // return querySnapshot.docs.length;
  // } catch (e) {
  // // print("Error counting employees with first login: $e");
  // return 0;
  // }
  // }

//METHOD 1 COUNT OF TO BE LOGGED IN USERS
// static Future<int> countEmployeesWithoutFirstLogin() async {
// try {
// final querySnapshot = await employeeCollectionReference
//     .where("first_login", isEqualTo: false)
//     .get();
//
// return querySnapshot.docs.length;
// } catch (e) {
// // print("Error counting employees with first login: $e");
// return 0;
// }
// }

}
