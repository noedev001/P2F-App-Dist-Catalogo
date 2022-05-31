import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificaciones {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;

  static StreamController<String> _messageStreamController =
      new StreamController.broadcast();

  static Stream<String> get messageStream => _messageStreamController.stream;

  static Future _onBackgrounHandler(RemoteMessage message) async {
    //print("backgraund ${message.messageId}");
    //print(message.data);
    //_messageStreamController.add(message.notification?.title ?? "No Title");
    _messageStreamController.add(message.data['tipo'].toString());
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print("onMessgae ${message.messageId}");
    //print(message.data);
    //_messageStreamController.add(message.notification?.title ?? "No Title");
    _messageStreamController.add(message.data['tipo'].toString());
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print("MessageOpenApp ${message.messageId}");
    //print(message.data);
    //_messageStreamController.add(message.notification?.title ?? "No Title");
    _messageStreamController.add(message.data['tipo'].toString());
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    //print('============Token ===========');
    //print(token);

    //---handler

    FirebaseMessaging.onBackgroundMessage(_onBackgrounHandler); //minimizada
    FirebaseMessaging.onMessage.listen(_onMessageHandler); //aplicacion abierta
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp); //finalizada
  }

  static closesStreams() {
    _messageStreamController.close();
  }
}
