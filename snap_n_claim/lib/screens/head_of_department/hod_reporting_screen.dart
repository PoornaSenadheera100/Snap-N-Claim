import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_n_claim/models/employee.dart';
import 'package:snap_n_claim/services/budget_allocation_and_reporting_service.dart';

import 'approver_menu_drawer.dart';

class HodReportingScreen extends StatefulWidget {
  const HodReportingScreen(this._width, this._height, this.user, {super.key});

  final double _width;
  final double _height;
  final Employee user;

  @override
  State<HodReportingScreen> createState() => _HodReportingScreenState();
}

class _HodReportingScreenState extends State<HodReportingScreen> {
  final TextEditingController _empNoController = TextEditingController();
  late String _yearDropdownValue;
  late String _monthDropdownValue;
  final List<String> _years = ["2023", "2024"];
  final String currentPage = 'Department Reports';
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

  Map<String, dynamic> _expenseReportData = {
    "Transportation": 0,
    "Meals and Food": 0,
    "Accommodation": 0,
    "Equipment and Supplies": 0,
    "Communication": 0,
    "Health and Safety": 0,
    "MAX": 0,
  };

  final List<Color> _gradientColors = [
    const Color(0xFF50E4FF),
    const Color(0xFF2196F3),
  ];

  @override
  void initState() {
    super.initState();
    _yearDropdownValue = "";
    _monthDropdownValue = "";
  }

  Future<void> _onTapEmpReportViewBtn() async {
    if (_empNoController.text == '') {
      Fluttertoast.showToast(
          msg: "Enter an employee number!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: widget._width / 24.54545454545454);
    } else if (_yearDropdownValue == '') {
      Fluttertoast.showToast(
          msg: "Select an year!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: widget._width / 24.54545454545454);
    } else {
      QuerySnapshot snapshot =
          await BudgetAllocationAndReportingService.verifyUserWithDept(
              _empNoController.text.toUpperCase(), widget.user.department);
      if (snapshot.docs.isEmpty) {
        Fluttertoast.showToast(
            msg: "No Employee found in your department!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _empReportData = {
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
        });
      } else {
        _getEmpReportData();
      }
    }
  }

  Future<void> _getEmpReportData() async {
    Map<String, dynamic> res =
        await BudgetAllocationAndReportingService.getEmpReportData(
            _empNoController.text.toUpperCase(), int.parse(_yearDropdownValue));
    setState(() {
      _empReportData = res;
    });
  }

  void _onTapExpenseReportViewBtn() {
    if (_yearDropdownValue == '') {
      Fluttertoast.showToast(
          msg: "Select an year!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: widget._width / 24.54545454545454);
    } else if (_monthDropdownValue == '') {
      Fluttertoast.showToast(
          msg: "Select a month!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: widget._width / 24.54545454545454);
    } else {
      _getExpenseReportData();
    }
  }

  Future<void> _getExpenseReportData() async {
    Map<String, dynamic> res =
        await BudgetAllocationAndReportingService.getExpenseReportDataToHod(
            int.parse(_yearDropdownValue),
            _getMonthNumber(_monthDropdownValue),
            widget.user.department);
    setState(() {
      _expenseReportData = res;
    });
  }

  int _getMonthNumber(String month) {
    switch (month) {
      case "JAN":
        return 1;
      case "FEB":
        return 2;
      case "MAR":
        return 3;
      case "APR":
        return 4;
      case "MAY":
        return 5;
      case "JUN":
        return 6;
      case "JUL":
        return 7;
      case "AUG":
        return 8;
      case "SEP":
        return 9;
      case "OCT":
        return 10;
      case "NOV":
        return 11;
      case "DEC":
        return 12;
      default:
        return 0;
    }
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

  BarTouchData get _barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: widget._height / 100.3636363636364,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Color(0xFF50E4FF),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget _getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: const Color(0xFF2196F3),
      fontWeight: FontWeight.bold,
      fontSize: widget._width / 28.05194805194805,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'G001';
        break;
      case 1:
        text = 'G002';
        break;
      case 2:
        text = 'G003';
        break;
      case 3:
        text = 'G004';
        break;
      case 4:
        text = 'G005';
        break;
      case 5:
        text = 'G006';
        break;

      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: widget._height / 200.7272727272727,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get _titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: widget._height / 26.76363636363636,
            getTitlesWidget: _getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get _borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color(0xFF2196F3),
          Color(0xFF50E4FF),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get _barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Transportation"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Meals and Food"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Accommodation"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Equipment and Supplies"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Communication"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: _expenseReportData["Health and Safety"].toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];

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
                          horizontal: widget._width / 78.54545454545454),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: widget._width / 78.54545454545454),
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

  Widget _expenseReportTab() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget._width / 19.63636363636364,
            vertical: widget._height / 160.5818181818182,
          ),
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
                    _onTapExpenseReportViewBtn();
                  },
                  child: const Text("View"))
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.0,
          child: BarChart(
            BarChartData(
              barTouchData: _barTouchData,
              titlesData: _titlesData,
              borderData: _borderData,
              barGroups: _barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: (_expenseReportData["MAX"] + 1000).toDouble(),
            ),
          ),
        ),
        SizedBox(
          width: widget._width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widget._width / 26.18181818181818,
                vertical: widget._height / 32.11636363636364),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "G001",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Transportation",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "G002",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Meals and Food",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "G003",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Accommodation",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "G004",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Equipment and Supplies",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "G005",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Communication",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "G006",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                    Text(
                      " - Health and Safety",
                      style: TextStyle(
                        fontSize: widget._width / 23.10160427807486,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: ApproverMenuDrawer(
            widget._width, widget._height, currentPage, widget.user),
        appBar: AppBar(
          title: const Text("Reporting and Analytics"),
          bottom: const TabBar(tabs: [
            Text(
              "Employee\nReport",
              textAlign: TextAlign.center,
            ),
            Text(
              "Expense\nReport",
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        body: TabBarView(children: [
          _employeeReportTab(),
          _expenseReportTab(),
        ]),
      ),
    );
  }
}
