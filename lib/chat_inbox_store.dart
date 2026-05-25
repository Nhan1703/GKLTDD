import 'package:flutter/foundation.dart';

import 'screens/chat_add_friends_screen.dart';

/// Nhóm do user vừa tạo (hiển thị thêm ở đầu danh sách Chat).
class CreatedGroupChat {
  const CreatedGroupChat({
    required this.id,
    required this.members,
    required this.createdAt,
  });

  final String id;
  final List<ChatFriendPick> members;
  final DateTime createdAt;

  String get listTitle {
    if (members.length <= 3) {
      return members.map((e) => e.name.split(' ').first).join(', ');
    }
    return 'Nhóm (${members.length})';
  }
}

/// In-memory: thêm nhóm mới → [ChatListScreen] lắng nghe và hiển thị.
class ChatInboxStore {
  ChatInboxStore._();
  static final ChatInboxStore instance = ChatInboxStore._();

  final ValueNotifier<List<CreatedGroupChat>> createdGroups = ValueNotifier<List<CreatedGroupChat>>([]);

  void registerNewGroup(List<ChatFriendPick> members) {
    if (members.length < 2) return;
    final row = CreatedGroupChat(
      id: 'g_${DateTime.now().microsecondsSinceEpoch}',
      members: List<ChatFriendPick>.from(members),
      createdAt: DateTime.now(),
    );
    createdGroups.value = [row, ...createdGroups.value];
  }
}
