import 'dart:async';
import 'package:bxb/services/fixture/models/league_fixture_model.dart';
import 'package:bxb/services/fixture/models/league_model.dart';
import 'package:bxb/services/prediction/models/estimate_fixture_item_model.dart';
import 'package:bxb/utils/common/widgets/loading_widget.dart';
import 'package:bxb/utils/common/widgets/txt_input_widget.dart';
import 'package:bxb/utils/extension/num_extension.dart';
import 'package:bxb/utils/extension/string_extension.dart';
import 'package:bxb/utils/helpers/validator_functions.dart';
import 'package:bxb/utils/themes/app_resources.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../services/fixture/models/prediction_fixture_model.dart';
part '_widget/_league_filter_bottom_sheet_widget.dart';
part '_widget/_reslult_dialog_widget.dart';
part '_widget/_auto_close_result_dialog_widget.dart';
part '_widget/_confrim_pin_dialog_widget.dart';
part '_widget/_add_agent_code_dialog_widget.dart';
part '_widget/_handicap_prediction_preview_dialog_widget.dart';
part '_widget/_handicap_estimate_wining_dialog_widget.dart';

class DialogManger {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LoadingWidget(),
    );
  }

  static closeDialog(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1), () {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    Navigator.of(context).pop();
  }

  static showLeagueFilter(
    BuildContext context, {
    required List<LeagueModel> leagues,
    required Function(List<num> leagues) onApply,
    required List<num> selectedIds,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 👈 allow full height control
        backgroundColor: Colors
            .transparent, // optional: so your container color shows correctly
        builder: (context) => _LeagueFilterBottomSheetWidget(
              leagues: leagues,
              onApply: onApply,
              selectedIds: selectedIds,
            ));
  }

  static showResultDialog(
    BuildContext context, {
    required bool isSuccess,
    required String title,
    required String description,
    required VoidCallback confirmCallback,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: _ResultDialog(
          isSuccess: isSuccess,
          title: title,
          description: description,
          confirmCallback: () {
            closeDialog(context);
            confirmCallback();
          },
        ),
      ),
    );
  }

  static showAutoCloseResultDialog(
    BuildContext context, {
    required bool isSuccess,
    required String description,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AutoCloseResultDialog(
        isSuccess: isSuccess,
        description: description,
      ),
    );
  }

  static showConfirmPinDialog(BuildContext context,
      {required Function(String pin) onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ConfirmPinDialog(onConfirm: onConfirm),
    );
  }

  static showAddAgentCodeDialog(BuildContext context,
      {required Function(String pin) onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AddAgentCodeDialog(onConfirm: onConfirm),
    );
  }

  static showHandicapPredictionPreviewDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
    required List<FixtureModel> items,
    required List<PredictionFixtureModel> prediction,
    required num? predictedCoin,
    required num? estimateWinningCoin,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _HandicapPredicitonPreviewDialogWidget(
        items: items,
        prediction: prediction,
        onClose: () {
          closeDialog(context);
        },
      ),
    );
  }

  static showHandicapEstimateWiningCoin(
    BuildContext context, {
    required VoidCallback onConfirm,
    required EstimateWiningFixtureItemModel data,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _HandicapEstimateWiningDialogWidget(
          data: data,
          onConfirm: () {
            closeDialog(context);
            onConfirm();
          },
          onClose: () {
            closeDialog(context);
          }),
    );
  }
}
