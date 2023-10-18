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

class ExpenseApprovalProcessAndSlaCalculationService {}
