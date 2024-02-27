import 'package:chat_app_firebase/widgets/chat_message_widget.dart';
import 'package:chat_app_firebase/widgets/new_message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpPushNotification() async {
    final fbm = FirebaseMessaging.instance;

    await fbm.requestPermission();

    fbm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setUpPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Chat",
        ),
        actions: [
          IconButton(
            onPressed: _firebase.signOut,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatMessageWidget(),
            ),
            NewMessageWidget(),
          ],
        ),
      ),
    );
  }
}
