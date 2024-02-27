import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageWidget extends StatefulWidget {
  const NewMessageWidget({super.key});

  @override
  State<NewMessageWidget> createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  var _isSendingMessage = false;
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    try {
      setState(() {
        _isSendingMessage = true;
      });
      var userId = FirebaseAuth.instance.currentUser!.uid;

      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      var userName = userData.data()!['userName'];
      var userImage = userData.data()!['imageUrl'];

      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': userId,
        'userName': userName,
        'userImage': userImage,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Success sending the message',
            ),
          ),
        );
      }
    } on Exception catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error while sending the message ${error.toString()}',
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isSendingMessage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: "Send a message...",
              ),
            ),
          ),
          if (_isSendingMessage)
            const CircularProgressIndicator()
          else
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _submitMessage,
              icon: const Icon(
                Icons.send,
              ),
            )
        ],
      ),
    );
  }
}
