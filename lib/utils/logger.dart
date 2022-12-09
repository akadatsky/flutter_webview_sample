// ignore_for_file: avoid_print
class Log {
  static final Log _instance = Log._internal();

  factory Log() {
    return _instance;
  }

  Log._internal();

  void d({
    String? tag,
    dynamic message,
  }) {
    print('$tag: $message');
  }
}
