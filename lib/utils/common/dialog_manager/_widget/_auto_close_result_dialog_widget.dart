part of '../dialog_manager.dart';

class _AutoCloseResultDialog extends StatefulWidget {
  final bool isSuccess;
  final String description;
  final VoidCallback onCompleteCallback;
  const _AutoCloseResultDialog(
      {required this.isSuccess,
      required this.description,
      required this.onCompleteCallback});

  @override
  State<_AutoCloseResultDialog> createState() => _AutoCloseResultDialogState();
}

class _AutoCloseResultDialogState extends State<_AutoCloseResultDialog> {
  Timer? _countdownTimer;
  bool _canUserClose = true;

  @override
  void initState() {
    super.initState();

    // Start countdown timer
    _countdownTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final elapsed = timer.tick * 100; // milliseconds elapsed
      final remaining = 2000 - elapsed; // total 2 seconds

      // Prevent user close in the last 500ms
      final shouldPreventClose = remaining <= 500 && remaining > 0;
      if (_canUserClose == shouldPreventClose) {
        setState(() {
          _canUserClose = !shouldPreventClose;
        });
      }

      if (remaining <= 0) {
        timer.cancel();
        _closeDialog();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  _closeDialog() {
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1), () {
        FocusManager.instance.primaryFocus?.unfocus();
      });
      Navigator.of(context).pop();
      widget.onCompleteCallback();
    }
  }

  void _onClosePressed() {
    if (_canUserClose) {
      _closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(40),
      elevation: 0,
      child: Stack(
        alignment: AlignmentGeometry.topRight,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isSuccess ? Colors.green[100] : Colors.red[50],
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isSuccess ? Icons.check_circle : Icons.error,
                  color: widget.isSuccess ? Colors.green : Colors.red,
                  size: 48,
                ),
                Gap(30),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color:
                        widget.isSuccess ? Colors.green[800] : Colors.red[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: _canUserClose ? _onClosePressed : null,
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
