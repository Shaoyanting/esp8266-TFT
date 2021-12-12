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
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              controller: _unameController,
              decoration: const InputDecoration(
                labelText: "地址",
                hintText: "请填写地址",
                icon: Icon(Icons.person),
              ),
            ),
            TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                    labelText: "端口",
                    hintText: "请填写端口",
                    icon: Icon(Icons.lock))),
            TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                    labelText: "路径",
                    hintText: "请填写端口",
                    icon: Icon(Icons.lock))),
            TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                    labelText: "账号",
                    hintText: "请填写账号",
                    icon: Icon(Icons.lock))),
            TextFormField(
                controller: _pwdController,
                decoration: const InputDecoration(
                    labelText: "密码",
                    hintText: "请填写密码",
                    icon: Icon(Icons.lock))),
          ],
        ),
      ),
    );
  }
}
