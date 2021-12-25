import 'package:esp8266_tft/utils/mqtt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController addressController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isConnecting = false;

  Future<void> onLoginConfirm() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.check,
              color: Colors.green,
            ),
            Padding(padding: EdgeInsets.only(left: 5), child: Text('连接中...'))
          ],
        ),
      ));
      setState(() {
        isConnecting = true;
      });
      await connect('119.31.246.213', 1883, 'yzl', 'password');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: const [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            Padding(padding: EdgeInsets.only(left: 5), child: Text('连接失败！'))
          ],
        ),
      ));
    } finally {
      setState(() {
        isConnecting = false;
      });
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
                decoration: const InputDecoration(
                  labelText: '地址',
                  hintText: '请填写地址',
                  icon: Icon(Icons.settings_input_composite),
                ),
              ),
              TextFormField(
                  controller: portController,
                  decoration: const InputDecoration(
                      labelText: '端口',
                      hintText: '请填写端口',
                      icon: Icon(Icons.important_devices))),
              TextFormField(
                  controller: userNameController,
                  decoration: const InputDecoration(
                      labelText: '账号',
                      hintText: '请填写账号',
                      icon: Icon(Icons.people))),
              TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: '密码',
                      hintText: '请填写密码',
                      icon: Icon(Icons.lock))),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(height: 40.0, width: 300),
                  child: ElevatedButton(
                    onPressed: isConnecting ? null : onLoginConfirm,
                    child: const Text('连接'),
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
