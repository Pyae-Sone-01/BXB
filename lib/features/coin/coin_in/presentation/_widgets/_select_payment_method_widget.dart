part of '../coin_in_screen.dart';

class _SelectPaymentMethodWidget extends ConsumerWidget {
  const _SelectPaymentMethodWidget();

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
          const Text(
            'ငွေသွင်းမည့် နည်းလမ်းရွေးချယ်ပါ',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bankInfos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.5,
            ),
            itemBuilder: (context, index) {
              final bankInfo = bankInfos[index];
              return GestureDetector(
                onTap: () {
                  ref
                      .read(coinInViewModelImplProvider.notifier)
                      .selectPayment(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: selectedPayment == index
                          ? const Color(0xFF4B8AF3).withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedPayment == index
                            ? const Color(0xFF4B8AF3)
                            : Colors.grey.shade300,
                      )),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Radio<int>(
                          value: index,
                          groupValue: selectedPayment,
                          onChanged: (v) {
                            ref
                                .read(coinInViewModelImplProvider.notifier)
                                .selectPayment(index);
                          },
                          activeColor: const Color(0xFF4B8AF3),
                        ),
                      ),
                      Text(bankInfo.paymentMethod ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
