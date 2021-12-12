import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final TextEditingController pathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('预览'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    height: 255,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                                child: Text('12-09',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 13))),
                            Expanded(
                                child: Text('16:05',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 13))),
                            Expanded(
                                child: Text('星期四',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 13)))
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: Image(
                                image: NetworkImage(
                                    "http://cdn.yuzzl.top/1179662.jpg"),
                                alignment: AlignmentDirectional.center,
                                fit: BoxFit.fitWidth,
                                height: 180,
                              ),
                            ))
                          ],
                        ),
                        Row(
                          children: const [
                            Expanded(
                                child: Text(
                              '同学你好！Flutter 中，我们可以通过 Image 组件来加载并显示图片哦',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "用户名或邮箱",
                                prefixIcon: Icon(Icons.person)
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "您的登录密码",
                                prefixIcon: Icon(Icons.lock)
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
