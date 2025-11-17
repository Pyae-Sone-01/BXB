part of '../transfer_bff_screen.dart';

class _CoinOption extends StatelessWidget {
  final String amount;
  final String coins;
  final bool isSelected;
  const _CoinOption(
      {required this.amount, required this.coins, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color:
                isSelected ? AppResources.colors.blue600 : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Gap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageWidget(
                AppResources.assets.icons.bffCoin,
                color: Colors.amber,
                width: 20,
              ),
              const Gap(4),
              Text(
                coins, // You can pass coins as a parameter
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
