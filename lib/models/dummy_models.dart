// lib/models/dummy_models.dart
// (Create this file or place these in your existing model files)

// Dummy User for UI purposes
class DummyUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;

  DummyUser({
    required this.id,
    required this.name,
    this.avatarUrl = 'https://i.pravatar.cc/150?img=3', // Placeholder avatar
    this.isOnline = false,
  });
}

// Dummy Chat for HomeScreen list
class DummyChat {
  final String id;
  final DummyUser otherUser;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;

  DummyChat({
    required this.id,
    required this.otherUser,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
  });
}

// Dummy Message for ChatScreen
enum MessageSender { me, other }

class DummyMessage {
  final String id;
  final String text;
  final String timestamp;
  final MessageSender sender;
  final bool isImage; // To differentiate message types

  DummyMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.sender,
    this.isImage = false,
  });
}