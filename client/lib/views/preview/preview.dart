import 'package:esp8266_tft/common/constants.dart';
import 'package:esp8266_tft/utils/mqtt.dart';
import 'package:esp8266_tft/views/connection/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  String currentImageNumber = '1';
  String bottomMessage = '';
  String currentTimeGap = '4';
  final TextEditingController pathController = TextEditingController();
  final TextEditingController messageListController = TextEditingController();
  final TextEditingController bottomMessageController = TextEditingController();
  final TextEditingController middleMessageController = TextEditingController();

  @override
  initState() {
    super.initState();
    //异步请求后台数据
    Future.delayed(const Duration(milliseconds: 500), () => initPreviewState());
  }

  initPreviewState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 图片资源
    String? imageNumber = prefs.getString(BACKGROUND_IMAGE_NUMBER_KEY);

    // 底部消息
    String? bottomMessage = prefs.getString(BOTTOM_MESSAGE_KEY);

    // 中部消息
    String? middleMessage = prefs.getString(MIDDLE_MESSAGE_KEY);

    // 时间间隔
    String? timeGap = prefs.getString(TIME_GAP_KEY);

    setState(() {
      this.bottomMessage = bottomMessage ?? '';
      currentTimeGap = timeGap ?? '4';

      bottomMessageController.value =
          TextEditingValue(text: bottomMessage ?? '');

      middleMessageController.value =
          TextEditingValue(text: middleMessage ?? '');

      currentImageNumber = imageNumber ?? '1';
    });
  }

  Future<void> saveAndSync() async {
    // 保存并同步
    Future.delayed(const Duration(milliseconds: 1000), () async {
      MqttClient? client = connectManager.getConnection();
      if (client != null) {
        EasyLoading.show(status: '保存中...');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(BACKGROUND_IMAGE_NUMBER_KEY, currentImageNumber);
        connectManager.publishMessage(PHOTO_TOPIC, currentImageNumber);

        await prefs.setString(
            BOTTOM_MESSAGE_KEY, bottomMessageController.value.text);

        await prefs.setString(
            MIDDLE_MESSAGE_KEY, middleMessageController.value.text);

        await prefs.setString(TIME_GAP_KEY, currentTimeGap);

        connectManager.publishMessage(
            TIP_TOPIC, middleMessageController.value.text);
        connectManager.publishMessage(
            CHAT_TOPIC, bottomMessageController.value.text);
        connectManager.publishMessage(CONTROL_TOPIC, 'bj$currentTimeGap');
        EasyLoading.showSuccess('保存成功!');
      }
    });
  }

  List<DropdownMenuItem> generateThemeList() {
    return SUPPORTED_THEMES.map((e) {
      return DropdownMenuItem(
        child: Row(
          children: [
            Image(
              image: e.image,
              alignment: AlignmentDirectional.center,
              fit: BoxFit.fitWidth,
              height: 40,
            ),
            Text(e.name)
          ],
        ),
        value: e.key,
      );
    }).toList();
  }

  List<DropdownMenuItem> generateItemList() {
    final List<DropdownMenuItem> items = [];
    const DropdownMenuItem item1 = DropdownMenuItem(
      child: Text('5 秒一次'),
      value: '1',
    );
    const DropdownMenuItem item2 = DropdownMenuItem(
      child: Text('10 秒一次'),
      value: '2',
    );
    const DropdownMenuItem item3 = DropdownMenuItem(
      child: Text('30 秒一次'),
      value: '3',
    );
    const DropdownMenuItem item4 = DropdownMenuItem(
      child: Text('60 秒一次'),
      value: '4',
    );
    const DropdownMenuItem item5 = DropdownMenuItem(
      child: Text('300 秒一次'),
      value: '5',
    );
    items.add(item1);
    items.add(item2);
    items.add(item3);
    items.add(item4);
    items.add(item5);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('预览'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
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
                                    'http://cdn.yuzzl.top/1179662.jpg'),
                                alignment: AlignmentDirectional.center,
                                fit: BoxFit.fitWidth,
                                height: 180,
                              ),
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              bottomMessage == '' ? '未设置底部消息' : bottomMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
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
                              const Text('选择主题: '),
                              Expanded(
                                  child: DropdownButton<dynamic>(
                                      // 提示文本
                                      hint: const Text('选择'),
                                      itemHeight: 60,
                                      // 下拉列表的数据
                                      items: generateThemeList(),
                                      // 改变事件
                                      onChanged: (value) {
                                        setState(() {
                                          currentImageNumber = value;
                                        });
                                      },
                                      // 是否撑满
                                      isExpanded: true,
                                      value: currentImageNumber,
                                      iconSize: 48,
                                      menuMaxHeight: 300)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('中部消息: '),
                              Expanded(
                                  child: TextField(
                                      controller: middleMessageController))
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text('底部消息: '),
                              Expanded(
                                  child: TextField(
                                controller: bottomMessageController,
                                onChanged: (e) {
                                  setState(() {
                                    bottomMessage = e;
                                  });
                                },
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              const Text('背景刷新: '),
                              Expanded(
                                  child: DropdownButton<dynamic>(
                                      // 提示文本
                                      hint: const Text('选择'),
                                      // 下拉列表的数据
                                      items: generateItemList(),
                                      // 改变事件
                                      onChanged: (value) {
                                        setState(() {
                                          currentTimeGap = value;
                                        });
                                      },
                                      // 是否撑满
                                      isExpanded: true,
                                      value: currentTimeGap,
                                      // 图标大小
                                      iconSize: 48))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints.expand(
                                  height: 40.0, width: 300),
                              child: ElevatedButton(
                                onPressed: saveAndSync,
                                child: const Text('保存并同步'),
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
