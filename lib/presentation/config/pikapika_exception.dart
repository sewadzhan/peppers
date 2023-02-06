//Special exception for app to avoid unnecessary "Exception:" string in messages
class PikapikaException implements Exception {
  final String message;

  PikapikaException(this.message);

  @override
  String toString() {
    return message;
  }
}
