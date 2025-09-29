import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class ISocketIoService {
  void on(String event, Function(dynamic data) handler);
  void emit(String event, dynamic data);
  void disconnect();
  void onConnect(dynamic Function(dynamic) handler);
  void onDisconnect(dynamic Function(dynamic) handler);
  void onError(dynamic Function(dynamic) handler);
  void onConnectError(dynamic Function(dynamic) handler);
}

class SocketIoService implements ISocketIoService {
  late IO.Socket? _socket;
  SocketIoService(String url, {Map<String, dynamic>? options}) {
    _socket = IO.io(
      url,
      options ??
          {
            'transports': ['websocket'],
            'autoConnect': false,
          },
    );
    _socket!.connect();
  }

  @override
  void on(String event, Function(dynamic data) handler) {
    _socket?.on(event, handler);
  }

  @override
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  @override
  void disconnect() {
    _socket?.disconnect();
  }

  @override
  void onConnect(dynamic Function(dynamic) handler) {
    _socket?.onConnect(handler);
  }

  @override
  void onDisconnect(dynamic Function(dynamic) handler) {
    _socket?.onDisconnect(handler);
  }

  @override
  void onError(dynamic Function(dynamic) handler) {
    _socket?.onError(handler);
  }

  @override
  void onConnectError(dynamic Function(dynamic) handler) {
    _socket?.onConnectError(handler);
  }
}
