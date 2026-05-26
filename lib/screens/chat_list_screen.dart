import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../chat_inbox_store.dart';
import '../core/session/user_session.dart';
import 'chat_add_friends_screen.dart';
import 'chat_detail_screen.dart';

class _ChatPreview {
  const _ChatPreview({
    required this.name,
    required this.preview,
    required this.time,
    required this.avatarAsset,
    this.unread = 0,
    this.groupMembers,
    this.groupId,
  });

  final String name;
  final String preview;
  /// Hiển thị bên phải; nếu [unread] > 0 thì ưu tiên badge thay vì giờ (theo mockup Emmy).
  final String time;
  final String avatarAsset;
  final int unread;
  /// Khác null ⇒ hàng nhóm — mở [ChatDetailScreen] với [initialGroupMembers].
  final List<ChatFriendPick>? groupMembers;
  final String? groupId;

  bool get isGroup => groupId != null;
}

/// Danh sách hội thoại (Figma: Chat — màn list).
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _search = TextEditingController();
  String _q = '';

  static const List<_ChatPreview> _staticChats = [
    _ChatPreview(
      name: 'Tuan Tran',
      preview: "It's a beautiful place",
      time: '10:30 AM',
      avatarAsset: 'assets/images/guide_tuan_tran.png',
    ),
    _ChatPreview(
      name: 'Emmy',
      preview: 'We can start at 8am',
      time: '',
      avatarAsset: 'assets/images/guide_emmy.png',
      unread: 2,
    ),
    _ChatPreview(
      name: 'Khai Ho',
      preview: 'See you tomorrow',
      time: '11:30 AM',
      avatarAsset: 'assets/images/exp_grid_4.png',
    ),
  ];

  List<_ChatPreview> _rowsFromStore(List<CreatedGroupChat> groups) {
    final rows = <_ChatPreview>[
      for (final g in groups)
        if (g.isVisibleToUser(ChatInboxStore.instance.currentUserKey))
          _ChatPreview(
            name: g.listTitle,
            preview: 'Nhóm mới — bắt đầu trò chuyện',
            time: 'Vừa xong',
            avatarAsset: g.members.first.avatarAsset,
            groupMembers: g.members,
            groupId: g.id,
          ),
    ];
    if (UserSession.instance.isLoggedIn) {
      rows.addAll(_staticChats);
    }
    return rows;
  }

  Future<bool> _confirmDeleteGroup(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa nhóm chat?'),
        content: const Text('Nhóm sẽ biến mất khỏi danh sách của bạn.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return ok == true;
  }

  List<_ChatPreview> _filteredFrom(List<_ChatPreview> all) {
    if (_q.isEmpty) return all;
    return all
        .where(
          (c) => c.name.toLowerCase().contains(_q) || c.preview.toLowerCase().contains(_q),
        )
        .toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 138,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/explore_header_danang.png', fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search, size: 20, color: AppTheme.textLightGray),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: (v) => setState(() => _q = v.trim().toLowerCase()),
                    decoration: const InputDecoration(
                      hintText: 'Search Chat',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Listenable.merge([
              ChatInboxStore.instance.createdGroups,
              UserSession.instance,
            ]),
            builder: (context, _) {
              final combined = _rowsFromStore(ChatInboxStore.instance.createdGroups.value);
              final filtered = _filteredFrom(combined);
              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    UserSession.instance.isLoggedIn
                        ? 'Chưa có hội thoại'
                        : 'Đăng nhập để xem chat',
                    style: TextStyle(color: AppTheme.textLightGray),
                  ),
                );
              }
              return ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (context, i) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),
                itemBuilder: (context, i) {
                  final c = filtered[i];
                  final tile = _ChatListTile(
                    preview: c,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => c.isGroup
                              ? ChatDetailScreen(
                                  title: c.groupMembers!.first.name,
                                  avatarAsset: c.groupMembers!.first.avatarAsset,
                                  initialGroupMembers: c.groupMembers,
                                  groupChatId: c.groupId,
                                )
                              : ChatDetailScreen(
                                  title: c.name,
                                  avatarAsset: c.avatarAsset,
                                ),
                        ),
                      );
                    },
                  );
                  if (!c.isGroup || c.groupId == null) return tile;
                  return Dismissible(
                    key: ValueKey('chat_${c.groupId}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    confirmDismiss: (_) => _confirmDeleteGroup(context),
                    onDismissed: (_) => ChatInboxStore.instance.deleteGroup(c.groupId!),
                    child: tile,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({required this.preview, required this.onTap});

  final _ChatPreview preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = preview;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage(c.avatarAsset),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (c.isGroup && (c.groupMembers?.length ?? 0) > 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(Icons.groups_2_outlined, size: 16, color: AppTheme.authHeaderTeal),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: AppTheme.textLightGray),
                  ),
                ],
              ),
            ),
            if (c.unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4B4B),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${c.unread}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              )
            else
              Text(
                c.time,
                style: TextStyle(fontSize: 12, color: AppTheme.textLightGray),
              ),
          ],
        ),
      ),
    );
  }
}
