part of '../transfer_bff_screen.dart';

class _CurrentCoinAmountWidget extends ConsumerStatefulWidget {
  const _CurrentCoinAmountWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __CurrentCoinAmountWidgetState();
}

class __CurrentCoinAmountWidgetState
    extends ConsumerState<_CurrentCoinAmountWidget> {
  @override
  Widget build(BuildContext context) {
    final data =
        ref.watch(transferBffViewModelImplProvider.select((s) => s.bffCoin));
    return Column(
      children: [
        const Text(
          "လက်ရှိ Coin ပမာဏ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              AppResources.assets.icons.bffCoin,
              color: Colors.amber,
            ),
            const Gap(10),
            Text(
              "${data?.coin ?? 0}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const Gap(4),
        const Text(
          "= 0 MMK",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const Gap(2),
        const Text(
          "(1 coin = 100 MMK)",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
