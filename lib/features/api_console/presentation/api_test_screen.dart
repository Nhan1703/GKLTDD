import 'package:flutter/material.dart';

import '../../../core/di/api_module.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/http_data.dart';
import '../../../core/network/token_store.dart';
import '../../auth/domain/entities/login_result_entity.dart';
import '../../explore/domain/entities/post_entity.dart';
import '../../profile/domain/entities/user_entity.dart';

/// Màn kiểm thử gọi API thật (JSONPlaceholder + ReqRes): loading / lỗi / status.
class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _CallOutcome {
  _CallOutcome.ok({
    required this.statusCode,
    required this.message,
    required this.preview,
  }) : error = null;

  _CallOutcome.err(ApiException err, {this.statusCode})
      : error = err,
        message = err.message,
        preview = '';

  final int? statusCode;
  final String message;
  final String preview;
  final ApiException? error;

  bool get isError => error != null;
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final Map<String, _CallOutcome?> _last = <String, _CallOutcome?>{};
  final Set<String> _loading = <String>{};
  final TextEditingController _tokenCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController(text: 'Bret');
  final TextEditingController _titleCtrl = TextEditingController(text: 'Fellow4U test');
  final TextEditingController _bodyCtrl = TextEditingController(text: 'Hello from Dio');
  final TextEditingController _userIdCtrl = TextEditingController(text: '1');
  final TextEditingController _postIdCtrl = TextEditingController(text: '1');
  final TextEditingController _emailCtrl = TextEditingController(text: 'eve.holt@reqres.in');
  final TextEditingController _passwordCtrl = TextEditingController(text: 'cityslicka');

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _searchCtrl.dispose();
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _userIdCtrl.dispose();
    _postIdCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<_CallOutcome> _wrap<T>(Future<HttpData<T>> future) async {
    try {
      final HttpData<T> r = await future;
      return _CallOutcome.ok(
        statusCode: r.statusCode,
        message: r.serverMessage ?? r.reasonPhrase ?? 'OK',
        preview: r.rawBodyPreview ?? _describe(r.data),
      );
    } on ApiException catch (e) {
      return _CallOutcome.err(e, statusCode: e.statusCode);
    }
  }

  String _describe(Object? data) {
    if (data == null) return 'empty';
    if (data is List) return '${data.length} phần tử';
    if (data is Map) return 'map (${data.length} keys)';
    if (data is PostEntity) return 'Post #${data.id}: ${data.title}';
    if (data is UserEntity) return '${data.name} <${data.email}>';
    if (data is LoginResultEntity) return 'token length=${data.token.length}';
    final s = data.toString();
    return s.length > 160 ? '${s.substring(0, 160)}…' : s;
  }

  Future<void> _run(String id, Future<_CallOutcome> Function() job) async {
    setState(() {
      _loading.add(id);
    });
    final outcome = await job();
    if (!mounted) return;
    setState(() {
      _loading.remove(id);
      _last[id] = outcome;
    });
  }

  void _applyToken() {
    TokenStore.instance.setAccessToken(_tokenCtrl.text.trim().isEmpty ? null : _tokenCtrl.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật Bearer token (áp dụng cho JSONPlaceholder).')),
    );
  }

  ApiModule get m => ApiModule.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiểm tra API (Dio)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Các endpoint dưới đây gọi server công khai thật (không mock trong app). '
            'Bearer chỉ minh họa — JSONPlaceholder không kiểm tra token.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tokenCtrl,
            decoration: const InputDecoration(
              labelText: 'Bearer token (tùy chọn)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(onPressed: _applyToken, child: const Text('Lưu token')),
          ),
          const Divider(height: 32),
          _section('1 · Explore', 'GET posts', 'https://jsonplaceholder.typicode.com/posts'),
          _tile(
            id: 'explore',
            busy: _loading.contains('explore'),
            outcome: _last['explore'],
            onPressed: () => _run('explore', () => _wrap(m.explore.loadFeed())),
          ),
          _section('2 · Tour detail', 'GET posts/1', 'https://jsonplaceholder.typicode.com/posts/1'),
          _tile(
            id: 'tour_detail',
            busy: _loading.contains('tour_detail'),
            outcome: _last['tour_detail'],
            onPressed: () => _run('tour_detail', () => _wrap(m.tourDetail.loadPost(1))),
          ),
          _section('3 · My trips', 'GET albums', 'https://jsonplaceholder.typicode.com/albums'),
          _tile(
            id: 'my_trips',
            busy: _loading.contains('my_trips'),
            outcome: _last['my_trips'],
            onPressed: () => _run('my_trips', () => _wrap(m.myTrips.loadAlbums())),
          ),
          _section('4 · Trip detail', 'GET albums/1', 'https://jsonplaceholder.typicode.com/albums/1'),
          _tile(
            id: 'trip_detail',
            busy: _loading.contains('trip_detail'),
            outcome: _last['trip_detail'],
            onPressed: () => _run('trip_detail', () => _wrap(m.tripDetail.loadAlbum(1))),
          ),
          _section('5 · Chat', 'GET comments?postId=1', 'https://jsonplaceholder.typicode.com/comments?postId=1'),
          _tile(
            id: 'chat',
            busy: _loading.contains('chat'),
            outcome: _last['chat'],
            onPressed: () => _run('chat', () => _wrap(m.chatList.loadThread(postId: 1))),
          ),
          _section('6 · Notifications', 'GET todos', 'https://jsonplaceholder.typicode.com/todos'),
          _tile(
            id: 'notif',
            busy: _loading.contains('notif'),
            outcome: _last['notif'],
            onPressed: () => _run('notif', () => _wrap(m.notifications.loadTodos())),
          ),
          _section('7 · Profile', 'GET users/1', 'https://jsonplaceholder.typicode.com/users/1'),
          _tile(
            id: 'profile',
            busy: _loading.contains('profile'),
            outcome: _last['profile'],
            onPressed: () => _run('profile', () => _wrap(m.profile.loadUser(1))),
          ),
          _section('8 · Search', 'GET users + lọc client', 'https://jsonplaceholder.typicode.com/users'),
          TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              labelText: 'Chuỗi lọc (name/email/username)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          _tile(
            id: 'search',
            busy: _loading.contains('search'),
            outcome: _last['search'],
            onPressed: () => _run('search', () => _wrap(m.search.search(_searchCtrl.text))),
          ),
          _section('9 · Guides', 'GET photos?_limit=8', 'https://jsonplaceholder.typicode.com/photos?_limit=8'),
          _tile(
            id: 'guides',
            busy: _loading.contains('guides'),
            outcome: _last['guides'],
            onPressed: () => _run('guides', () => _wrap(m.guides.loadPhotos(limit: 8))),
          ),
          _section('10 · Sign in (ReqRes)', 'POST /api/login', 'https://reqres.in/api/login'),
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 8),
          _tile(
            id: 'auth',
            busy: _loading.contains('auth'),
            outcome: _last['auth'],
            onPressed: () => _run(
              'auth',
              () => _wrap(
                m.auth.signIn(email: _emailCtrl.text.trim(), password: _passwordCtrl.text),
              ),
            ),
          ),
          const Divider(height: 32),
          const Text('CRUD posts (JSONPlaceholder)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'title')),
          TextField(controller: _bodyCtrl, decoration: const InputDecoration(labelText: 'body')),
          TextField(
            controller: _userIdCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'userId'),
          ),
          TextField(
            controller: _postIdCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'id cho PUT/PATCH/DELETE'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: _loading.contains('c') ? null : () => _run('c', _create),
                child: const Text('POST create'),
              ),
              FilledButton.tonal(
                onPressed: _loading.contains('u') ? null : () => _run('u', _put),
                child: const Text('PUT replace'),
              ),
              FilledButton.tonal(
                onPressed: _loading.contains('p') ? null : () => _run('p', _patch),
                child: const Text('PATCH'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                onPressed: _loading.contains('d') ? null : () => _run('d', _delete),
                child: const Text('DELETE'),
              ),
            ],
          ),
          _tile(id: 'c', busy: _loading.contains('c'), outcome: _last['c'], onPressed: null),
          _tile(id: 'u', busy: _loading.contains('u'), outcome: _last['u'], onPressed: null),
          _tile(id: 'p', busy: _loading.contains('p'), outcome: _last['p'], onPressed: null),
          _tile(id: 'd', busy: _loading.contains('d'), outcome: _last['d'], onPressed: null),
          const Divider(height: 24),
          const Text('Lỗi mẫu (404)', style: TextStyle(fontWeight: FontWeight.bold)),
          _tile(
            id: 'err404',
            busy: _loading.contains('err404'),
            outcome: _last['err404'],
            onPressed: () => _run('err404', () => _wrap(m.tourDetail.loadPost(999999))),
          ),
        ],
      ),
    );
  }

  Future<_CallOutcome> _create() => _wrap(
        m.postWrite.create(
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          userId: int.tryParse(_userIdCtrl.text) ?? 1,
        ),
      );

  Future<_CallOutcome> _put() => _wrap(
        m.postWrite.replace(
          id: int.tryParse(_postIdCtrl.text) ?? 1,
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          userId: int.tryParse(_userIdCtrl.text) ?? 1,
        ),
      );

  Future<_CallOutcome> _patch() => _wrap(
        m.postWrite.patch(
          id: int.tryParse(_postIdCtrl.text) ?? 1,
          fields: <String, dynamic>{'title': _titleCtrl.text},
        ),
      );

  Future<_CallOutcome> _delete() => _wrap(m.postWrite.delete(int.tryParse(_postIdCtrl.text) ?? 1));

  Widget _section(String title, String method, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(method, style: TextStyle(color: Colors.grey.shade800, fontSize: 12)),
          SelectableText(url, style: TextStyle(color: Colors.teal.shade800, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _tile({
    required String id,
    required bool busy,
    required _CallOutcome? outcome,
    required VoidCallback? onPressed,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onPressed != null)
              FilledButton(
                onPressed: busy ? null : onPressed,
                child: busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Gọi API'),
              ),
            if (busy && onPressed == null)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            if (outcome != null) ...[
              const SizedBox(height: 8),
              Text(
                'HTTP ${outcome.statusCode ?? '—'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: outcome.isError ? Colors.red.shade800 : Colors.green.shade800,
                ),
              ),
              Text('Message: ${outcome.message}'),
              if (outcome.preview.isNotEmpty) Text('Preview: ${outcome.preview}'),
            ],
          ],
        ),
      ),
    );
  }
}
