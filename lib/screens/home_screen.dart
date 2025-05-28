import 'package:flutter/material.dart';
import 'package:xchat/models/dummy_models.dart'; // Adjust path
import 'package:xchat/screens/chat_screen.dart'; // Adjust path
import 'package:xchat/screens/login_screen.dart'; // Adjust path for logout

class HomeScreen extends StatefulWidget {
  final bool isRootUser;
  const HomeScreen({super.key, this.isRootUser = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data
  final List<DummyChat> _chats = [
    DummyChat(
      id: '1',
      otherUser: DummyUser(id: 'user2', name: 'Alice Wonderland', avatarUrl: 'https://i.pravatar.cc/150?img=1', isOnline: true),
      lastMessage: 'Hey, how are you doing today?',
      timestamp: '10:30 AM',
      unreadCount: 2,
    ),
    DummyChat(
      id: '2',
      otherUser: DummyUser(id: 'user3', name: 'Bob The Builder', avatarUrl: 'https://i.pravatar.cc/150?img=5'),
      lastMessage: 'Can we build it? Yes, we can!',
      timestamp: 'Yesterday',
    ),
    DummyChat(
      id: '3',
      otherUser: DummyUser(id: 'user4', name: 'Charlie Brown', avatarUrl: 'https://i.pravatar.cc/150?img=7', isOnline: true),
      lastMessage: 'Good grief! 😅',
      timestamp: '9:15 AM',
      unreadCount: 0,
    ),
    DummyChat(
      id: '4',
      otherUser: DummyUser(id: 'user5', name: 'Diana Prince', avatarUrl: 'https://i.pravatar.cc/150?img=12'),
      lastMessage: 'See you at the meeting.',
      timestamp: 'Mon',
      unreadCount: 5,
    ),
  ];

  int _screenshotAlertCount = 3; // Dummy alert count for root user

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('XChats', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary)),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.onPrimary),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          if (widget.isRootUser)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shield_outlined, color: theme.colorScheme.onPrimary), // <--- CORRECTED ICON
                  onPressed: () {
                    // TODO: Navigate to screenshot alerts screen or show a dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$_screenshotAlertCount new screenshot alerts! (Placeholder)')),
                    );
                  },
                ),
                if (_screenshotAlertCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$_screenshotAlertCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onPrimary),
            onSelected: (value) {
              if (value == 'profile') {
                // TODO: Navigate to Profile Screen
              } else if (value == 'settings') {
                // TODO: Navigate to Settings Screen
              } else if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'profile', child: Text('Profile')),
              const PopupMenuItem<String>(value: 'settings', child: Text('Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _chats.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No chats yet.',
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation by tapping the + button.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ],
        ),
      )
          : ListView.separated(
        itemCount: _chats.length,
        separatorBuilder: (context, index) => Divider(height: 0, indent: 72, endIndent: 16, color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(chat.otherUser.avatarUrl),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: chat.otherUser.avatarUrl.isEmpty ? Text(chat.otherUser.name.substring(0,1), style: TextStyle(color: theme.colorScheme.onSecondaryContainer)) : null,
                ),
                if (chat.otherUser.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(chat.otherUser.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: chat.unreadCount > 0 ? theme.colorScheme.primary : Colors.grey.shade600),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat.timestamp, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat.unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatId: chat.id,
                    otherUser: chat.otherUser,
                    isCurrentUserRoot: widget.isRootUser, // Pass current user's role
                    isOtherUserRoot: false, // Assume other user is not root for this demo
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement start new chat (e.g., navigate to a user list screen)
        },
        label: const Text('New Chat'),
        icon: const Icon(Icons.add_comment_rounded),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
    );
  }
}