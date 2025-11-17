part of '../dialog_manager.dart';

class _ShowExpireMatchAlertDialog extends StatelessWidget {
  final int expireMatchCount;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const _ShowExpireMatchAlertDialog({
    super.key,
    required this.expireMatchCount,
    required this.onCancel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon

            // Title
            Text(
              'အချိန်ကျော်လွန်သွားသော ပွဲများ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppResources.colors.blue700,
              ),
              textAlign: TextAlign.center,
            ),

            Divider(
              height: 30,
            ),

            // Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: AppResources.colors.gray700,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: 'ရွေးချယ်ထားသော ပွဲများထဲတွင် '),
                  TextSpan(
                    text: '$expireMatchCount ခု',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppResources.colors.warning,
                    ),
                  ),
                  TextSpan(
                      text:
                          ' အချိန်ကျော်လွန်သွားပြီ ဖြစ်ပါသည်။ ထိုပွဲ(များ)ကို ဖယ်ရှားရန် လိုအပ်သည်။'),
                ],
              ),
            ),

            const Gap(28),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: AppResources.colors.gray400,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'မဖယ်ရှားသေးပါ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppResources.colors.gray700,
                      ),
                    ),
                  ),
                ),

                const Gap(12),

                // Continue Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppResources.colors.blue600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'ဖယ်ရှားမည်',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
