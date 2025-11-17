import 'package:bxb/features/coin/transfer_bff/view_model/transfer_bff_view_model.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
part '_widget/_current_coin_amount_widget.dart';
part '_widget/_coin_option_widget.dart';

class TransferBffScreen extends ConsumerStatefulWidget {
  const TransferBffScreen({super.key});

  @override
  ConsumerState<TransferBffScreen> createState() => _TransferBffScreenState();
}

class _TransferBffScreenState extends ConsumerState<TransferBffScreen> {
  final TextEditingController _coinController = TextEditingController();

  @override
  initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transferBffViewModelImplProvider.notifier).initializeData();
    });
  }

  double _coin = 0;

  _setCoinAmt(double coin) {
    setState(() {
      _coin = coin;
    });
    _coinController.text = (coin * 100).toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(transferBffViewModelImplProvider.select((s) => s.isLoading));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Transfer BFF"),
      ),
      body: isLoading
          ? const LoadingWidget()
          : SingleChildScrollView(
              child: Container(
                width: 400,
                margin:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _CurrentCoinAmountWidget(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ပမာဏ ရွေးချယ်ရန်",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Gap(16),
                    GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.7,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(10);
                            },
                            child: _CoinOption(
                              amount: "1,000 MMK",
                              coins: "10 Coins",
                              isSelected: _coin == 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(50);
                            },
                            child: _CoinOption(
                              amount: "5,000 MMK",
                              coins: "50 Coins",
                              isSelected: _coin == 50,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(100);
                            },
                            child: _CoinOption(
                              amount: "10,000 MMK",
                              coins: "100 Coins",
                              isSelected: _coin == 100,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(200);
                            },
                            child: _CoinOption(
                              amount: "20,000 MMK",
                              coins: "200 Coins",
                              isSelected: _coin == 200,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(500);
                            },
                            child: _CoinOption(
                              amount: "50,000 MMK",
                              coins: "500 Coins",
                              isSelected: _coin == 500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _setCoinAmt(1000);
                            },
                            child: _CoinOption(
                              amount: "100,000 MMK",
                              coins: "1,000 Coins",
                              isSelected: _coin == 1000,
                            ),
                          ),
                        ]),
                    const Gap(24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ကိုယ်တိုင် ပမာဏ ထည့်ရန်",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Gap(12),
                    TextField(
                      controller: _coinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter coin amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _coin = ((num.tryParse(value) ?? 0) / 100);
                        });
                      },
                    ),
                    const Gap(8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "= ${_coin % 1 == 0 ? _coin.toInt() : _coin} Coins",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Gap(24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _coin < 10
                            ? null
                            : () {
                                ref
                                    .read(transferBffViewModelImplProvider
                                        .notifier)
                                    .depositBffCoin(context, _coin);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppResources.colors.blue600,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "ဖြည့်မည်",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
