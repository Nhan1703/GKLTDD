import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import '../core/session/user_session.dart';
import 'profile_change_password_screen.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _first;
  late final TextEditingController _last;
  late final TextEditingController _pass;

  @override
  void initState() {
    super.initState();
    final u = UserSession.instance.user;
    _first = TextEditingController(text: '${u?['firstName'] ?? ''}');
    _last = TextEditingController(text: '${u?['lastName'] ?? ''}');
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await Fellow4uSqlApi.updateProfile({
                  'firstName': _first.text.trim(),
                  'lastName': _last.text.trim(),
                });
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
                return;
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved.')));
            },
            child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.authHeaderTeal)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(radius: 48, backgroundImage: AssetImage('assets/images/guide_emmy.png')),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: AppTheme.authHeaderTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _underlineField(label: 'First Name', controller: _first, obscure: false),
          const SizedBox(height: 18),
          _underlineField(label: 'Last Name', controller: _last, obscure: false),
          const SizedBox(height: 18),
          _underlineField(label: 'Password', controller: _pass, obscure: true),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ProfileChangePasswordScreen()));
              },
              child: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _underlineField({required String label, required TextEditingController controller, required bool obscure}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.dividerGray)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.dividerGray)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.authHeaderTeal)),
          ),
        ),
      ],
    );
  }
}
