import 'package:bxb/services/result_model.dart';
import 'package:bxb/services/user/user_service.dart';
import 'package:bxb/services/user/providers/user_service_provider.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_withdraw_pin_view_model.g.dart';

@riverpod
class SetWithdrawPinViewModel extends _$SetWithdrawPinViewModel {
  late final UserService _userService;

  @override
  void build() {
    _userService = ref.read(userServiceProvider);
  }

  setupWithdrawPin(BuildContext context, String pin) async {
    DialogManger.showLoading(context);
    final res = await _userService.setUpWidthdrawPin({"pin": pin});
    DialogManger.closeDialog(context);
    final isSuccess = res.isSuccess;
    DialogManger.showAutoCloseResultDialog(
      context,
      isSuccess: isSuccess,
      description: isSuccess ? res.msg ?? "" : res.error ?? "",
      onComplete: () {
        if (isSuccess) {
          context.pop();
        }
      },
    );
  }
}
