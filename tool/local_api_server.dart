// ignore_for_file: avoid_print

// Local REST API for Flutter (127.0.0.1). Run: dart run tool/local_api_server.dart
// Flutter: flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8787 --dart-define=REQRES_BASE_URL=http://127.0.0.1:8787/api

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

const _host = '127.0.0.1';
const _port = 8787;

const _cors = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};

Middleware _corsMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {..._cors, 'Content-Length': '0'});
      }
      final Response response = await inner(request);
      return response.change(headers: {...response.headers, ..._cors});
    };
  };
}

Response _json(Object body, {int status = 200}) {
  return Response(
    status,
    body: jsonEncode(body),
    headers: {..._cors, HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
  );
}

void main() async {
  final Router r = Router();

  const posts = [
    {'userId': 1, 'id': 1, 'title': 'Local post 1', 'body': 'Hello from 127.0.0.1'},
    {'userId': 1, 'id': 2, 'title': 'Local post 2', 'body': 'Second item'},
  ];
  const albums = [
    {'userId': 1, 'id': 1, 'title': 'Local album 1'},
    {'userId': 1, 'id': 2, 'title': 'Local album 2'},
  ];
  const comments = [
    {'postId': 1, 'id': 1, 'name': 'A', 'email': 'a@local.test', 'body': 'Comment local'},
  ];
  const todos = [
    {'userId': 1, 'id': 1, 'title': 'Todo local', 'completed': false},
  ];
  const users = [
    {'id': 1, 'name': 'Local User', 'username': 'local', 'email': 'user@local.test'},
  ];
  const photos = [
    {
      'albumId': 1,
      'id': 1,
      'title': 'photo',
      'url': 'https://via.placeholder.com/600',
      'thumbnailUrl': 'https://via.placeholder.com/150',
    },
  ];

  r.get('/posts', (_) => _json(posts));
  r.get('/posts/<id|[^/]+>', (Request req, String id) {
    final n = int.tryParse(id);
    if (n == null || n < 1 || n > 999) {
      return Response.notFound(jsonEncode({'message': 'Not found'}), headers: _cors);
    }
    if (n > posts.length) {
      return Response.notFound(jsonEncode({}), headers: _cors);
    }
    return _json(posts[n - 1]);
  });

  r.post('/posts', (Request req) async {
    final Object? data = json.decode(await req.readAsString());
    if (data is! Map) return _json({'error': 'Invalid JSON'}, status: 422);
    return _json({...data, 'id': 101});
  });
  r.put('/posts/<id|[^/]+>', (Request req, String id) async {
    final Object? data = json.decode(await req.readAsString());
    if (data is! Map) return _json({'error': 'Invalid JSON'}, status: 422);
    return _json({...data, 'id': int.tryParse(id) ?? 1});
  });
  r.patch('/posts/<id|[^/]+>', (Request req, String id) async {
    final Object? data = json.decode(await req.readAsString());
    if (data is! Map) return _json({'error': 'Invalid JSON'}, status: 422);
    return _json({
      'userId': 1,
      'id': int.tryParse(id) ?? 1,
      'title': data['title'] ?? 'patched',
      'body': data['body'] ?? 'patched body',
    });
  });
  r.delete('/posts/<id|[^/]+>', (Request req, String id) => _json(<String, dynamic>{}));

  r.get('/albums', (_) => _json(albums));
  r.get('/albums/<id|[^/]+>', (_, String id) {
    final n = int.tryParse(id);
    if (n == null || n < 1 || n > albums.length) {
      return Response.notFound(jsonEncode({}), headers: _cors);
    }
    return _json(albums[n - 1]);
  });

  r.get('/comments', (Request req) {
    final String? postId = req.url.queryParameters['postId'];
    if (postId == null) return _json(comments);
    final filtered = comments.where((c) => '${c['postId']}' == postId).toList();
    return _json(filtered);
  });

  r.get('/todos', (_) => _json(todos));

  r.get('/users', (_) => _json(users));
  r.get('/users/<id|[^/]+>', (_, String id) {
    final n = int.tryParse(id);
    if (n != 1) return Response.notFound(jsonEncode({}), headers: _cors);
    return _json(users[0]);
  });

  r.get('/photos', (Request req) {
    final int limit = int.tryParse(req.url.queryParameters['_limit'] ?? '8') ?? 8;
    return _json(photos.take(limit).toList());
  });

  r.post('/api/login', (Request req) async {
    final Object? data = json.decode(await req.readAsString());
    if (data is! Map) return _json({'error': 'Invalid body'}, status: 422);
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    if (email == 'eve.holt@reqres.in' && password == 'cityslicka') {
      return _json({'token': 'local-dev-token'});
    }
    return _json({'error': 'user not found'}, status: 400);
  });

  final Handler handler = const Pipeline().addMiddleware(_corsMiddleware()).addHandler(r.call);

  final HttpServer server = await shelf_io.serve(handler, _host, _port);
  print('Local API đang chạy:');
  print('  JSON (posts, albums, …): http://$_host:${server.port}');
  print('  Login:                    http://$_host:${server.port}/api/login');
  print('');
  print('Flutter:');
  print('  flutter run --dart-define=API_BASE_URL=http://$_host:${server.port} '
      '--dart-define=REQRES_BASE_URL=http://$_host:${server.port}/api');
}
