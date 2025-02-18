import 'package:appcarona/models/message.dart'; 

class Chat {
  final String rideId;
  final List<Message> messages;

  Chat({
    required this.rideId,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    final List<Message> messages = (json['messages'] as List<dynamic>).map((item) {
      return Message.fromJson(item as Map<String, dynamic>);
    }).toList();

    return Chat(
      rideId: json['rideId'],
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

