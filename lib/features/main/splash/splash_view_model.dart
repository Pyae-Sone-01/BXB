import 'package:bxb/router/router.dart';
import 'package:bxb/services/auth/auth_service.dart';
import 'package:bxb/services/auth/providers/auth_service_provider.dart';
import 'package:bxb/services/misc/misc_service.dart';
import 'package:bxb/services/misc/providers/misc_service_provider.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'splash_view_model.g.dart';

abstract class SplashViewModel {
  Future<void> initializedData(BuildContext context);
}

@riverpod
class SplashViewModelImpl extends _$SplashViewModelImpl
    implements SplashViewModel {
  late final AuthService _authService = ref.read(authServiceProvider);
  late final MiscService _miscService = ref.read(miscServiceProvider);
  @override
  void build() {}

  void _navigateToNextScreen(BuildContext context) {
    if (_authService.hasAuth()) {
      context.goNamed(RouteNames.main.home);
    } else {
      context.goNamed(RouteNames.auth.login);
    }
  }

  @override
  Future<void> initializedData(BuildContext context) async {
    final res = await _miscService.checkForUpdate();
    if (res.isSuccess) {
      await DialogManger.showUpdateAlertDialog(context,
          description: res.data?.details ?? "",
          donwloadLink: res.data?.url ?? "");
    } else {
      _navigateToNextScreen(context);
    }
  }
}
