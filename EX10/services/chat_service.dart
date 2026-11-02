
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/chat_message.dart';

// class ChatService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   CollectionReference<Map<String, dynamic>> _messages(
//     String roomId,
//   ) {
//     return _db
//         .collection('rooms')
//         .doc(roomId)
//         .collection('messages');
//   }

//   // READ: Get a live stream of messages.
//   Stream<List<ChatMessage>> streamMessages(String roomId) {
//     return _messages(roomId)
//         .orderBy('createdAt', descending: false)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map(ChatMessage.fromFirestore)
//               .toList(),
//         );
//   }

//   // CREATE: Add a new message.
//   Future<void> sendMessage({
//     required String roomId,
//     required String text,
//     required String sender,
//   }) async {
//     final cleanText = text.trim();

//     if (cleanText.isEmpty) return;

//     await _messages(roomId).add({
//       'text': cleanText,
//       'sender': sender.trim().isEmpty ? 'Anonymous' : sender.trim(),
//       'createdAt': FieldValue.serverTimestamp(),
//       'edited': false,
//     });
//   }

//   // UPDATE: Edit an existing message.
//   Future<void> editMessage({
//     required String roomId,
//     required String messageId,
//     required String newText,
//   }) async {
//     final cleanText = newText.trim();

//     if (cleanText.isEmpty) return;

//     await _messages(roomId).doc(messageId).update({
//       'text': cleanText,
//       'edited': true,
//     });
//   }

//   // DELETE: Remove a message.
//   Future<void> deleteMessage({
//     required String roomId,
//     required String messageId,
//   }) async {
//     await _messages(roomId).doc(messageId).delete();
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messages(
    String roomId,
  ) {
    return _db
        .collection('rooms')
        .doc(roomId)
        .collection('messages');
  }

  Stream<List<ChatMessage>> streamMessages(String roomId) {
    return _messages(roomId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(ChatMessage.fromFirestore)
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String roomId,
    required String text,
    required String sender,
  }) async {
    if (text.trim().isEmpty) return;

    await _messages(roomId).add({
      'text': text.trim(),
      'sender': sender,
      'createdAt': FieldValue.serverTimestamp(),
      'edited': false,
    });
  }

  Future<void> editMessage({
    required String roomId,
    required String messageId,
    required String newText,
  }) async {
    if (newText.trim().isEmpty) return;

    await _messages(roomId).doc(messageId).update({
      'text': newText.trim(),
      'edited': true,
    });
  }

  Future<void> deleteMessage({
    required String roomId,
    required String messageId,
  }) async {
    await _messages(roomId).doc(messageId).delete();
  }
}
