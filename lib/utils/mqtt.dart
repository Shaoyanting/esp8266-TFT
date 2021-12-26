import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

MqttServerClient? client;

Future<void> connect(
    String address, int port, String userName, String password) async {
  client = MqttServerClient.withPort(address, 'flutter_client', port);
  client!.logging(on: true);
  client!.onConnected = onConnected;
  client!.onDisconnected = onDisconnected;
  client!.onUnsubscribed = onUnsubscribed;
  client!.onSubscribed = onSubscribed;
  client!.onSubscribeFail = onSubscribeFail;
  client!.pongCallback = pong;

  final connMess = MqttConnectMessage()
      .withClientIdentifier('flutter_client')
      .authenticateAs(userName, password)
      .withWillTopic('willtopic')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  client!.connectionMessage = connMess;

  try {
    await client!.connect().timeout(const Duration(milliseconds: 5000));
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    print('EXAMPLE::client exception - $e');
    client!.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    print('EXAMPLE::socket exception - $e');
    client!.disconnect();
  }

  if (client!.connectionStatus!.state == MqttConnectionState.connected) {
    print('EMQX client connected!');
    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
    });

    client!.published?.listen((MqttPublishMessage message) {
      print('published');
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print(
          'Published message: $payload to topic: ${message.variableHeader?.topicName}');
    });
  } else {
    print(
        'EMQX client connection failed - disconnecting, status is ${client!.connectionStatus}');
    client!.disconnect();
  }
}

MqttClient? getConnection() {
  return client;
}

void onConnected() {
  print('Connected');
}

void onDisconnected() {
  print('Disconnected');
}

void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe topic: $topic');
}

void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

void pong() {
  print('Ping response client callback invoked');
}
