import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import 'employee_menu_drawer.dart';

class EmployeeReportingScreen extends StatefulWidget {
  const EmployeeReportingScreen(this._width, this._height, this.user,
      {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<EmployeeReportingScreen> createState() =>
      _EmployeeReportingScreenState();
}

class _EmployeeReportingScreenState extends State<EmployeeReportingScreen> {
  late String _yearDropdownValue;
  final List<String> _years = ["2023", "2024"];
  final String currentPage = 'Reports';

  Map<String, dynamic> _empReportData = {
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

  final List<Color> _gradientColors = [
    const Color(0xFF50E4FF),
    const Color(0xFF2196F3),
  ];

  @override
  void initState() {
    super.initState();
    _yearDropdownValue = "";
  }

  void _onTapEmpReportViewBtn() {
    if (_yearDropdownValue == '') {
      Fluttertoast.showToast(
          msg: "Select an year!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: widget._width / 24.54545454545454);
    } else {
      _getEmpReportData();
    }
  }

  Future<void> _getEmpReportData() async {
    Map<String, dynamic> res =
        await BudgetAllocationAndReportingService.getEmpReportData(
            widget.user.empNo, int.parse(_yearDropdownValue));
    setState(() {
      _empReportData = res;
    });
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: widget._width / 24.54545454545454,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = Text('MAR', style: style);
        break;
      case 5:
        text = Text('JUN', style: style);
        break;
      case 8:
        text = Text('SEP', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: widget._width / 26.18181818181818,
    );
    String text;
    switch (value.toInt()) {
      case 1000:
        text = '1K';
        break;
      case 5000:
        text = '5K';
        break;
      case 10000:
        text = '10K';
        break;
      case 30000:
        text = '30k';
        break;
      case 50000:
        text = '50k';
        break;
      case 100000:
        text = '100k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget _employeeReportTab() {
    return Padding(
      padding: EdgeInsets.all(widget._width / 39.27272727272727),
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: widget._height / 100.3636363636364),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget._width / 9.818181818181818),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            value: _yearDropdownValue.isNotEmpty
                                ? _yearDropdownValue
                                : null,
                            hint: const Text("Year"),
                            items: _years
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize:
                                          widget._width / 26.18181818181818),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _yearDropdownValue = newValue!;
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget._width / 78.54545454545454),
                  child: ElevatedButton(
                      onPressed: () {
                        _onTapEmpReportViewBtn();
                      },
                      child: const Text("View")),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              child: LineChart(LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: widget._height / 26.76363636363636,
                      interval: 1,
                      getTitlesWidget: _bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: _leftTitleWidgets,
                      reservedSize: widget._width / 9.35064935064935,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d)),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: _empReportData["MAX"].toDouble() + 1000,
                lineBarsData: [
                  LineChartBarData(
                    preventCurveOverShooting: true,
                    spots: [
                      FlSpot(
                          0,
                          double.parse(
                              _empReportData["JAN"].toStringAsFixed(2))),
                      FlSpot(
                          1,
                          double.parse(
                              _empReportData["FEB"].toStringAsFixed(2))),
                      FlSpot(
                          2,
                          double.parse(
                              _empReportData["MAR"].toStringAsFixed(2))),
                      FlSpot(
                          3,
                          double.parse(
                              _empReportData["APR"].toStringAsFixed(2))),
                      FlSpot(
                          4,
                          double.parse(
                              _empReportData["MAY"].toStringAsFixed(2))),
                      FlSpot(
                          5,
                          double.parse(
                              _empReportData["JUN"].toStringAsFixed(2))),
                      FlSpot(
                          6,
                          double.parse(
                              _empReportData["JUL"].toStringAsFixed(2))),
                      FlSpot(
                          7,
                          double.parse(
                              _empReportData["AUG"].toStringAsFixed(2))),
                      FlSpot(
                          8,
                          double.parse(
                              _empReportData["SEP"].toStringAsFixed(2))),
                      FlSpot(
                          9,
                          double.parse(
                              _empReportData["OCT"].toStringAsFixed(2))),
                      FlSpot(
                          10,
                          double.parse(
                              _empReportData["NOV"].toStringAsFixed(2))),
                      FlSpot(
                          11,
                          double.parse(
                              _empReportData["DEC"].toStringAsFixed(2))),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: _gradientColors,
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: _gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: EmployeeMenuDrawer(widget._width, widget._height, currentPage, widget.user),
      appBar: AppBar(
        title: const Text("Employee Report"),
      ),
      body: _employeeReportTab(),
    );
  }
}
