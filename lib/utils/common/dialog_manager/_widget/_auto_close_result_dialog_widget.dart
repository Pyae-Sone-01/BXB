part of '../dialog_manager.dart';

class _AutoCloseResultDialog extends StatefulWidget {
  final bool isSuccess;
  final String description;

  const _AutoCloseResultDialog({
    required this.isSuccess,
    required this.description,
  });

  @override
  State<_AutoCloseResultDialog> createState() => _AutoCloseResultDialogState();
}

class _AutoCloseResultDialogState extends State<_AutoCloseResultDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      _closeDialog();
    });
  }

  _closeDialog() {
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 1), () {
        FocusManager.instance.primaryFocus?.unfocus();
      });
      Navigator.of(context).pop();
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
                onTap: _closeDialog, child: const Icon(Icons.close)),
          ),
        ],
      ),
    );
  }
}
