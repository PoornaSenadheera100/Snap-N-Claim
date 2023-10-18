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

class ExpenseSubmissionAndViewingClaimStateService {
    // static Future<List<Map<String, dynamic>>> getRequests() async{
    //     List<Map<String, dynamic>> requestList = [];
    //     QuerySnapshot list = await requestCollectionReference.get();
    //     for( QueryDocumentSnapshot doc in list.docs){
    //         Map<String,dynamic> data = {};
    //         data["claimNo"] = doc["claimNo"];
    //         data["category"] = doc["category"];
    //         data["date"] = doc["date"];
    //         data["department"] = doc["department"];
    //         data["empName"] = doc["empName"];
    //         data["empNo"] = doc["empNo"];
    //         data["lineItems"] = doc["lineItems"];
    //         data["paymentStatus"] = doc["paymentStatus"];
    //         data["rejectReason"] = doc["rejectReason"];
    //         data["status"] = doc["status"];
    //         data["total"] = doc["total"];
    //
    //         requestList.add(data);
    //     }
    //
    //     return requestList;
    // }

    static Stream<QuerySnapshot> getAllRequests() {
        return requestCollectionReference.snapshots();
    }

    static Stream<QuerySnapshot> getPendingRequests() {
        return requestCollectionReference.where("status", isEqualTo: "Pending").snapshots();
    }

    static Stream<QuerySnapshot> getApprovedRequests() {
        return requestCollectionReference.where("status", isEqualTo: "Approved").snapshots();
    }

    static Stream<QuerySnapshot> getRejectedRequests() {
        return requestCollectionReference.where("status", isEqualTo: "Rejected").snapshots();
    }

    static Stream<QuerySnapshot> getDraftRequests() {
        return requestCollectionReference.where("status", isEqualTo: "Draft").snapshots();
    }
}

