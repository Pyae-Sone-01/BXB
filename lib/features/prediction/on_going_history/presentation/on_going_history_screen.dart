import 'package:bxb/features/prediction/on_going_history/view_model/on_going_history_view_model.dart';
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

class OnGoingHistoryScreen extends ConsumerStatefulWidget {
  const OnGoingHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnGoingHistoryScreenState();
}

class _OnGoingHistoryScreenState extends ConsumerState<OnGoingHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onGoingHistoryViewModelProvider.notifier).initializeData();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      ref.read(onGoingHistoryViewModelProvider.notifier).loadmore();
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
        ref.watch(onGoingHistoryViewModelProvider.select((s) => s.histories));
    final isLoading =
        ref.watch(onGoingHistoryViewModelProvider.select((s) => s.isLoading));
    final isLoadmore =
        ref.watch(onGoingHistoryViewModelProvider.select((s) => s.isLoadmore));
    return Scaffold(
      appBar: AppBar(
        title: const Text('လောင်းထားသောပွဲများ'),
        centerTitle: false,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(onGoingHistoryViewModelProvider.notifier).onRefresh();
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
                        return HistoryItemWidget(
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
