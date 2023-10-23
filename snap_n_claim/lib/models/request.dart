class Request {
  String claimNo;
  String category;
  String date;
  String department;
  String empName;
  String empNo;
  List<Map<String, dynamic>> lineItems;
  String paymentStatus;
  String rejectReason;
  String status;
  double total;

  Request(
      this.category,
      this.claimNo,
      this.date,
      this.department,
      this.empName,
      this.empNo,
      this.lineItems,
      this.paymentStatus,
      this.rejectReason,
      this.status,
      this.total);
}
