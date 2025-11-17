import 'package:bxb/features/coin/coin_history/presentation/_widget/coin_history_item_widget.dart';
import 'package:bxb/features/coin/coin_history/view_model/coin_history_view_model.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/empty_error_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinHistoryScreen extends ConsumerStatefulWidget {
  const CoinHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends ConsumerState<CoinHistoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coinHistoryViewModelProvider.notifier).initializeData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(coinHistoryViewModelProvider.select((s) => s.isLoading));
    final histories =
        ref.watch(coinHistoryViewModelProvider.select((s) => s.histories));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("ငွေစာရင်း"),
        actions: [
          IconButton(
              onPressed: () {
                DialogManger.showCoinHistoryFilter(
                  context,
                  onApply: (startDate, endDate) {
                    ref
                        .read(coinHistoryViewModelProvider.notifier)
                        .applyFilter(startDate: startDate, endDate: endDate);
                  },
                );
              },
              icon: Icon(Icons.sort))
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(coinHistoryViewModelProvider.notifier).initializeData();
        },
        child: isLoading
            ? const LoadingWidget()
            : histories.isEmpty
                ? const EmptyErrorWidget(msg: "ငွေစာရင်းများ မရှိပါ")
                : ListView.builder(
                    itemCount: histories.length,
                    itemBuilder: (context, index) {
                      final item = histories[index];
                      return CoinHistoryItemWidget(
                        data: item,
                      );
                    },
                  ),
      ),
    );
  }
}
