import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  final TextEditingController pathController = TextEditingController();
  int currentTheme = 0;
  TextEditingController messageListController = TextEditingController();

  Row renderTheme(int themeType) {
    if (themeType == 0) {
      return Row(
        children: [
          Text("上传图片: "),
          ElevatedButton(
            onPressed: () => {},
            child: Text("点我上传"),
          )
        ],
      );
    }

    return Row(
      children: [
        const Text("消息列表: "),
        Expanded(
            child: TextField(
          controller: messageListController,
          minLines: 5,
          maxLines: 5,
          maxLength: 100,
        ))
      ],
    );
  }

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
                        children: [
                          Row(
                            children: [
                              const Text("选择主题: "),
                              Radio(
                                // 按钮的值
                                value: 0,
                                // 改变事件
                                onChanged: (value) {
                                  setState(() {
                                    currentTheme = 0;
                                  });
                                },
                                // 按钮组的值
                                groupValue: currentTheme,
                              ),
                              const Text("图片展示"),
                              const SizedBox(width: 20),
                              Radio(
                                // 按钮的值
                                value: 1,
                                // 改变事件
                                onChanged: (value) {
                                  setState(() {
                                    currentTheme = 1;
                                  });
                                },
                                // 按钮组的值
                                groupValue: currentTheme,
                              ),
                              const Text("列表信息")
                            ],
                          ),
                          SizedBox(height: 10),
                          renderTheme(currentTheme),
                          SizedBox(height: 10),
                          Row(
                            children: const [
                              Text("底部消息: "),
                              Expanded(child: TextField())
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(
                                  height: 40.0, width: 300),
                              child: ElevatedButton(
                                onPressed: () => {},
                                child: const Text("保存并同步"),
                              ),
                            ),
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
