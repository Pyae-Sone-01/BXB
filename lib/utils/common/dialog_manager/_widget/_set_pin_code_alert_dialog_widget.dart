part of '../dialog_manager.dart';

class _SetPinCodeAlertDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _SetPinCodeAlertDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PIN သတ်မှတ်ရန် လိုအပ်သည်',
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              'ငွေထုတ်တဲ့အခါ ပိုမိုလုံခြုံစိတ်ချရအောင် PIN နံပါတ်သတ်မှတ်ပေးပါ။',
              style: TextStyle(
                fontSize: 14,
                color: AppResources.colors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppResources.colors.blue600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'လုပ်ဆောင်မည်',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
