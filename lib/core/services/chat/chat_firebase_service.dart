import 'dart:async';
import 'package:chat_firebase/core/models/chat_user.dart';
import 'package:chat_firebase/core/models/chat_message.dart';
import 'package:chat_firebase/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        ).orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snaphsot) => snaphsot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final msg = ChatMessage(
        id: '',
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImageUrl: user.imageURL);
    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);

    final docSnapshot = await docRef.get();
    return docSnapshot.data()!;
  }

  ChatMessage _fromFirestore(
    DocumentSnapshot doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
        id: doc.id,
        text: doc['text'],
        createdAt: DateTime.parse(doc['createdAt']),
        userId: doc['userId'],
        userName: doc['userName'],
        userImageUrl: doc['userImageURL']);
  }

  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageUrl,
    };
  }
}
