/// Typed HTTP outcome for UI (status + parsed payload + server hints).
class HttpData<T> {
  const HttpData({
    required this.statusCode,
    required this.data,
    this.reasonPhrase,
    this.serverMessage,
    this.rawBodyPreview,
  });

  final int statusCode;
  final T data;
  final String? reasonPhrase;
  final String? serverMessage;
  final String? rawBodyPreview;
}
