import 'package:esp8266_tft/views/connection/connection.dart';
import 'package:esp8266_tft/views/debug/debug.dart';
import 'package:esp8266_tft/views/preview/preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '电子相框',
      theme: ThemeData(primaryColor: Colors.white),
      home: const MyStackPage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyStackPage extends StatefulWidget {
  const MyStackPage({Key? key}) : super(key: key);

  @override
  _MyStackPageState createState() => _MyStackPageState();
}

class _MyStackPageState extends State<MyStackPage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        items: [
          createItem(Icons.connected_tv, '连接'),
          createItem(Icons.remove_red_eye, '预览'),
          createItem(Icons.adb, '调试'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const <Widget>[
          Connection(),
          Preview(),
          Debug(),
        ],
      ),
    );
  }
}

BottomNavigationBarItem createItem(IconData icon, String title) {
  return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.black26, size: 30),
      activeIcon: Icon(icon, color: Colors.blue, size: 30),
      label: title);
}
