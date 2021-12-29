import 'dart:typed_data';

import 'package:esp8266_tft/common/constants.dart';
import 'package:esp8266_tft/utils/mqtt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  int currentTheme = 0;
  Uint8List? currentImageByteList;
  String bottomMessage = '';

  final TextEditingController pathController = TextEditingController();
  TextEditingController messageListController = TextEditingController();
  final TextEditingController bottomMessageController = TextEditingController();

  @override
  initState() {
    super.initState();
    //异步请求后台数据
    Future.delayed(const Duration(milliseconds: 500), () => initPreviewState());
  }

  initPreviewState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 图片资源
    List<String>? imageByteList = prefs.getStringList(BACKGROUND_IMAGE_KEY);

    // 底部消息
    String? bottomMessage = prefs.getString(BOTTOM_MESSAGE_KEY);

    setState(() {
      this.bottomMessage = bottomMessage ?? '';
      bottomMessageController.value =
          TextEditingValue(text: bottomMessage ?? '');

      if (imageByteList != null) {
        currentImageByteList =
            Uint8List.fromList(imageByteList.map((e) => int.parse(e)).toList());
      }
    });
  }

  Row renderTheme(int themeType) {
    if (themeType == 0) {
      return Row(
        children: [
          const Text('上传图片: '),
          ElevatedButton(
            onPressed: uploadImage,
            child: const Text('点我上传'),
          )
        ],
      );
    }

    return Row(
      children: [
        const Text('消息列表: '),
        Expanded(
            child: TextField(
          controller: messageListController,
          minLines: 1,
          maxLines: 5,
          maxLength: 100,
        ))
      ],
    );
  }

  Future<void> saveAndSync() async {
    // 保存并同步
    Future.delayed(const Duration(milliseconds: 1000), () async {
      MqttClient? client = connectManager.getConnection();
      if (client != null) {
        print('===== 保存中 =====');
        EasyLoading.show(status: '保存中...');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (currentImageByteList != null) {
          print('===== 开始保存图片 大小: ${currentImageByteList!.length} =====');
          await prefs.setStringList(BACKGROUND_IMAGE_KEY,
              currentImageByteList!.map((e) => e.toString()).toList());
          connectManager.publishMessage(
              PHOTO_TOPIC,
              currentImageByteList!
                  .map((e) => e.toString())
                  .toList()
                  .toString());
        }
        await prefs.setString(
            BOTTOM_MESSAGE_KEY, bottomMessageController.value.text);

        connectManager.publishMessage(
            CHAT_TOPIC, bottomMessageController.value.text);
        EasyLoading.showSuccess('保存成功!');
      }
    });
  }

  Future<void> uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageByteList = await image.readAsBytes();

      setState(() {
        currentImageByteList = imageByteList;
      });
    }
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
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                              child: currentImageByteList != null
                                  ? Image(
                                      image: MemoryImage(currentImageByteList!),
                                      alignment: AlignmentDirectional.center,
                                      fit: BoxFit.fitWidth,
                                      height: 180,
                                    )
                                  : null,
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              bottomMessage == '' ? '未设置底部消息' : bottomMessage,
                              // '同学你好！Flutter 中，我们可以通过 Image 组件来加载并显示图片哦',
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
                              const Text('图片展示'),
                              const SizedBox(width: 20),
                              Radio(
                                // 按钮的值
                                value: 1,
                                // 改变事件
                                onChanged: null,
                                // 按钮组的值
                                groupValue: currentTheme,
                              ),
                              const Text('列表信息')
                            ],
                          ),
                          const SizedBox(height: 10),
                          renderTheme(currentTheme),
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
