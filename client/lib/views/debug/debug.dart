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

final _monthDayFormat = DateFormat('MM-dd');

class _DebugState extends State<Debug> {
  Future<void> getTempAndHumData() async {
    var response = await Dio().get('http://172.20.10.4:7001/get-statistics');
    var dataList = response.data['data'];
    StatisticsData statisticsData = StatisticsData(dataList);
  }

  @override
  initState() {
    super.initState();
    //异步请求后台数据
    getTempAndHumData();
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
                SizedBox(
                  height: 350,
                  child: Chart(
                    data: timeSeriesSales,
                    variables: {
                      'time': Variable(
                        accessor: (TimeSeriesSales datum) => datum.time,
                        scale: TimeScale(
                          formatter: (time) => _monthDayFormat.format(time),
                        ),
                      ),
                      'sales': Variable(
                        accessor: (TimeSeriesSales datum) => datum.sales,
                      ),
                    },
                    elements: [
                      LineElement(shape: ShapeAttr(value: BasicLineShape()))
                    ],
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
                ),
                const SizedBox(height: 40),
                const Text('湿度统计'),
                SizedBox(
                  height: 350,
                  child: Chart(
                    data: timeSeriesSales,
                    variables: {
                      'time': Variable(
                        accessor: (TimeSeriesSales datum) => datum.time,
                        scale: TimeScale(
                          formatter: (time) => _monthDayFormat.format(time),
                        ),
                      ),
                      'sales': Variable(
                        accessor: (TimeSeriesSales datum) => datum.sales,
                      ),
                    },
                    elements: [
                      LineElement(shape: ShapeAttr(value: BasicLineShape()))
                    ],
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
