import 'package:flutter/foundation.dart';

/// Người dùng đang đăng nhập (từ API login / profile).
class UserSession extends ChangeNotifier {
  UserSession._();
  static final UserSession instance = UserSession._();

  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user == null ? null : Map<String, dynamic>.from(_user!);

  bool get isLoggedIn => _user != null;

  String get displayName {
    final u = _user;
    if (u == null) return 'Guest';
    final first = _str(u['firstName'] ?? u['first_name']);
    final last = _str(u['lastName'] ?? u['last_name']);
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    return _str(u['username']).isNotEmpty ? _str(u['username']) : _str(u['email']);
  }

  String get email => _str(_user?['email']);

  String get username => _str(_user?['username']);

  String get role => _str(_user?['role']);

  /// URL ảnh đại diện từ API (rỗng = chưa có → dùng placeholder).
  String get avatarUrl => _str(_user?['avatarUrl'] ?? _user?['avatar_url']);

  bool get hasAvatar => avatarUrl.isNotEmpty;

  void setUser(Map<String, dynamic>? value) {
    _user = value == null ? null : Map<String, dynamic>.from(value);
    notifyListeners();
  }

  void setFromAuthResponse(Map<String, dynamic> response) {
    final raw = response['user'];
    if (raw is Map) {
      setUser(Map<String, dynamic>.from(raw));
    }
  }

  void clear() {
    setUser(null);
  }

  static String _str(Object? v) => v == null ? '' : v.toString();
}
