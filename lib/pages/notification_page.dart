import 'package:chat_firebase/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatNotification = Provider.of<ChatNotificationService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Notificações'),
        centerTitle: true,
      ),
      body: chatNotification.itemsCount == 0
          ? const Center(
              child: Text('Notificações'),
            )
          : ListView.builder(
              itemCount: chatNotification.itemsCount,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(chatNotification.items[index].body),
              ),
            ),
    );
  }
}
