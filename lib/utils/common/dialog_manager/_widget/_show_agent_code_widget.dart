part of '../dialog_manager.dart';

class _ShowAgentCodeWidget extends StatelessWidget {
  final String agentCode;
  final VoidCallback onClose;

  const _ShowAgentCodeWidget({
    required this.agentCode,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'သင်၏ အေးဂျင့်ကုဒ်',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppResources.colors.blue600,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),

            // Agent Code Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppResources.colors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppResources.colors.gray300,
                  width: 1,
                ),
              ),
              child: Text(
                agentCode,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppResources.colors.neutral950,
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Gap(32),

            // Close Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: onClose,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppResources.colors.gray400,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       elevation: 0,
            //     ),
            //     child: Text(
            //       'Close',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w600,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF484C54)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
