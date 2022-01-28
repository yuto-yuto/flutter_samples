import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _MyData {
  final DateTime date;
  final double value;

  _MyData({
    required this.date,
    required this.value,
  });
}

List<_MyData> _generateData(int max) {
  final random = new Random();

  return List.generate(
    31,
    (index) => _MyData(
      date: DateTime(2022, 1, index + 1),
      value: random.nextDouble() * max,
    ),
  );
}

class Graph extends StatefulWidget {
  @override
  _Graph createState() => _Graph();
}

class _Graph extends State<Graph> {
  late List<_MyData> _data;

  @override
  void initState() {
    _data = _generateData(10000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Graph sample"),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            // child: _graph(),
            child: _scrollGraph(),
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.5,
          ),
        ),
      ),
    );
  }

  Widget _scrollGraph() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.height * 2,
        child: _graph(),
      ),
    );
  }

  Widget _graph() {
    final spots = _data
        .asMap()
        .entries
        .map((element) => FlSpot(
              element.key.toDouble(),
              element.value.value,
            ))
        .toList();

    final spots2 = _generateData(5000)
        .asMap()
        .entries
        .map(
          (element) => FlSpot(
            element.key.toDouble(),
            element.value.value,
          ),
        )
        .toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            dotData: FlDotData(show: false),
            colors: const [Colors.blue],
          ),
          LineChartBarData(
            spots: spots2,
            dotData: FlDotData(show: false),
            colors: const [Colors.red],
          ),
        ],
        titlesData: FlTitlesData(
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            reservedSize: 6,
            getTextStyles: (context, xValue) => const TextStyle(
              color: Colors.pink,
              fontSize: 9,
            ),
            rotateAngle: 30,
            showTitles: true,
            getTitles: (xValue) {
              final date = _data[xValue.toInt()].date;
              return DateFormat.MMMd().format(date);
            },
          ),
        ),
        clipData: FlClipData.all(),
        minY: 3000,
        maxY: _data.map((e) => e.value).reduce(max),
      ),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, // Optional
    );
  }
}
