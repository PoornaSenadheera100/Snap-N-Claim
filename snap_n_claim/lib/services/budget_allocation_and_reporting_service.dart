import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection("Expense");

class BudgetAllocationAndReportingService{
  static Stream<QuerySnapshot> getExpenses(){
    CollectionReference collectionReference = _collection;
    return collectionReference.snapshots();
  }

  static Stream<QuerySnapshot> getEligibleEmps(){
    CollectionReference collectionReference = _firestore.collection("Allocation");
    return collectionReference.snapshots();
  }
}