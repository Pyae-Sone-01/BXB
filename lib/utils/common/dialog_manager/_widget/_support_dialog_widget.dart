part of '../dialog_manager.dart';

class _SupportDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String phoneLabel;
  final String phoneNumber;
  final VoidCallback onClose;

  const _SupportDialogWidget({
    required this.title,
    required this.message,
    required this.phoneLabel,
    required this.phoneNumber,
    required this.onClose,
  });

  Future<void> _openViberChat() async {
    var viberUri = Uri.parse('viber://chat?number=%2B959989414141');

    // if (await canLaunchUrl(viberUri)) {
    //   await launchUrl(viberUri, mode: LaunchMode.externalApplication);
    // } else {
    //   //await launchUrl(viberStoreUri, mode: LaunchMode.externalApplication);
    // }

    const platform = MethodChannel('viber_launcher');
    try {
      await platform.invokeMethod('openViberChat', {'number': phoneNumber});
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: AppResources.colors.blue200,
              radius: 30,
              child: CustomImageWidget(
                AppResources.assets.icons.support,
                color: AppResources.colors.blue600,
                width: 30,
              ),
            ),
            const Gap(18),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppResources.colors.neutral800,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: AppResources.colors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            GestureDetector(
              onTap: _openViberChat,
              child: Text(
                "$phoneNumber (Viber)",
                style: TextStyle(
                  fontSize: 16,
                  color: AppResources.colors.blue700,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(16),
            Text(
              phoneLabel,
              style: TextStyle(
                fontSize: 14,
                color: AppResources.colors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppResources.colors.blue600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'အိုကေ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
