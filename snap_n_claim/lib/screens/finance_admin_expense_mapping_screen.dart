import 'package:flutter/material.dart';

class FinanceAdminExpenseMappingScreen extends StatefulWidget {
  const FinanceAdminExpenseMappingScreen(this._width, this._height,
      this._glCode, this._glName, this._transactionLimit, this._monthlyLimit,
      {super.key});

  final double _width;
  final double _height;
  final String _glCode;
  final String _glName;
  final double _transactionLimit;
  final double _monthlyLimit;

  @override
  State<FinanceAdminExpenseMappingScreen> createState() =>
      _FinanceAdminExpenseMappingSelectionScreenState();
}

class _FinanceAdminExpenseMappingSelectionScreenState
    extends State<FinanceAdminExpenseMappingScreen> {
  final TextEditingController _glCodeController = TextEditingController();
  final TextEditingController _glNameController = TextEditingController();
  final TextEditingController _transactionLimitController =
      TextEditingController();
  final TextEditingController _monthlyLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _glCodeController.text = widget._glCode;
    _glNameController.text = widget._glName;
    _transactionLimitController.text =
        "Rs. ${widget._transactionLimit.toStringAsFixed(2)}";
    _monthlyLimitController.text =
        "Rs. ${widget._monthlyLimit.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    print(widget._width);
    print(widget._height);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Mapping"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: widget._height / 40.14545454545455),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(bottom: widget._height / 80.29090909090909),
              child: Container(
                width: widget._width / 1.05,
                color: Colors.grey,
                child: const Center(child: Text("Expense Info")),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("GL Code"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          controller: _glCodeController,
                          readOnly: true,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder()),
                        ),
                        const Divider(),
                        const Text("Transaction Limit"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _transactionLimitController,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          (widget._width / 2 - widget._width / 2.1) / 2),
                  child: SizedBox(
                    width: widget._width / 2.1,
                    child: Column(
                      children: [
                        const Text("GL Name"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _glNameController,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder()),
                        ),
                        const Divider(),
                        const Text("Monthly Limit"),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                          readOnly: true,
                          controller: _monthlyLimitController,
                          decoration:
                              const InputDecoration(border: OutlineInputBorder()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: widget._height / 40.14545454545455),
              child: Container(
                width: widget._width / 1.05,
                color: Colors.grey,
                child: const Center(child: Text("Eligible Employees")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
