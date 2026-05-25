import 'package:flutter/material.dart';

import '../app_theme.dart';

class ChatFriendPick {
  const ChatFriendPick({required this.name, required this.avatarAsset});

  final String name;
  final String avatarAsset;
}

class _FriendRow {
  const _FriendRow({required this.name, required this.avatarAsset});

  final String name;
  final String avatarAsset;
}

/// Figma: Chat-Add Friends.
class ChatAddFriendsScreen extends StatefulWidget {
  const ChatAddFriendsScreen({super.key, this.initialSelected = const []});

  final List<ChatFriendPick> initialSelected;

  @override
  State<ChatAddFriendsScreen> createState() => _ChatAddFriendsScreenState();
}

class _ChatAddFriendsScreenState extends State<ChatAddFriendsScreen> {
  final TextEditingController _search = TextEditingController();
  String _q = '';

  static const List<_FriendRow> _all = [
    _FriendRow(name: 'Pena Valdez', avatarAsset: 'assets/images/exp_grid_1.png'),
    _FriendRow(name: 'Gil Hajoon', avatarAsset: 'assets/images/exp_grid_2.png'),
    _FriendRow(name: 'Fitzgerald', avatarAsset: 'assets/images/exp_grid_3.png'),
    _FriendRow(name: 'KerriBarber', avatarAsset: 'assets/images/exp_grid_5.png'),
    _FriendRow(name: 'WhiteCastaneda', avatarAsset: 'assets/images/exp_grid_6.png'),
    _FriendRow(name: 'Emmy', avatarAsset: 'assets/images/guide_emmy.png'),
    _FriendRow(name: 'Tuan Tran', avatarAsset: 'assets/images/guide_tuan_tran.png'),
  ];

  late Set<String> _selectedNames;

  @override
  void initState() {
    super.initState();
    _selectedNames = {for (final p in widget.initialSelected) p.name};
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_FriendRow> get _filtered {
    final list = _all.where((f) => f.name.toLowerCase().contains(_q)).toList();
    return list;
  }

  List<ChatFriendPick> get _selectedOrdered {
    final out = <ChatFriendPick>[];
    for (final f in _all) {
      if (_selectedNames.contains(f.name)) {
        out.add(ChatFriendPick(name: f.name, avatarAsset: f.avatarAsset));
      }
    }
    return out;
  }

  void _toggle(String name) {
    setState(() {
      if (_selectedNames.contains(name)) {
        _selectedNames.remove(name);
      } else {
        _selectedNames.add(name);
      }
    });
  }

  void _remove(String name) => setState(() => _selectedNames.remove(name));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Friends', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedOrdered),
            child: Text('DONE', style: TextStyle(color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                        hintText: 'Search Friend',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedOrdered.isNotEmpty)
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _selectedOrdered.length,
                separatorBuilder: (context, i) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final p = _selectedOrdered[i];
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(radius: 24, backgroundImage: AssetImage(p.avatarAsset)),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 56,
                            child: Text(
                              p.name.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF666666)),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: InkWell(
                          onTap: () => _remove(p.name),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(color: Color(0xFF9E9E9E), shape: BoxShape.circle),
                            child: const Icon(Icons.close, size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (_selectedOrdered.isNotEmpty)
            Divider(height: 1, thickness: 1, color: Colors.grey.withValues(alpha: 0.18)),
          Expanded(
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder: (context, i) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.12)),
              itemBuilder: (context, i) {
                final f = _filtered[i];
                final sel = _selectedNames.contains(f.name);
                return InkWell(
                  onTap: () => _toggle(f.name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 22, backgroundImage: AssetImage(f.avatarAsset)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(f.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: sel ? AppTheme.authHeaderTeal : Colors.transparent,
                            border: Border.all(color: sel ? AppTheme.authHeaderTeal : const Color(0xFFBDBDBD), width: 2),
                          ),
                          child: sel ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
