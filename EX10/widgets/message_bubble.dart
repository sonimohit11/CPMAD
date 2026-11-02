
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../models/chat_message.dart';

// class MessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const MessageBubble({
//     super.key,
//     required this.message,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final time = message.createdAt == null
//         ? 'Sending...'
//         : DateFormat('hh:mm a').format(
//             message.createdAt!.toDate(),
//           );

//     return Card(
//       margin: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 5,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   Icons.account_circle,
//                   color: Colors.indigo,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     message.sender,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'edit') onEdit();
//                     if (value == 'delete') onDelete();
//                   },
//                   itemBuilder: (context) => const [
//                     PopupMenuItem(
//                       value: 'edit',
//                       child: Text('Edit message'),
//                     ),
//                     PopupMenuItem(
//                       value: 'delete',
//                       child: Text('Delete message'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               message.text,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 if (message.edited)
//                   const Text(
//                     'Edited · ',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 Text(
//                   time,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final time = message.createdAt == null
        ? 'Sending...'
        : DateFormat('hh:mm a').format(message.createdAt!.toDate());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message.sender,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            Text(message.text, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${message.edited ? "Edited · " : ""}$time',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
