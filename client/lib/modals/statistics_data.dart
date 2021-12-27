class StatisticsItem {
  int id;
  int upTimestamp;
  String clientId;
  double temp;
  double hum;

  StatisticsItem(this.id, this.upTimestamp, this.clientId, this.temp, this.hum);
}

class StatisticsData {
  List<StatisticsItem> statisticsItemList = [];

  StatisticsData(List data) {
    for (var element in data) {
      statisticsItemList.add(StatisticsItem(
          element['id'],
          element['upTimestamp'],
          element['clientId'],
          element['temp'],
          element['hum']));
    }
  }
}
