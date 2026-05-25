import 'package:flutter/material.dart';

import '../core/session/user_session.dart';

/// Ảnh đại diện: chỉ khi [avatar_url] trống/null → icon người trắng (Facebook).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.radius = 32,
    this.backgroundColor,
  });

  final double radius;
  final Color? backgroundColor;

  /// Có URL ảnh trong DB (http hoặc assets/...) = đã có ảnh đại diện.
  static bool hasAvatar(Map<String, dynamic>? user) {
    final url = _avatarUrl(user);
    return url.isNotEmpty;
  }

  static String _avatarUrl(Map<String, dynamic>? user) {
    return '${user?['avatarUrl'] ?? user?['avatar_url'] ?? ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession.instance.user;
    final url = _avatarUrl(user);

    if (!hasAvatar(user)) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? const Color(0xFFBDBDBD),
        child: Icon(Icons.person, size: radius * 1.1, color: Colors.white),
      );
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFE8E8E8),
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE8E8E8),
      backgroundImage: AssetImage(url),
    );
  }
}
