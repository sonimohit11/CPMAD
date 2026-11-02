
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatMessage {
//   final String id;
//   final String text;
//   final String sender;
//   final Timestamp? createdAt;
//   final bool edited;

//   const ChatMessage({
//     required this.id,
//     required this.text,
//     required this.sender,
//     required this.createdAt,
//     required this.edited,
//   });

//   factory ChatMessage.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> document,
//   ) {
//     final data = document.data() ?? {};

//     return ChatMessage(
//       id: document.id,
//       text: data['text'] as String? ?? '',
//       sender: data['sender'] as String? ?? 'Anonymous',
//       createdAt: data['createdAt'] as Timestamp?,
//       edited: data['edited'] as bool? ?? false,
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String sender;
  final Timestamp? createdAt;
  final bool edited;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
    required this.edited,
  });

  factory ChatMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return ChatMessage(
      id: document.id,
      text: data['text'] as String? ?? '',
      sender: data['sender'] as String? ?? 'Student',
      createdAt: data['createdAt'] as Timestamp?,
      edited: data['edited'] as bool? ?? false,
    );
  }
}
