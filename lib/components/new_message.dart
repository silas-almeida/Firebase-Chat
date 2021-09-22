import 'package:chat_firebase/core/services/auth/auth_service.dart';
import 'package:chat_firebase/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;
    if (user != null) {
      await ChatService().save(_message, user);
      setState(() {
        _message = '';
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20.0, left: 12, right: 12, top: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (msg) => setState(() {
                _message = msg;
              }),
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'Enviar Mensagem'),
              onSubmitted: (_) {
                if (_message.trim().isNotEmpty) {
                  _sendMessage();
                }
              },
            ),
          ),
          IconButton(
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
