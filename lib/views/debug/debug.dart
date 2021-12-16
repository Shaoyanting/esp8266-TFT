import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Debug extends StatefulWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  _DebugState createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('调试'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  width: double.infinity,
                  height: 255,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}')),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}')),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}')),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}')),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}')),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('[debug] {name: yuzhanglong, age: 21}'))
                    ],
                  ),
                )),
            Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "请输入要发送的消息", prefixIcon: Icon(Icons.send)),
                      obscureText: true,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints.expand(height: 40.0, width: 300),
                      child: ElevatedButton(
                        onPressed: () => {},
                        child: const Text("发送"),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
