part of '../coin_in_screen.dart';

class _BanKInfoWidget extends ConsumerWidget {
  const _BanKInfoWidget();

  _copyPhoneNumber(
      {required BuildContext context, required String textToCopy}) async {
    Clipboard.setData(ClipboardData(text: textToCopy));
    DialogManger.showAutoCloseResultDialog(context,
        isSuccess: true, description: "အကောင့်နံပါတ်ကို ကူးယူပြီးပါပြီ");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankInfos =
        ref.watch(coinInViewModelImplProvider.select((s) => s.bankInfos));
    final selectedPayment =
        ref.watch(coinInViewModelImplProvider.select((s) => s.selectedPayment));
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ငွေသွင်းမည့် အကောင့်',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Divider(height: 24),
          ...?bankInfos[selectedPayment].bankInfo?.map((e) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ငွေသွင်းမည့် အကောင့်',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text(e.name ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('အကောင့် (ဖုန်း) နံပါတ်:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _copyPhoneNumber(
                              context: context,
                              textToCopy: e.accountNumber ?? "");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(e.accountNumber ?? "",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                            const Gap(8),
                            const Icon(Icons.copy,
                                size: 18, color: Color(0xFF4B8AF3)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}
