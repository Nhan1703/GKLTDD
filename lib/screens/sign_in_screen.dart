import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/fellow4u_sql_api.dart';
import '../app_theme.dart';
import '../core/session/user_session.dart';
import '../widgets/auth_header_painter.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController(text: 'yoojin@gmail.com');
  final _password = TextEditingController(text: 'password123');
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await Fellow4uSqlApi.login(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/explore');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 140,
            width: double.infinity,
            child: Stack(
              children: [
                CustomPaint(
                  painter: AuthHeaderPainter(),
                  size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).padding.top + 140),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 18,
                  right: 24,
                  child: Image.asset('assets/images/plane.png', width: 72),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 74,
                  right: 44,
                  child: Image.asset('assets/images/cloud.png', width: 88),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: FellowLogoWidget(size: 48),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ListenableBuilder(
                    listenable: UserSession.instance,
                    builder: (context, _) {
                      final name = UserSession.instance.displayName;
                      final subtitle = name == 'Guest'
                          ? 'Welcome back'
                          : 'Welcome back, $name';
                      return Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.authHeaderTeal,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _UnderlineField(
                    label: 'Email or Username',
                    controller: _email,
                  ),
                  const SizedBox(height: 20),
                  _UnderlineField(
                    label: 'Password',
                    controller: _password,
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/forgot_password');
                      },
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLightGray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signIn,
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
                          : const Text('SIGN IN'),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.dividerGray)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or sign in with',
                          style: TextStyle(fontSize: 13, color: AppTheme.textLightGray),
                        ),
                      ),
                      Expanded(child: Divider(color: AppTheme.dividerGray)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        color: const Color(0xFF1877F2),
                        child: const Text('f', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      _SocialButton(
                        color: const Color(0xFFFFE812),
                        child: Text('TALK', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      _SocialButton(
                        color: const Color(0xFF00B900),
                        child: Text('LINE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: AppTheme.textGray),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed('/sign_up');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.authHeaderTeal,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
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
          ),
        ],
      ),
    );
  }
}

class _UnderlineField extends StatelessWidget {
  const _UnderlineField({
    this.label = '',
    this.controller,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: null,
            hintStyle: TextStyle(color: AppTheme.textLightGray, fontSize: 15),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.dividerGray),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.dividerGray),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.authHeaderTeal, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          ),
          style: const TextStyle(fontSize: 15, color: AppTheme.textDark),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
