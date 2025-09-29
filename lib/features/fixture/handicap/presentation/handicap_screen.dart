import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/max_payout_widget.dart';
import 'package:bxb/features/fixture/handicap/view_model/handicap_view_model.dart';
import 'package:bxb/utils/common/widgets/custom_image_widget.dart';
import 'package:bxb/utils/common/widgets/fixture_group_item_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/helpers/functions.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HandicapScreen extends ConsumerStatefulWidget {
  const HandicapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HandicapScreenState();
}

class _HandicapScreenState extends ConsumerState<HandicapScreen> {
  late final HandicapViewModel _handicapViewModel;

  @override
  void initState() {
    _handicapViewModel = ref.read(handicapViewModelImplProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handicapViewModel.initializedData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(handicapViewModelImplProvider.select((s) => s.isLoading));
    final fixtures =
        ref.watch(handicapViewModelImplProvider.select((s) => s.fixtures));
    final remainingBalance = ref
        .watch(handicapViewModelImplProvider.select((s) => s.remainingBalance));
    final leagues =
        ref.watch(handicapViewModelImplProvider.select((s) => s.leauges));
    final selectedLeagueIds =
        ref.watch(handicapViewModelImplProvider.select((s) => s.leagueIds));

    final prediction =
        ref.watch(handicapViewModelImplProvider.select((s) => s.prediction));

    // Flatten fixtures for a single ListView
    final flatFixtures = convertFlattenFixtures(fixtures);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 30,
        title: CustomImageWidget(
          AppResources.assets.images.logo,
          width: 100,
        ),
        actions: [
          const Text("ဘော်ဒီ/ဂိုးပေါင်း"),
          IconButton(
            onPressed: () {
              DialogManger.showLeagueFilter(
                context,
                leagues: leagues,
                onApply: _handicapViewModel.leagueFilterApply,
                selectedIds: selectedLeagueIds,
              );
            },
            icon: const Icon(Icons.sort_sharp),
          )
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: flatFixtures.length,
                    itemBuilder: (context, index) {
                      final fixture = flatFixtures[index];
                      return FixtureGroupItemWidget(
                        fixture: fixture,
                        predictions: prediction != null ? [prediction] : [],
                        onPrediction: ({required data}) {
                          ref
                              .read(handicapViewModelImplProvider.notifier)
                              .selectPrediction(prediction: data);
                        },
                      );
                    },
                  ),
                ),
                MaxPayoutWidget(
                  remainingBalance: remainingBalance.toString(),
                  onPrediction: (value) {
                    _handicapViewModel.onPrediction(context,
                        predictedCoin: value);
                  },
                ),
              ],
            ),
    );
  }
}
