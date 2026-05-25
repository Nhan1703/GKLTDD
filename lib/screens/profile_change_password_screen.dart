import 'package:flutter/material.dart';

import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';

class ProfileChangePasswordScreen extends StatefulWidget {
  const ProfileChangePasswordScreen({super.key});

  @override
  State<ProfileChangePasswordScreen> createState() => _ProfileChangePasswordScreenState();
}

class _ProfileChangePasswordScreenState extends State<ProfileChangePasswordScreen> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _retype = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    if (_new.text != _retype.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await Fellow4uSqlApi.changePassword(
        currentPassword: _current.text,
        newPassword: _new.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _retype.dispose();
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
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _saving ? '...' : 'SAVE',
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.authHeaderTeal),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          _field('Current Password', _current),
          const SizedBox(height: 20),
          _field('New Password', _new),
          const SizedBox(height: 20),
          _field('Retype New Password', _retype),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textLightGray, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          obscureText: true,
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
