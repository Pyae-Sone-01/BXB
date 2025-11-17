part of '../home_screen.dart';

class _WalletInfoWidget extends ConsumerStatefulWidget {
  const _WalletInfoWidget();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __WalletInfoWidgetState();
}

class __WalletInfoWidgetState extends ConsumerState<_WalletInfoWidget> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final balance = ref
            .watch(homeViewModelImplProvider.select((s) => s.myCoin))
            ?.toPricing ??
        "0 Ks";

    final bffCoin =
        ref.watch(homeViewModelImplProvider.select((s) => s.bffCoin));
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppResources.colors.blue800,
            borderRadius: BorderRadius.vertical(
                //bottom: Radius.elliptical(20, 10),
                bottom: Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppResources.colors.blue600),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 0
                                      ? AppResources.colors.blue600
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(8)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                alignment: Alignment.center,
                                child: Text(
                                  'ပင်မပိုက်ဆံအိတ်',
                                  style: TextStyle(
                                    color: _selectedTab == 0
                                        ? Colors.white
                                        : const Color(0xFF1846C7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 1
                                      ? const Color(0xFF1846C7)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.horizontal(
                                      right: Radius.circular(8)),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                alignment: Alignment.center,
                                child: Text(
                                  'BFF Coins',
                                  style: TextStyle(
                                    color: _selectedTab == 1
                                        ? Colors.white
                                        : const Color(0xFF1846C7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(15),
                    // Balance
                    _selectedTab == 0
                        ? _remainingBalanceTagWidget(balance, bffCoin)
                        : _bffBalanceTagWidget(balance, bffCoin),
                    const Gap(8),
                  ],
                ),
              ),
              const Gap(10),
              _selectedTab == 0
                  ? _coinInCoinOut()
                  : ElevatedButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.coin.transferBff);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Changed border radius
                        ),
                      ),
                      child: const Text("BFF Coins ဖြင့် ငွေသွင်းမည်"),
                    ),
              const Gap(20),
            ],
          ),
        ),
        const Positioned(
            bottom: -20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
            )),
      ],
    );
  }

  Widget _coinInCoinOut() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppResources.colors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              context.pushNamed(RouteNames.coin.coinIn);
            },
            icon: Transform.rotate(
              angle: 0.785398, // -45 degrees in radians
              child: CustomImageWidget(
                AppResources.assets.icons.coinOut,
                width: 20,
                color: Colors.white,
              ),
            ),
            label: const Text('ငွေသွင်းရန်',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        const Gap(8),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFC727),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              context.pushNamed(RouteNames.coin.coinOut);
            },
            icon: Transform.rotate(
              angle: 0.785398, // +45 degrees in radians
              child: CustomImageWidget(
                AppResources.assets.icons.coinIn,
                width: 20,
              ),
            ),
            label: const Text('ငွေထုတ်ရန်',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Column _remainingBalanceTagWidget(String balance, BffCoinModel? bffCoin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'လက်ကျန်ငွေ',
          style: const TextStyle(fontSize: 16),
        ),
        const Gap(10),
        Text(
          balance,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Column _bffBalanceTagWidget(String balance, BffCoinModel? bffCoin) {
    final coin = bffCoin?.coin ?? 0;
    final mmk = (coin * 100).toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              AppResources.assets.icons.bffCoin,
              width: 32,
              height: 32,
              color: Colors.amber,
            ),
            const SizedBox(width: 8),
            Text(
              coin.toStringAsFixed(0),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF454B5C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '= $mmk MMK',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '(1 coin = 100 MMK)',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
