import 'dart:async';

import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../chat_inbox_store.dart';
import 'chat_add_friends_screen.dart';
import 'guide_page_screen.dart';

const Color _outChatBubbleLavender = Color(0xFFEDE7F6);

/// Tin nhắn đơn; tin nhận có [senderName] / [senderAvatar] (null nếu gửi đi).
class _BubbleMsg {
  const _BubbleMsg({
    required this.incoming,
    required this.text,
    required this.time,
    this.dateStrip,
    this.senderName,
    this.senderAvatar,
  });

  final bool incoming;
  final String text;
  final String time;
  final String? dateStrip;
  final String? senderName;
  final String? senderAvatar;
}

/// Chi tiết hội thoại + composer + voice (Figma: Chat-Detail / group / voice).
///
/// - Chat 1-1: chỉ truyền [title] + [avatarAsset], [initialGroupMembers] để null.
/// - **Nhóm mới** (tách khỏi chat cũ): truyền [initialGroupMembers] (≥1 người); lịch sử chỉ là intro nhóm.
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.title,
    required this.avatarAsset,
    this.initialGroupMembers,
  });

  final String title;
  final String avatarAsset;

  /// Khác null ⇒ đang mở luồng **nhóm mới**, không dùng lịch sử 1-1 cũ.
  final List<ChatFriendPick>? initialGroupMembers;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late List<ChatFriendPick> _roster;
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  Timer? _voiceTimer;

  bool _voiceMode = false;
  int _recordSecs = 0;

  late List<_BubbleMsg> _messages;

  bool get _isNewGroupThread =>
      widget.initialGroupMembers != null && widget.initialGroupMembers!.isNotEmpty;

  bool get _startedAsOneOnOne => !_isNewGroupThread;

  @override
  void initState() {
    super.initState();
    if (_isNewGroupThread) {
      _roster = List<ChatFriendPick>.from(widget.initialGroupMembers!);
      _messages = _seedNewGroupThread();
    } else {
      _roster = [
        ChatFriendPick(name: widget.title, avatarAsset: widget.avatarAsset),
      ];
      _messages = _seedMessages();
    }
  }

  /// Tin mở đầu cho nhóm vừa tạo (không kế thừa tin nhắn chat riêng cũ).
  List<_BubbleMsg> _seedNewGroupThread() {
    final firstNames = _roster.map((e) => e.name.split(' ').first).join(', ');
    return [
      _BubbleMsg(
        incoming: true,
        senderName: 'Fellow4U',
        senderAvatar: 'assets/images/app_icon.png',
        text: 'Bạn đã tạo nhóm mới với $firstNames. Đây là cuộc trò chuyện riêng của nhóm.',
        time: 'Vừa xong',
      ),
    ];
  }

  List<_BubbleMsg> _seedMessages() {
    if (widget.title == 'Emmy') {
      return [
        _BubbleMsg(
          incoming: true,
          senderName: 'Emmy',
          senderAvatar: widget.avatarAsset,
          text: 'hi, this is Emmy',
          time: '10:30 AM',
          dateStrip: 'Jan 28, 2020',
        ),
        const _BubbleMsg(
          incoming: true,
          senderName: 'Emmy',
          senderAvatar: 'assets/images/guide_emmy.png',
          text: 'It is a long established fact that a reader will be distracted by the',
          time: '10:30 AM',
        ),
        const _BubbleMsg(
          incoming: false,
          text: "as opposed to using 'Content here",
          time: '10:31 AM',
        ),
        const _BubbleMsg(
          incoming: false,
          text: 'There are many variations of passages',
          time: '10:31 AM',
        ),
      ];
    }
    return [
      _BubbleMsg(
        incoming: true,
        senderName: widget.title,
        senderAvatar: widget.avatarAsset,
        text: 'Hi! Looking forward to our trip.',
        time: '9:12 AM',
        dateStrip: 'Jan 28, 2020',
      ),
      _BubbleMsg(
        incoming: false,
        text: 'Great, same here.',
        time: '9:14 AM',
      ),
      _BubbleMsg(
        incoming: true,
        senderName: widget.title,
        senderAvatar: widget.avatarAsset,
        text: 'See you at the meeting point.',
        time: '9:15 AM',
      ),
    ];
  }

  @override
  void dispose() {
    _voiceTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String get _headerTitle {
    if (_roster.length <= 1) return widget.title;
    if (_roster.length <= 3) {
      return _roster.map((e) => e.name.split(' ').first).join(', ');
    }
    return '${_roster.length} friends';
  }

  void _openGuideProfile(ChatFriendPick pick) {
    final loc = switch (pick.name) {
      'Emmy' => 'Hanoi, Vietnam',
      'Khai Ho' => 'Ho Chi Minh, Vietnam',
      _ => 'Danang, Vietnam',
    };
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => GuidePageScreen(
          name: pick.name,
          location: loc,
          stars: 5,
          reviews: '120 Reviews',
          avatarAsset: pick.avatarAsset,
          headerAsset: 'assets/images/journey_danang.png',
        ),
      ),
    );
  }

  void _onHeaderAvatarsTap() {
    if (_roster.length == 1) {
      _openGuideProfile(_roster.first);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ),
              for (final p in _roster)
                ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage(p.avatarAsset)),
                  title: Text(p.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openGuideProfile(p);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// Đảm bảo người trong chat 1-1 vẫn nằm trong nhóm nếu user quên chọn lại.
  List<ChatFriendPick> _ensureOriginalPeerInPicks(List<ChatFriendPick> picked) {
    if (!_startedAsOneOnOne || picked.length <= 1) return picked;
    final self = ChatFriendPick(name: widget.title, avatarAsset: widget.avatarAsset);
    if (picked.any((p) => p.name == self.name)) return picked;
    return [self, ...picked];
  }

  Future<void> _openAddFriends() async {
    final picked = await Navigator.of(context).push<List<ChatFriendPick>>(
      MaterialPageRoute(
        builder: (_) => ChatAddFriendsScreen(
          initialSelected: _roster,
        ),
      ),
    );
    if (!mounted || picked == null || picked.isEmpty) return;

    final merged = _ensureOriginalPeerInPicks(List<ChatFriendPick>.from(picked));

    /// Từ 2 người trở lên ⇒ **luôn** mở màn nhóm mới (route mới), không gộp vào chat đang xem.
    if (merged.length > 1) {
      if (!mounted) return;
      ChatInboxStore.instance.registerNewGroup(merged);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ChatDetailScreen(
            title: merged.first.name,
            avatarAsset: merged.first.avatarAsset,
            initialGroupMembers: merged,
          ),
        ),
      );
      return;
    }

    setState(() => _roster = merged);
  }

  bool _showIncomingHeader(int i) {
    final m = _messages[i];
    if (!m.incoming) return false;
    if (i == 0) return true;
    final p = _messages[i - 1];
    if (!p.incoming) return true;
    return p.senderName != m.senderName;
  }

  bool _showOutgoingTime(int i) {
    final m = _messages[i];
    if (m.incoming) return false;
    if (i == 0) return true;
    return _messages[i - 1].incoming;
  }

  void _sendText() {
    final t = _input.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _messages = [
        ..._messages,
        _BubbleMsg(
          incoming: false,
          text: t,
          time: TimeOfDay.now().format(context),
        ),
      ];
      _input.clear();
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
      }
    });
  }

  void _startVoice() {
    _voiceTimer?.cancel();
    setState(() {
      _voiceMode = true;
      _recordSecs = 0;
    });
    _voiceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _recordSecs++);
    });
  }

  void _cancelVoice() {
    _voiceTimer?.cancel();
    setState(() {
      _voiceMode = false;
      _recordSecs = 0;
    });
  }

  void _sendVoice() {
    _voiceTimer?.cancel();
    final label = 'Voice message (${_formatDur(_recordSecs)})';
    setState(() {
      _messages = [
        ..._messages,
        _BubbleMsg(incoming: false, text: label, time: TimeOfDay.now().format(context)),
      ];
      _voiceMode = false;
      _recordSecs = 0;
    });
    _scrollToEnd();
  }

  String _formatDur(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _onHeaderAvatarsTap,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: _HeaderAvatars(roster: _roster),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                _headerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppTheme.authHeaderTeal),
            onPressed: _openAddFriends,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (m.dateStrip != null) _DatePill(label: m.dateStrip!),
                      if (m.incoming)
                        _IncomingBlock(
                          msg: m,
                          showHeader: _showIncomingHeader(i),
                          onAvatarTap: () => _openGuideProfile(
                            ChatFriendPick(name: m.senderName!, avatarAsset: m.senderAvatar!),
                          ),
                        )
                      else
                        _OutgoingBlock(
                          msg: m,
                          showTime: _showOutgoingTime(i),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: MediaQuery.paddingOf(context).bottom + 8),
            child: _voiceMode ? _buildVoiceBar() : _buildComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.mic_none, color: AppTheme.textGray),
          onPressed: _startVoice,
        ),
        IconButton(
          icon: Icon(Icons.image_outlined, color: AppTheme.textGray),
          onPressed: () {},
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: _input,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type message',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendText(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Material(
          color: AppTheme.authHeaderTeal,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _sendText,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceBar() {
    final progress = (_recordSecs / 60).clamp(0.0, 1.0);
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.close, color: AppTheme.textGray),
          onPressed: _cancelVoice,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatDur(_recordSecs), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        color: AppTheme.authHeaderTeal,
                        backgroundColor: AppTheme.authHeaderTeal.withValues(alpha: 0.2),
                      ),
                    ),
                    Material(
                      color: AppTheme.authHeaderTeal,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.mic, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Material(
          color: AppTheme.authHeaderTeal,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _sendVoice,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: AppTheme.textGray, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatars extends StatelessWidget {
  const _HeaderAvatars({required this.roster});

  final List<ChatFriendPick> roster;

  @override
  Widget build(BuildContext context) {
    if (roster.length == 1) {
      return CircleAvatar(radius: 18, backgroundImage: AssetImage(roster.first.avatarAsset));
    }
    final n = roster.length > 4 ? 4 : roster.length;
    return SizedBox(
      width: 18.0 * (n - 1) + 36,
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < n; i++)
            Positioned(
              left: i * 14.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(roster[i].avatarAsset),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IncomingBlock extends StatelessWidget {
  const _IncomingBlock({
    required this.msg,
    required this.showHeader,
    required this.onAvatarTap,
  });

  final _BubbleMsg msg;
  final bool showHeader;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    const double gutter = 40;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: gutter,
          child: showHeader
              ? InkWell(
                  onTap: onAvatarTap,
                  customBorder: const CircleBorder(),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(msg.senderAvatar!),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader) ...[
                Row(
                  children: [
                    Text(
                      msg.senderName!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      msg.time,
                      style: TextStyle(fontSize: 11, color: AppTheme.textLightGray),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
                  child: _TealBubble(text: msg.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TealBubble extends StatelessWidget {
  const _TealBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.authHeaderTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.35),
      ),
    );
  }
}

class _OutgoingBlock extends StatelessWidget {
  const _OutgoingBlock({
    required this.msg,
    required this.showTime,
  });

  final _BubbleMsg msg;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showTime)
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 4),
            child: Text(
              msg.time,
              style: TextStyle(fontSize: 11, color: AppTheme.textLightGray),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _outChatBubbleLavender,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(color: Color(0xFF333333), fontSize: 14, height: 1.35),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
