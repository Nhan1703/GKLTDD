import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import '../core/session/user_session.dart';
import '../widgets/user_avatar.dart';
import 'profile_change_password_screen.dart';
import 'profile_edit_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _notificationsOn = true;
  bool _loadingProfile = false;

  @override
  void initState() {
    super.initState();
    UserSession.instance.addListener(_onSessionChanged);
    _loadProfile();
  }

  @override
  void dispose() {
    UserSession.instance.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadProfile() async {
    setState(() => _loadingProfile = true);
    try {
      await Fellow4uSqlApi.getProfile();
    } catch (_) {}
    if (mounted) setState(() => _loadingProfile = false);
  }

  String _roleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'guide':
        return 'Guide';
      case 'traveler':
        return 'Traveler';
      default:
        return role.isEmpty ? 'Member' : role;
    }
  }

  void _openPage(String title) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => _SettingsDetailPage(title: title)),
    );
  }

  Future<void> _signOut() async {
    Fellow4uSqlApi.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/sign_in', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    final name = session.displayName;
    final role = _roleLabel(session.role);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.authHeaderTeal,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                UserAvatar(radius: 32, backgroundColor: const Color(0xFF4DB6AC)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _loadingProfile ? '...' : name,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      if (session.email.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          session.email,
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    await Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(builder: (_) => const ProfileEditScreen()),
                    );
                    await _loadProfile();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  child: const Text('EDIT PROFILE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w500)),
            trailing: Switch(
              value: _notificationsOn,
              onChanged: (v) => setState(() => _notificationsOn = v),
            ),
          ),
          _tile(Icons.language, 'Languages', () => _openPage('Languages')),
          _tile(Icons.payment_outlined, 'Payment', () => _openPage('Payment')),
          _tile(Icons.lock_outline, 'Change Password', () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const ProfileChangePasswordScreen()),
            );
          }),
          _tile(Icons.shield_outlined, 'Privacy & Policies', () => _openPage('Privacy & Policies')),
          _tile(Icons.feedback_outlined, 'Feedback', () => _openPage('Feedback')),
          _tile(Icons.menu_book_outlined, 'Usage', () => _openPage('Usage')),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: _signOut,
              child: Text(
                'Sign out',
                style: TextStyle(color: AppTheme.textGray, fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.textDark),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textLightGray),
      onTap: onTap,
    );
  }
}

class _SettingsDetailPage extends StatelessWidget {
  const _SettingsDetailPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '$title settings — coming soon.',
          style: TextStyle(fontSize: 16, color: AppTheme.textGray, height: 1.5),
        ),
      ),
    );
  }
}
