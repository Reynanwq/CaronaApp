import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:appcarona/models/message.dart'; 
class ChatScreen extends StatefulWidget {
  final String rideId;

  const ChatScreen({super.key, required this.rideId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats').child(widget.rideId).child('messages');

    chatRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          messages = messagesMap.entries.map((entry) {
            return Message.fromJson({
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value as Map),
            });
          }).toList();
        });
      }
    });
  }

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && messageController.text.isNotEmpty) {
      final DatabaseReference chatRef =
          FirebaseDatabase.instance.ref().child('chats').child(widget.rideId).child('messages');

      final Message message = Message(
        id: chatRef.push().key!,
        senderId: user.uid,
        senderName: user.displayName ?? 'Usuário Anônimo',
        message: messageController.text,
        timestamp: DateTime.now(),
      );

      await chatRef.child(message.id).set(message.toJson());
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat da Carona'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.senderName),
                  subtitle: Text(message.message),
                  trailing: Text(
                    message.timestamp.toLocal().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}