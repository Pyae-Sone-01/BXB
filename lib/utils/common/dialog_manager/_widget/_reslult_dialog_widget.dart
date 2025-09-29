part of '../dialog_manager.dart';

class _ResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String description;
  final VoidCallback confirmCallback;

  const _ResultDialog({
    required this.isSuccess,
    required this.title,
    required this.description,
    required this.confirmCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(30),
            Container(
              decoration: BoxDecoration(
                color: isSuccess ? Colors.green[100] : Colors.red[100],
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(18),
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 48,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF484C54),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B8AF3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: confirmCallback,
                child: const Text(
                  'အိုကေ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
