import 'package:bxb/features/fixture/score/view_model/score_view_model.dart';
import 'package:bxb/services/fixture/models/fixture_for_score_model.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/helpers/functions.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

part '_widget/_score_fixture_group_item_widget.dart';

class ScoreScreen extends ConsumerStatefulWidget {
  const ScoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends ConsumerState<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(scoreViewModelImplProvider.notifier).initializeData();
    });
  }

  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(scoreViewModelImplProvider.select((s) => s.isLoading));
    final scores =
        ref.watch(scoreViewModelImplProvider.select((s) => s.scores));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("ပွဲရလဒ်များ"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: _tabIndex == 0
                            ? const Color(0xFF4B8AF3)
                            : const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _tabIndex == 0
                              ? Colors.white
                              : const Color(0xFF484C54),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(5),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tabIndex = 1),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: _tabIndex == 1
                            ? const Color(0xFF4B8AF3)
                            : const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Yesterday',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _tabIndex == 1
                              ? Colors.white
                              : const Color(0xFF484C54),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const LoadingWidget()
          : _tabIndex == 0
              ? _buildContent(scores?.today ?? [])
              : _buildContent(scores?.yesterday ?? []),
    );
  }

  _buildContent(List<List<LeagueFixtures>> fixtures) {
    final flatFixtures = convertFlattenFixtures(fixtures);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: flatFixtures.length,
      itemBuilder: (context, index) {
        final fixture = flatFixtures[index];
        return _FixtureGroupItemWidget(fixture: fixture);
      },
    );
  }
}
