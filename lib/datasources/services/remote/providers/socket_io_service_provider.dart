import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../socket_io_service.dart';

part 'socket_io_service_provider.g.dart';

@riverpod
ISocketIoService socketIoService(ref) {
  return SocketIoService("");
}
