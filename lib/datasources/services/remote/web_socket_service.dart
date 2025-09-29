import 'package:web_socket_channel/web_socket_channel.dart';

abstract class IWebSocketService {
  void connect(String url);
  Stream<dynamic> get stream;
  void send(dynamic data);
  void disconnect();
}

class WebSocketService implements IWebSocketService {
  late final WebSocketChannel _channel;

  @override
  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  @override
  Stream<dynamic> get stream => _channel.stream;

  @override
  void send(dynamic data) {
    _channel.sink.add(data);
  }

  @override
  void disconnect() {
    _channel.sink.close();
  }
}
