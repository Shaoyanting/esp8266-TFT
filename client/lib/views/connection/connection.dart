import 'package:esp8266_tft/common/constants.dart';
import 'package:esp8266_tft/utils/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

enum ConnectStatus { NOT_CONNECTED, CONNECTING, CONNECTED }

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  _ConnectionState createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('连接'),
      ),
      body: const Center(
        child: ConnectionContent(),
      ),
    );
  }
}

class ConnectionContent extends StatefulWidget {
  const ConnectionContent({Key? key}) : super(key: key);

  @override
  _ConnectionContentState createState() => _ConnectionContentState();
}

class _ConnectionContentState extends State<ConnectionContent> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController addressController =
      TextEditingController(text: MQTT_SERVER_ADDRESS);
  final TextEditingController portController =
      TextEditingController(text: MQTT_SERVER_PORT.toString());
  final TextEditingController userNameController =
      TextEditingController(text: MQTT_SERVER_DEFAULT_USER_NAME);
  final TextEditingController passwordController =
      TextEditingController(text: MQTT_SERVER_DEFAULT_PASSWORD);

  ConnectStatus currentStatus = ConnectStatus.NOT_CONNECTED;

  Future<void> onLoginConfirm() async {
    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }

    if (currentStatus == ConnectStatus.NOT_CONNECTED) {
      try {
        setState(() {
          currentStatus = ConnectStatus.CONNECTING;
        });
        EasyLoading.show(status: '连接中...');
        await connectManager.connect(
            addressController.value.text,
            int.parse(portController.value.text),
            userNameController.value.text,
            passwordController.value.text);

        // await connect('118.31.246.213', 1883, 'yzl', 'password');
        EasyLoading.showSuccess('连接成功!');
        connectManager.subscribeAll();
        setState(() {
          currentStatus = ConnectStatus.CONNECTED;
        });
      } catch (e) {
        EasyLoading.showError('连接失败，请重试！');
        setState(() {
          currentStatus = ConnectStatus.NOT_CONNECTED;
        });
      }
    } else if (currentStatus == ConnectStatus.CONNECTED) {
      EasyLoading.show(status: '正在断开连接...');
      MqttClient? client = connectManager.getConnection();
      if (client != null) {
        client.disconnect();
        EasyLoading.showSuccess('连接已断开');
        setState(() {
          currentStatus = ConnectStatus.NOT_CONNECTED;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: addressController,
                validator: Validators.compose([
                  Validators.required('请填写地址'),
                ]),
                decoration: const InputDecoration(
                  labelText: '地址',
                  icon: Icon(Icons.settings_input_composite),
                ),
              ),
              TextFormField(
                  controller: portController,
                  validator: Validators.compose([
                    Validators.required('请填写端口'),
                  ]),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                      labelText: '端口', icon: Icon(Icons.important_devices))),
              TextFormField(
                  controller: userNameController,
                  validator: Validators.compose([
                    Validators.required('请填写账号'),
                  ]),
                  decoration: const InputDecoration(
                      labelText: '账号', icon: Icon(Icons.people))),
              TextFormField(
                  controller: passwordController,
                  validator: Validators.compose([
                    Validators.required('请填写密码'),
                  ]),
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: '密码', icon: Icon(Icons.lock))),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(height: 40.0, width: 300),
                  child: ElevatedButton(
                    onPressed: currentStatus == ConnectStatus.CONNECTING
                        ? null
                        : onLoginConfirm,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            currentStatus == ConnectStatus.CONNECTED
                                ? Colors.redAccent
                                : Colors.blue)),
                    child: Text(currentStatus == ConnectStatus.CONNECTED
                        ? '断开连接'
                        : '连接'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
