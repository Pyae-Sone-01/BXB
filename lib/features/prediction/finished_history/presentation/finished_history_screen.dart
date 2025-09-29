import 'package:bxb/features/prediction/finished_history/view_model/finsished_history_view_model.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/services/prediction/models/history_model.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
part '_widgets/history_item_widget.dart';

class FinishedHistoryScreen extends ConsumerStatefulWidget {
  const FinishedHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinishedHistoryScreenState();
}

class _FinishedHistoryScreenState extends ConsumerState<FinishedHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(finishedHistoryViewModelProvider.notifier).initializeData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(finishedHistoryViewModelProvider.notifier).loadmore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final histories =
        ref.watch(finishedHistoryViewModelProvider.select((s) => s.histories));
    final isLoading =
        ref.watch(finishedHistoryViewModelProvider.select((s) => s.isLoading));
    final isLoadmore =
        ref.watch(finishedHistoryViewModelProvider.select((s) => s.isLoadmore));
    return Scaffold(
      appBar: AppBar(
        title: const Text('လောင်းပြီးသောပွဲများ'),
        centerTitle: false,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(finishedHistoryViewModelProvider.notifier).onRefresh();
        },
        child: isLoading
            ? const LoadingWidget()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      controller: _scrollController,
                      itemCount: histories.length,
                      itemBuilder: (context, index) {
                        return _HistoryItemWidget(
                          data: histories[index],
                        );
                      },
                    ),
                  ),
                  if (isLoadmore)
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                ],
              ),
      ),
    );
  }
}
