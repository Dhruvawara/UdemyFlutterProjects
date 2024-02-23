import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
      body: const Placeholder(),
    );
  }
}
