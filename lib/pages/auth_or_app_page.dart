import 'package:chat_firebase/core/models/chat_user.dart';
import 'package:chat_firebase/core/services/auth/auth_service.dart';
import 'package:chat_firebase/pages/auth_page.dart';
import 'package:chat_firebase/pages/chat_page.dart';
import 'package:chat_firebase/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return StreamBuilder<ChatUser?>(
              stream: AuthService().userChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else {
                  if (snapshot.hasData) {
                    return const ChatPage();
                  } else {
                    return const AuthPage();
                  }
                }
              },
            );
          }
        });
  }
}
