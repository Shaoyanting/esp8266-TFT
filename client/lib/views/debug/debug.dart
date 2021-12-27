import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:esp8266_tft/modals/statistics_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';

class Debug extends StatefulWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  _DebugState createState() => _DebugState();
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

final timeSeriesSales = [
  TimeSeriesSales(DateTime(2017, 9, 19), 5),
  TimeSeriesSales(DateTime(2017, 9, 26), 25),
  TimeSeriesSales(DateTime(2017, 10, 3), 100),
  TimeSeriesSales(DateTime(2017, 10, 10), 75),
];

final _monthDayFormat = DateFormat('MM-dd hh:00 a');

class _DebugState extends State<Debug> {
  StatisticsData? statisticsData;

  Future<void> getTempAndHumData() async {
    var response = await Dio().get(
        'http://172.20.10.4:7001/get-statistics?clientId=esp8266-30:83:98:A4:F7:6F');
    var dataList = response.data['data'];
    StatisticsData statisticsData = StatisticsData(dataList);
    setState(() {
      this.statisticsData = statisticsData;
    });
  }

  List<TimeSeriesSales> getTimeSeriesSalesForTemp() {
    if (statisticsData == null) {
      return [];
    }
    return statisticsData!.statisticsItemList.map((e) {
      return TimeSeriesSales(
          DateTime.fromMillisecondsSinceEpoch(e.upTimestamp), e.temp.toInt());
    }).toList();
  }

  List<TimeSeriesSales> getTimeSeriesSalesForHum() {
    if (statisticsData == null) {
      return [];
    }
    return statisticsData!.statisticsItemList.map((e) {
      return TimeSeriesSales(
          DateTime.fromMillisecondsSinceEpoch(e.upTimestamp), e.hum.toInt());
    }).toList();
  }

  @override
  initState() {
    super.initState();
    //异步请求后台数据
    getTempAndHumData();
  }

  getTempChart() {
    if (getTimeSeriesSalesForTemp().isEmpty) {
      return const SizedBox(
        height: 0,
      );
    }
    return SizedBox(
      height: 350,
      child: Chart(
        data: getTimeSeriesSalesForTemp(),
        variables: {
          'time': Variable(
            accessor: (TimeSeriesSales datum) => datum.time,
            scale: TimeScale(
                ticks: [
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[0].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[7].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[15].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[23].upTimestamp)
                ],
                formatter: (time) {
                  return _monthDayFormat.format(time);
                }),
          ),
          'sales': Variable(
            accessor: (TimeSeriesSales datum) => datum.sales,
          ),
        },
        elements: [LineElement()],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: 1,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [false, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
        ),
        crosshair: CrosshairGuide(followPointer: [false, true]),
      ),
    );
  }

  getHumChart() {
    if (getTimeSeriesSalesForHum().isEmpty) {
      return const SizedBox(
        height: 0,
      );
    }
    return SizedBox(
      height: 350,
      child: Chart(
        data: getTimeSeriesSalesForHum(),
        variables: {
          'time': Variable(
            accessor: (TimeSeriesSales datum) => datum.time,
            scale: TimeScale(
                ticks: [
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[0].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[7].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[15].upTimestamp),
                  DateTime.fromMillisecondsSinceEpoch(
                      statisticsData!.statisticsItemList[23].upTimestamp)
                ],
                formatter: (time) {
                  return _monthDayFormat.format(time);
                }),
          ),
          'sales': Variable(
            accessor: (TimeSeriesSales datum) => datum.sales,
          ),
        },
        elements: [LineElement()],
        axes: [
          Defaults.horizontalAxis,
          Defaults.verticalAxis,
        ],
        selections: {
          'touchMove': PointSelection(
            on: {
              GestureType.scaleUpdate,
              GestureType.tapDown,
              GestureType.longPressMoveUpdate
            },
            dim: 1,
          )
        },
        tooltip: TooltipGuide(
          followPointer: [false, true],
          align: Alignment.topLeft,
          offset: const Offset(-20, -20),
        ),
        crosshair: CrosshairGuide(followPointer: [false, true]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text('温度统计'),
                getTempChart(),
                const SizedBox(height: 40),
                const Text('湿度统计'),
                getHumChart()
              ],
            ),
          )
        ],
      ),
    );
  }
}
