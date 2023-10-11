import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import '../utils/pie_chart_indicator.dart';

class FinanceAdminReportingScreen extends StatefulWidget {
  FinanceAdminReportingScreen(this._width, this._height, {super.key});

  double _width;
  double _height;

  @override
  State<FinanceAdminReportingScreen> createState() =>
      _FinanceAdminReportingScreenState();
}

class _FinanceAdminReportingScreenState
    extends State<FinanceAdminReportingScreen> {
  final TextEditingController _empNoController = TextEditingController();
  late String _yearDropdownValue;
  late String _monthDropdownValue;
  final List<String> _years = ["2023", "2024"];
  final List<String> _months = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

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

  Map<String, dynamic> _deptReportData = {
    "Production Department": 10,
    "IT Department": 0,
    "Finance Department": 0,
    "HR Department": 0,
    "Marketing Department": 0,
    "Safety and Security Department": 0
  };

  List<Color> gradientColors = [
    Color(0xFF50E4FF),
    Color(0xFF2196F3),
  ];

  @override
  void initState() {
    super.initState();
    _yearDropdownValue = "";
    _monthDropdownValue = "";
  }

  Future<void> _getEmpReportData() async {
    Map<String, dynamic> res =
        await BudgetAllocationAndReportingService.getEmpReportData(
            _empNoController.text, int.parse(_yearDropdownValue));
    print(res.toString());
    setState(() {
      _empReportData = res;
    });
  }

  Future<void> _getDeptReportData() async {
    print(_monthDropdownValue);
    print(_yearDropdownValue);
    // Map<String, dynamic> res =
    // await BudgetAllocationAndReportingService.getEmpReportData(
    //     _empNoController.text, int.parse(_yearDropdownValue));
    // print(res.toString());
    // setState(() {
    //   _deptReportData = res;
    // });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
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

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final fontSize = 16.0;
      final radius = 180.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xFF2196F3),
            value: _deptReportData["Production Department"].toDouble(),
            title: _deptReportData["Production Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFFFFC300),
            value: _deptReportData["IT Department"].toDouble(),
            title: _deptReportData["IT Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );

        case 2:
          return PieChartSectionData(
            color: Color(0xFF3BFF49),
            value: _deptReportData["Finance Department"].toDouble(),
            title: _deptReportData["Finance Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xFF91C922),
            value: _deptReportData["HR Department"].toDouble(),
            title: _deptReportData["HR Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.deepOrangeAccent,
            value: _deptReportData["Marketing Department"].toDouble(),
            title: _deptReportData["Marketing Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: Color(0xFF6E1BFF),
            value: _deptReportData["Safety and Security Department"].toDouble(),
            title: _deptReportData["Safety and Security Department"].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Widget _employeeReportTab() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextField(
                        controller: _empNoController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), hintText: "Emp No."),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _getEmpReportData();
                      },
                      child: Text("View")),
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
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 42,
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
                //6,
                lineBarsData: [
                  LineChartBarData(
                    preventCurveOverShooting: true,
                    spots: [
                      FlSpot(0, _empReportData["JAN"].toDouble()),
                      FlSpot(1, _empReportData["FEB"].toDouble()),
                      FlSpot(2, _empReportData["MAR"].toDouble()),
                      FlSpot(3, _empReportData["APR"].toDouble()),
                      FlSpot(4, _empReportData["MAY"].toDouble()),
                      FlSpot(5, _empReportData["JUN"].toDouble()),
                      FlSpot(6, _empReportData["JUL"].toDouble()),
                      FlSpot(7, _empReportData["AUG"].toDouble()),
                      FlSpot(8, _empReportData["SEP"].toDouble()),
                      FlSpot(9, _empReportData["OCT"].toDouble()),
                      FlSpot(10, _empReportData["NOV"].toDouble()),
                      FlSpot(11, _empReportData["DEC"].toDouble()),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors
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

  Widget _departmentsReportTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: _yearDropdownValue.isNotEmpty
                        ? _yearDropdownValue
                        : null,
                    hint: const Text("Year"),
                    items: _years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _yearDropdownValue = newValue!;
                      });
                    }),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: _monthDropdownValue.isNotEmpty
                        ? _monthDropdownValue
                        : null,
                    hint: const Text("Month"),
                    items:
                        _months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: widget._width / 26.18181818181818),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _monthDropdownValue = newValue!;
                      });
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    _getDeptReportData();
                  },
                  child: Text("View"))
            ],
          ),
        ),
        const SizedBox(
          width: 28,
        ),
        Expanded(
          child: PieChart(PieChartData(
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(),
          )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

                PieChartIndicator(
                  color: Color(0xFF2196F3),
                  text: 'Production Department',
                  isSquare: true,
                ),
                PieChartIndicator(
                  color: Color(0xFF3BFF49),
                  text: 'IT Department',
                  isSquare: true,
                ),


                PieChartIndicator(
                  color: Color(0xFFFFC300),
                  text: 'Finance Department',
                  isSquare: true,
                ),PieChartIndicator(
                  color: Color(0xFF3BFF49),
                  text: 'HR Department',
                  isSquare: true,
                ),


                PieChartIndicator(
                  color: Color(0xFF6E1BFF),
                  text: 'Marketing Department',
                  isSquare: true,
                ),PieChartIndicator(
                  color: Color(0xFF3BFF49),
                  text: 'Safety and Security Department',
                  isSquare: true,
                ),

            SizedBox(
              height: 18,
            ),
          ],
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  Widget _expenseReportTab() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reporting and Analytics"),
          bottom: const TabBar(tabs: [
            Text(
              "Employee\nReport",
              textAlign: TextAlign.center,
            ),
            Text(
              "Departments\nReport",
              textAlign: TextAlign.center,
            ),
            Text(
              "Expense Report",
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        body: TabBarView(children: [
          _employeeReportTab(),
          _departmentsReportTab(),
          _expenseReportTab(),
        ]),
      ),
    );
  }
}
