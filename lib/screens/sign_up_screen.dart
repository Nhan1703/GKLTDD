import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import '../widgets/auth_header_painter.dart';

/// Đăng ký sau 3 trang onboarding — lưu tài khoản vào SQL Server qua API.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isTraveler = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _country = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _country.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await Fellow4uSqlApi.register(
        email: _email.text.trim(),
        password: _password.text,
        username: _username.text.trim(),
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        country: _country.text.trim().isEmpty ? null : _country.text.trim(),
        role: _isTraveler ? 'traveler' : 'guide',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
          backgroundColor: AppTheme.authHeaderTeal,
        ),
      );
      Navigator.of(context).pushReplacementNamed('/sign_in');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed('/sign_in');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 120,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  painter: AuthHeaderPainter(),
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).padding.top + 120),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 14,
                  right: 20,
                  child: Image.asset('assets/images/plane.png', width: 64),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      children: [
                        const FellowLogoWidget(size: 44),
                        const Spacer(),
                        TextButton(
                          onPressed: _goLogin,
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign up with SQL Server API',
                      style: TextStyle(fontSize: 14, color: AppTheme.authHeaderTeal, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleTab(
                            label: 'Traveler',
                            icon: Icons.flight_takeoff,
                            selected: _isTraveler,
                            onTap: () => setState(() => _isTraveler = true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleTab(
                            label: 'Guide',
                            icon: Icons.explore_outlined,
                            selected: !_isTraveler,
                            onTap: () => setState(() => _isTraveler = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _IconField(
                      label: 'First Name',
                      controller: _firstName,
                      icon: Icons.badge_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập họ' : null,
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Last Name',
                      controller: _lastName,
                      icon: Icons.badge_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập tên' : null,
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Country',
                      controller: _country,
                      icon: Icons.flag_outlined,
                      hint: 'Vietnam',
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Email',
                      controller: _email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Nhập email';
                        if (!v.contains('@')) return 'Email không hợp lệ';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Username',
                      controller: _username,
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.trim().length < 3) ? 'Tên đăng nhập tối thiểu 3 ký tự' : null,
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Password',
                      controller: _password,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) => (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                    ),
                    const SizedBox(height: 14),
                    _IconField(
                      label: 'Confirm Password',
                      controller: _confirmPassword,
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.authHeaderTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('CREATE ACCOUNT', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _goLogin,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, color: AppTheme.textGray),
                            children: [
                              const TextSpan(text: 'Đã có tài khoản? '),
                              TextSpan(
                                text: 'Đăng nhập',
                                style: TextStyle(
                                  color: AppTheme.authHeaderTeal,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  const _RoleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.authHeaderTeal.withValues(alpha: 0.12) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.authHeaderTeal : AppTheme.dividerGray,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? AppTheme.authHeaderTeal : AppTheme.textLightGray),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppTheme.authHeaderTeal : AppTheme.textGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconField extends StatelessWidget {
  const _IconField({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: AppTheme.textLightGray, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.authHeaderTeal, size: 22),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.dividerGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.authHeaderTeal, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
