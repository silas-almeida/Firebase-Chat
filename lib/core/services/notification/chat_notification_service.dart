import 'package:chat_firebase/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

  List<ChatNotification> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  //Push Notifications
  Future<void> init() async {
    await _configureTerminated();
    await _configureForeground();
    await _configureBackgorund();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen(_handleMessage);
    }
  }

  Future<void> _configureBackgorund() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    }
  }

  Future<void> _configureTerminated() async {
    if (await _isAuthorized) {
      RemoteMessage? initialMsg = await FirebaseMessaging.instance.getInitialMessage();
      _handleMessage(initialMsg);
    }
  }

  void _handleMessage(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;
    add(
      ChatNotification(
        title: msg.notification!.title ?? 'Não informado',
        body: msg.notification!.body ?? 'Não informado',
      ),
    );
  }
}
