/// In-memory bearer token. Replace with secure_storage / session when wiring auth.
class TokenStore {
  TokenStore._();
  static final TokenStore instance = TokenStore._();

  String? _accessToken;
  String? get accessToken => _accessToken;

  void setAccessToken(String? value) {
    _accessToken = value;
  }
}
