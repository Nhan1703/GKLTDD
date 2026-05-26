import 'package:flutter/foundation.dart';

import 'core/session/user_session.dart';
import 'screens/chat_add_friends_screen.dart';

/// Nhóm do user tạo — chỉ thành viên trong [members] mới thấy trên danh sách Chat.
class CreatedGroupChat {
  const CreatedGroupChat({
    required this.id,
    required this.members,
    required this.createdAt,
    required this.creatorKey,
  });

  final String id;
  final List<ChatFriendPick> members;
  final DateTime createdAt;
  final String creatorKey;

  String get listTitle {
    if (members.length <= 3) {
      return members.map((e) => e.name.split(' ').first).join(', ');
    }
    return 'Nhóm (${members.length})';
  }

  bool isVisibleToUser(String userKey) {
    if (userKey.isEmpty) return false;
    return members.any((m) => m.isSameParticipant(userKey));
  }
}

/// In-memory: nhóm chat + lọc theo user đăng nhập.
class ChatInboxStore {
  ChatInboxStore._();
  static final ChatInboxStore instance = ChatInboxStore._();

  final ValueNotifier<List<CreatedGroupChat>> createdGroups = ValueNotifier<List<CreatedGroupChat>>([]);

  String get currentUserKey {
    final session = UserSession.instance;
    if (session.email.isNotEmpty) return session.email.trim().toLowerCase();
    if (session.username.isNotEmpty) return session.username.trim().toLowerCase();
    return session.displayName.trim().toLowerCase();
  }

  ChatFriendPick currentUserPick() {
    final session = UserSession.instance;
    final avatar = session.hasAvatar
        ? session.avatarUrl
        : 'assets/images/app_icon.png';
    return ChatFriendPick(
      name: session.displayName,
      avatarAsset: avatar.startsWith('assets/') ? avatar : 'assets/images/app_icon.png',
      userKey: currentUserKey,
    );
  }

  List<CreatedGroupChat> groupsForCurrentUser() {
    final key = currentUserKey;
    if (key.isEmpty) return const [];
    return createdGroups.value.where((g) => g.isVisibleToUser(key)).toList();
  }

  void registerNewGroup(List<ChatFriendPick> members) {
    final me = currentUserPick();
    final meKey = currentUserKey;
    if (meKey.isEmpty) return;

    final all = List<ChatFriendPick>.from(members);
    if (!all.any((m) => m.isSameParticipant(meKey))) {
      all.insert(0, me);
    }
    if (all.length < 2) return;

    final row = CreatedGroupChat(
      id: 'g_${DateTime.now().microsecondsSinceEpoch}',
      members: all,
      createdAt: DateTime.now(),
      creatorKey: meKey,
    );
    createdGroups.value = [row, ...createdGroups.value];
  }

  void deleteGroup(String id) {
    createdGroups.value = createdGroups.value.where((g) => g.id != id).toList();
  }

  CreatedGroupChat? findGroupById(String? id) {
    if (id == null || id.isEmpty) return null;
    for (final g in createdGroups.value) {
      if (g.id == id) return g;
    }
    return null;
  }
}
