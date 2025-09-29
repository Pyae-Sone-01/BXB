import 'package:bxb/features/fixture/accumulator/view_model/accumulator_view_model.dart';
import 'package:bxb/services/fixture/models/prediction_fixture_model.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:bxb/utils/common/widgets/fixture_group_item_widget.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/common/widgets/max_payout_widget.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/common/widgets/custom_image_widget.dart';

class AccumulatorScreen extends ConsumerStatefulWidget {
  const AccumulatorScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccumulatorScreenState();
}

class _AccumulatorScreenState extends ConsumerState<AccumulatorScreen> {
  late final AccumulatorViewModel _accumulatorViewModel;
  @override
  void initState() {
    _accumulatorViewModel = ref.read(accumulatorViewModelImplProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _accumulatorViewModel.initializedData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(accumulatorViewModelImplProvider.select((s) => s.isLoading));
    final fixtures =
        ref.watch(accumulatorViewModelImplProvider.select((s) => s.fixtures));
    final remainingBalance = ref.watch(
        accumulatorViewModelImplProvider.select((s) => s.remainingBalance));
    final leagues =
        ref.watch(accumulatorViewModelImplProvider.select((s) => s.leauges));

    final selectedLeagueIds =
        ref.watch(accumulatorViewModelImplProvider.select((s) => s.leagueIds));

    final predicitons = ref
        .watch(accumulatorViewModelImplProvider.select((s) => s.predictions));
    final flatFixtures = _flattenFixtures(fixtures);
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
          Text("မောင်း"),
          IconButton(
            onPressed: () {
              DialogManger.showLeagueFilter(
                context,
                leagues: leagues,
                onApply: _accumulatorViewModel.leagueFilterApply,
                selectedIds: selectedLeagueIds,
              );
            },
            icon: Icon(Icons.sort_sharp),
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
                        predictions: predicitons,
                        onPrediction: ({required data}) {
                          ref
                              .read(accumulatorViewModelImplProvider.notifier)
                              .selectPrediction(prediction: data);
                        },
                      );
                    },
                  ),
                ),
                MaxPayoutWidget(
                  remainingBalance: remainingBalance.toString(),
                  predictionCount: predicitons.length,
                  onPrediction: (value) {
                    _accumulatorViewModel.onPrediction(context,
                        predictedCoin: value);
                  },
                )
              ],
            ),
    );
  }

  List<dynamic> _flattenFixtures(List<List<dynamic>> fixtures) {
    final List<dynamic> flatList = [];
    for (final group in fixtures) {
      flatList.addAll(group);
    }
    return flatList;
  }
}
