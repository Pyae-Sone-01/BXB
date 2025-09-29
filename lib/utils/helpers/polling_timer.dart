import 'dart:async';

class PollingTimer {
  final Duration interval;
  final Future<void> Function() onTick;
  Timer? _timer;
  bool _isRunning = false;

  PollingTimer(
      {required this.onTick, this.interval = const Duration(seconds: 1)});

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) async {
      if (_isRunning) return;
      _isRunning = true;
      try {
        await onTick();
      } finally {
        _isRunning = false;
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }
}
