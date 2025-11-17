import 'dart:async';

import 'package:bxb/features/fixture/accumulator/view_model/accumulator_estimate_dialog_view_model.dart';
import 'package:bxb/features/fixture/handicap/view_model/handicap_estimate_dialog_view_model.dart';
import 'package:bxb/router/router.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:video_player/video_player.dart';

import '../../../services/fixture/models/prediction_fixture_model.dart';
import '../../../services/prediction/models/accumulator_estimate_wining_res_model.dart';
import '../widgets/custom_image_widget.dart';
part '_widget/_league_filter_bottom_sheet_widget.dart';
part '_widget/_reslult_dialog_widget.dart';
part '_widget/_auto_close_result_dialog_widget.dart';
part '_widget/_confrim_pin_dialog_widget.dart';
part '_widget/_add_agent_code_dialog_widget.dart';
part '_widget/_prediction_preview_dialog_widget.dart';
part '_widget/_handicap_estimate_wining_dialog_widget.dart';
part '_widget/_accumulator_estimate_wining_dialog_widget.dart';
part '_widget/_support_dialog_widget.dart';
part '_widget/_rule_and_regulation_dialog_widget.dart';
part '_widget/_coin_in_coin_out_tutorial_dialog_widget.dart';
part '_widget/_update_pin_dialog_widget.dart';
part '_widget/_finished_predict_filter_dialog_widget.dart';
part '_widget/_set_pin_code_alert_dialog_widget.dart';
part '_widget/_language_select_dialog_widget.dart';
part '_widget/_coin_history_filter_widget.dart';
part '_widget/_show_agent_code_widget.dart';
part '_widget/_how_to_open_acc_tutorial_dialog_widget.dart';
part '_widget/_show_expire_match_alert_dialog.dart';
part '_widget/_update_alert_dialog_widget.dart';

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
    context.pop();
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
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: _ResultDialog(
          isSuccess: isSuccess,
          title: title,
          description: description,
          confirmCallback: () {
            closeDialog(dialogContext);
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
    VoidCallback? onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AutoCloseResultDialog(
        isSuccess: isSuccess,
        description: description,
        onCompleteCallback: onComplete ?? () {},
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
      {required Function(String code) onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AddAgentCodeDialog(
        onConfirm: (pin) {
          closeDialog(dialogContext);
          onConfirm(pin);
        },
      ),
    );
  }

  static showPredictionPreviewDialog(BuildContext context,
      {required VoidCallback onConfirm,
      required List<FixtureModel> items,
      required List<PredictionFixtureModel> prediction,
      required num? predictedCoin,
      required num? estimateWinningCoin,
      required Function(int id) onDeletePrediction}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _PredicitonPreviewDialogWidget(
        items: items,
        prediction: prediction,
        onClose: () {
          closeDialog(dialogContext);
        },
        onDeletePrediction: onDeletePrediction,
      ),
    );
  }

  static showHandicapEstimateWiningCoin(
    BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onClose,
    required EstimateWiningFixtureItemModel data,
    required PredictionFixtureModel prediction,
    required num predictedCoin,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          onClose();
        },
        child: _HandicapEstimateWiningDialogWidget(
            initialData: data,
            prediction: prediction,
            predictedCoin: predictedCoin,
            onConfirm: () {
              closeDialog(dialogContext);
              onConfirm();
            },
            onClose: () {
              closeDialog(dialogContext);
              onClose();
            }),
      ),
    );
  }

  static Future<void> showAccumulatorEstimateWiningCoin(
    BuildContext context, {
    required AccumulatorEstimateWinningResModel data,
    required VoidCallback onConfirm,
    required VoidCallback onClose,
    required Function(int id) onDeletePrediction,
    required List<PredictionFixtureModel> predictions,
    required num predictedCoin,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          onClose();
        },
        child: _AccumulatorEstimateWiningDialogWidget(
          initialData: data,
          onClose: () {
            closeDialog(dialogContext);
            onClose();
          },
          onConfirm: () {
            closeDialog(dialogContext);

            onConfirm();
          },
          onDeletePrediction: onDeletePrediction,
          predictions: predictions,
          predictedCoin: predictedCoin,
        ),
      ),
    );
  }

  static showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => _SupportDialogWidget(
        title: "ဝန်ဆောင်မှု ဖုန်း",
        message:
            "အောက်ပါဖုန်းနံပါတ်သည် BallXBet ၏ ဝန်ဆောင်မှုဖုန်းနံပါတ်ဖြစ်သည်။",
        phoneLabel: "နေ့စဉ်(၂၄) နာရီ ၊ ပိတ်ရက်မရှိ ဝန်ဆောင်ပေးနေပါသည်။",
        phoneNumber: "+959989414141",
        onClose: () {
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showRuleAndRegulationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _RuleAndRegulationDialogWidget(
        onClose: () {
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showCoinInCoinOutTutorial(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _CoinInCoinOutTutorialDialogWidget(
        onClose: () {
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showHowToOpenAccountTutorial(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _HowToOpenAccTutorialDialogWidget(
        onClose: () {
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showUpdatePinDialog(BuildContext context,
      {required Function(String currentPin, String newPin) onConfirm}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _UpdatePinDialog(
        onConfirm: (pin, newPin) {
          closeDialog(dialogContext);
          onConfirm(pin, newPin);
        },
      ),
    );
  }

  static showFinisedPredictFilterDialog(BuildContext context,
      {required Function(String startDate, String endData) onApply}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => _FinishedPredictFilterDialog(
              onApply: ({required endDate, required startDate}) {
                if (startDate != null && endDate != null) {
                  onApply(startDate, endDate);
                }
                closeDialog(dialogContext);
              },
            ));
  }

  static showSetPinAlert(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _SetPinCodeAlertDialog(onConfirm: () {
        closeDialog(dialogContext);
        context.pushNamed(RouteNames.user.setWithdrawPin);
      }),
    );
  }

  static showLanguageSelectDialog(
    BuildContext context, {
    String? selectedLanguage,
    Function(String)? onLanguageSelected,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _LanguageSelectDialogWidget(
        selectedLanguage: selectedLanguage ?? 'Myanmar',
        onLanguageSelected: (language) {
          if (onLanguageSelected != null) {
            onLanguageSelected(language);
          }
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showCoinHistoryFilter(
    BuildContext context, {
    required Function(String startDate, String endDate) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CoinHistoryFilterWidget(
        onApply: (startDate, endDate) {
          onApply(startDate, endDate);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  static showAgentCode(
    BuildContext context, {
    required String agentCode,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => _ShowAgentCodeWidget(
        agentCode: agentCode,
        onClose: () {
          closeDialog(dialogContext);
        },
      ),
    );
  }

  static showExpireMatchAlertDialog(BuildContext context,
      {required int expireMatchCount,
      required VoidCallback onClearCallback,
      required VoidCallback onCancelCallback}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => _ShowExpireMatchAlertDialog(
              expireMatchCount: expireMatchCount,
              onCancel: () {
                closeDialog(dialogContext);
                onClearCallback();
              },
              onContinue: () {
                closeDialog(dialogContext);
                onClearCallback();
              },
            ));
  }

  static showUpdateAlertDialog(BuildContext context,
      {required String description, required String donwloadLink}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => PopScope(
              canPop: false,
              child: _UpdateAlertDialog(
                  description: description, donwloadLink: donwloadLink),
            ));
  }
}
