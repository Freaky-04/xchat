import 'package:flutter/material.dart';
import 'package:xchat/models/dummy_models.dart'; // Adjust path
import 'dart:async'; // For StreamSubscription

class ChatScreen extends StatefulWidget {
  final String chatId;
  final DummyUser otherUser;
  final bool isCurrentUserRoot;
  final bool isOtherUserRoot; // To know if the person being chatted with is root

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUser,
    required this.isCurrentUserRoot,
    required this.isOtherUserRoot,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<DummyMessage> _messages = [
    DummyMessage(id: 'm1', text: 'Hello there!', timestamp: '10:00 AM', sender: MessageSender.other),
    DummyMessage(id: 'm2', text: 'Hi! How are you?', timestamp: '10:01 AM', sender: MessageSender.me),
    DummyMessage(id: 'm3', text: 'Doing great! You?', timestamp: '10:01 AM', sender: MessageSender.other),
    DummyMessage(id: 'm4', text: 'Awesome! Just working on this cool app.', timestamp: '10:02 AM', sender: MessageSender.me),
    DummyMessage(id: 'm5', text: 'https://i.pravatar.cc/300?img=10', timestamp: '10:03 AM', sender: MessageSender.other, isImage: true),
    DummyMessage(id: 'm6', text: 'Nice picture!', timestamp: '10:04 AM', sender: MessageSender.me),
  ];

  // Placeholder for screenshot detection service
  StreamSubscription? _screenshotSubscription;
  bool _showScreenshotNotification = false;

  @override
  void initState() {
    super.initState();
    // Simulate screenshot detection logic
    if (!widget.isCurrentUserRoot && widget.isOtherUserRoot) { // Normal user chatting with root user
      // This is where you'd integrate your actual ScreenshotService
      // For demo, let's simulate a screenshot detection after a delay
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          _handleScreenshotDetected();
        }
      });
    }
    // Scroll to bottom initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _handleScreenshotDetected() {
    // This would be triggered by your ScreenshotService
    // For UI demo, we just show a snackbar
    if (mounted && !widget.isCurrentUserRoot && widget.isOtherUserRoot) {
      // Root user gets notified via Firestore. Normal user doesn't see anything directly.
      // But for this demo, let's imagine the root user is also this user and show something.
      // Or if this IS the root user, and other is normal (this logic is reversed for demo)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.otherUser.name} was notified about a screenshot.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      // In a real app, you'd call:
      // Provider.of<FirestoreService>(context, listen: false).createScreenshotAlert(...)
    }
  }


  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(DummyMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _messageController.text.trim(),
        timestamp: TimeOfDay.now().format(context), // Simple time format
        sender: MessageSender.me,
      ));
      _messageController.clear();
      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
    // TODO: Send message to Firebase
  }

  void _pickImage() {
    // TODO: Implement image picker and send image
    setState(() {
      _messages.add(DummyMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'https://i.pravatar.cc/300?img=${DateTime.now().second % 50}', // Dummy image URL
        timestamp: TimeOfDay.now().format(context),
        sender: MessageSender.me,
        isImage: true,
      ));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }


  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _screenshotSubscription?.cancel(); // Cancel if you used a real stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 2.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUser.avatarUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUser.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary)),
                if (widget.otherUser.isOnline)
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.lightGreenAccent.shade100),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call, color: theme.colorScheme.onPrimary), onPressed: () {}),
          IconButton(icon: Icon(Icons.videocam, color: theme.colorScheme.onPrimary), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message.sender == MessageSender.me;
                return _MessageBubble(message: message, isMe: isMe, theme: theme);
              },
            ),
          ),
          _ChatInput(
            controller: _messageController,
            onSend: _sendMessage,
            onPickImage: _pickImage,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final DummyMessage message;
  final bool isMe;
  final ThemeData theme;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: message.isImage ? const EdgeInsets.all(6.0) : const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: isMe ? theme.colorScheme.primaryContainer : theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18.0),
              topRight: const Radius.circular(18.0),
              bottomLeft: isMe ? const Radius.circular(18.0) : const Radius.circular(4.0),
              bottomRight: isMe ? const Radius.circular(4.0) : const Radius.circular(18.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  message.text, // Assuming URL is in text for image messages
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      width: 200, // Maintain aspect ratio if possible
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.broken_image, color: Colors.grey.shade600, size: 50)),
                ),
              )
            else
              Text(
                message.text,
                style: TextStyle(color: isMe ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSecondaryContainer, fontSize: 15.5),
              ),
            const SizedBox(height: 4.0),
            Text(
              message.timestamp,
              style: TextStyle(
                fontSize: 11.0,
                color: (isMe ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSecondaryContainer).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final ThemeData theme;

  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.onPickImage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.cardColor, // Or theme.scaffoldBackgroundColor
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea( // Ensure input is not obscured by system UI
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.add_photo_alternate_outlined, color: theme.colorScheme.primary, size: 28),
              onPressed: onPickImage,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none, // Remove default border from theme
                  filled: false, // Ensure it's not filled by default theme here
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: 5,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send_rounded, color: theme.colorScheme.primary, size: 28),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}