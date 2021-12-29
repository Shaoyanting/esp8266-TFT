import 'package:flutter/cupertino.dart';

class ThemeItem {
  NetworkImage image;
  String name;
  String key;

  ThemeItem(this.image, this.name, this.key);
}

List<ThemeItem> SUPPORTED_THEMES = [
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题1', '1'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题2', '2'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题3', '3'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题4', '4'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题5', '5'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题6', '6'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题7', '7'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题8', '8'),
  ThemeItem(const NetworkImage('http://cdn.yuzzl.top/1179662.jpg'), '主题9', '9'),
];
