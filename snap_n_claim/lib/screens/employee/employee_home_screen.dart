import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/screens/employee/employee_menu_drawer.dart';
import 'package:snap_n_claim/screens/employee/employee_view_claim_indetail_screen.dart';

import '../../models/employee.dart';
import '../../services/expense_submission_and_viewing_claim_state_service.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen(this._width, this._height, this._user, {super.key});

  final double _width;
  final double _height;
  final Employee _user;

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

List<String> options = ['All', 'Pending', 'Approved', 'Rejected', 'Draft'];

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  late Stream<QuerySnapshot> _collectionReferenceDisplaying;
  late Stream<QuerySnapshot> _collectionReferenceAll;
  late Stream<QuerySnapshot> _collectionReferenceApproved;
  late Stream<QuerySnapshot> _collectionReferenceRejected;
  late Stream<QuerySnapshot> _collectionReferenceDraft;
  late Stream<QuerySnapshot> _collectionReferencePending;

  String currentOption = options[0];
  String currentPage = 'All Claims';

  List<Map<String, dynamic>> filteredRequests = [];

  late List<Map<String, dynamic>> request1;

  final double deviceWidth = 392.72727272727275;
  final double deviceHeight = 783.2727272727273;

  void initState() {
    super.initState();
    _collectionReferenceAll =
        ExpenseSubmissionAndViewingClaimStateService.getAllRequestsByEmpNo(
            widget._user.empNo);
    _collectionReferenceDisplaying = _collectionReferenceAll;
    _collectionReferenceApproved =
        ExpenseSubmissionAndViewingClaimStateService.getApprovedRequests(
            widget._user.empNo);
    _collectionReferenceRejected =
        ExpenseSubmissionAndViewingClaimStateService.getRejectedRequests(
            widget._user.empNo);
    _collectionReferenceDraft =
        ExpenseSubmissionAndViewingClaimStateService.getDraftRequests(
            widget._user.empNo);
    _collectionReferencePending =
        ExpenseSubmissionAndViewingClaimStateService.getPendingRequests(
            widget._user.empNo);
  }

  Future<void> getRequests() async {
    // request1 = await DBSer
  }

  void filter(String option) {
    setState(() {
      if (option == 'All') {
        setState(() {
          _collectionReferenceDisplaying = _collectionReferenceAll;
          currentPage = 'All Claims';
        });
      } else if (option == 'Pending') {
        setState(() {
          _collectionReferenceDisplaying = _collectionReferencePending;
          currentPage = 'Pending Claims';
        });
      } else if (option == 'Approved') {
        setState(() {
          _collectionReferenceDisplaying = _collectionReferenceApproved;
          currentPage = 'Approved Claims';
        });
      } else if (option == 'Rejected') {
        setState(() {
          _collectionReferenceDisplaying = _collectionReferenceRejected;
          currentPage = 'Rejected Claims';
        });
      } else if (option == 'Draft') {
        setState(() {
          _collectionReferenceDisplaying = _collectionReferenceDraft;
          currentPage = 'Draft Claims';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPage),
      ),
      drawer: EmployeeMenuDrawer(
          widget._width, widget._height, currentPage, widget._user),
      body: Column(
        children: [
          radioButtonGroup(),
          Expanded(
            child: LoadRequests(),
          ),
        ],
      ),
    );
  }

  Widget radioButtonGroup() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, //CHECK THIS
        children: options.map((option) {
          return Column(
            children: [
              Radio(
                value: option,
                groupValue: currentOption,
                onChanged: (value) {
                  setState(() {
                    currentOption = value.toString();
                  });
                  filter(value!);
                },
              ),
              Text(
                option,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget LoadRequests() {
    return StreamBuilder(
      stream: _collectionReferenceDisplaying,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (snapshot.data!.docs.length > 0) {
          return Padding(
            padding: EdgeInsets.only(top: widget._height / (deviceHeight / 10)),
            child: ListView(
              children: snapshot.data!.docs
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget._width / (deviceWidth / 10),
                            vertical: widget._height / (deviceHeight / 3)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EmployeeViewClaimIndetailScreen(
                                        widget._width,
                                        widget._height,
                                        widget._user,
                                        e)));
                          },
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            color: e['status'] == 'Pending'
                                ? Color(0xFFD2D060)
                                : e['status'] == 'Approved'
                                    ? Color(0xFF94B698)
                                    : e['status'] == 'Rejected'
                                        ? Color(0xFFBD7171)
                                        : Color(0xFF98B4F2),
                            child: SizedBox(
                              width: widget._width / (deviceWidth / 400),
                              height: widget._height / (deviceHeight / 90),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      widget._height / (deviceHeight / 20),
                                  horizontal:
                                      widget._width / (deviceWidth / 20),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${e['date'].toDate().day}/${e['date'].toDate().month}/${e['date'].toDate().year}",
                                        ),
                                        Text(
                                          "Rs. ${e['total'].toStringAsFixed(2)}",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${e['category']}",
                                        ),
                                        Text(
                                          "Status : ${e['status']}",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${e['claimNo']}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        } else {
          return const Center(
            child: Text('No claims'),
          );
        }
      },
    );
  }
}
