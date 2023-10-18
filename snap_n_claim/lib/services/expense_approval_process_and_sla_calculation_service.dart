import 'package:cloud_firestore/cloud_firestore.dart';

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

    static Stream<QuerySnapshot<Object?>> getPendingClaims(String empNo) {
        return requestCollectionReference
            .where("status", isEqualTo: "Pending")
            .orderBy("empNo")
            .orderBy("category")
            .orderBy("total")
            .snapshots();
    }

}

