
// import 'package:flutter/material.dart';

// import '../models/chat_message.dart';
// import '../services/chat_service.dart';
// import '../widgets/message_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final String roomId;
//   final String roomName;

//   const ChatScreen({
//     super.key,
//     required this.roomId,
//     required this.roomName,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ChatService _chatService = ChatService();
//   final TextEditingController _messageController =
//       TextEditingController();
//   final TextEditingController _searchController =
//       TextEditingController();

//   String _searchQuery = '';
//   bool _sending = false;

//   // CREATE: Send a message.
//   Future<void> _sendMessage() async {
//     final text = _messageController.text.trim();

//     if (text.isEmpty || _sending) return;

//     setState(() => _sending = true);

//     try {
//       await _chatService.sendMessage(
//         roomId: widget.roomId,
//         text: text,
//         sender: 'Student',
//       );

//       _messageController.clear();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not send message: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _sending = false);
//     }
//   }

//   // UPDATE: Edit a message.
//   Future<void> _editMessage(ChatMessage message) async {
//     final controller = TextEditingController(text: message.text);

//     final newText = await showDialog<String>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Edit Message'),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           maxLines: 4,
//           decoration: const InputDecoration(
//             hintText: 'Enter updated message',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.pop(dialogContext, controller.text);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );

//     controller.dispose();

//     if (newText == null || newText.trim().isEmpty) return;

//     try {
//       await _chatService.editMessage(
//         roomId: widget.roomId,
//         messageId: message.id,
//         newText: newText,
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not edit message: $e')),
//       );
//     }
//   }

//   // DELETE: Delete a message.
//   Future<void> _deleteMessage(ChatMessage message) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         title: const Text('Delete Message?'),
//         content: const Text(
//           'Are you sure you want to delete this message?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(dialogContext, false),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             onPressed: () => Navigator.pop(dialogContext, true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       await _chatService.deleteMessage(
//         roomId: widget.roomId,
//         messageId: message.id,
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not delete message: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.roomName),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // POST-EXPERIMENT TASK 2: Search messages.
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 setState(() => _searchQuery = value.trim());
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search messages...',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () {
//                           _searchController.clear();
//                           setState(() => _searchQuery = '');
//                         },
//                       )
//                     : null,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: StreamBuilder<List<ChatMessage>>(
//               stream: _chatService.streamMessages(widget.roomId),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error loading messages: ${snapshot.error}'),
//                   );
//                 }

//                 if (snapshot.connectionState ==
//                         ConnectionState.waiting &&
//                     !snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final allMessages = snapshot.data ?? [];

//                 final messages = allMessages.where((message) {
//                   return message.text.toLowerCase().contains(
//                         _searchQuery.toLowerCase(),
//                       );
//                 }).toList();

//                 if (messages.isEmpty) {
//                   return Center(
//                     child: Text(
//                       _searchQuery.isEmpty
//                           ? 'No messages yet. Start chatting!'
//                           : 'No matching messages found.',
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];

//                     return MessageBubble(
//                       message: message,
//                       onEdit: () => _editMessage(message),
//                       onDelete: () => _deleteMessage(message),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//           // Message input.
//           SafeArea(
//             top: false,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _messageController,
//                       textCapitalization: TextCapitalization.sentences,
//                       minLines: 1,
//                       maxLines: 4,
//                       onSubmitted: (_) => _sendMessage(),
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton.filled(
//                     onPressed: _sending ? null : _sendMessage,
//                     icon: _sending
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                             ),
//                           )
//                         : const Icon(Icons.send),
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.indigo,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _service = ChatService();
  final TextEditingController _messageController =
      TextEditingController();
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';
  bool _sending = false;

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);

    try {
      await _service.sendMessage(
        roomId: widget.roomId,
        text: text,
        sender: 'Student',
      );
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Send failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _editMessage(ChatMessage message) async {
    final controller = TextEditingController(text: message.text);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter new message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (result == null || result.trim().isEmpty) return;

    try {
      await _service.editMessage(
        roomId: widget.roomId,
        messageId: message.id,
        newText: result,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Edit failed: $e')),
      );
    }
  }

  Future<void> _deleteMessage(ChatMessage message) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Do you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.deleteMessage(
        roomId: widget.roomId,
        messageId: message.id,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // POST-LAB 2: Keyword search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
              decoration: InputDecoration(
                hintText: 'Search messages by keyword...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _service.streamMessages(widget.roomId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading messages.'),
                  );
                }

                if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final allMessages = snapshot.data ?? [];

                final filteredMessages = allMessages.where((message) {
                  return message.text.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                }).toList();

                if (filteredMessages.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No messages yet. Send your first message!'
                          : 'No matching messages found.',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final message = filteredMessages[index];

                    return MessageBubble(
                      message: message,
                      onEdit: () => _editMessage(message),
                      onDelete: () => _deleteMessage(message),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 4,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _sendMessage,
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
