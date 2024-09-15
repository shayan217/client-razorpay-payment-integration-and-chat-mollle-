import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._inner, this._storage);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';
    return _inner.send(request);
  }
}