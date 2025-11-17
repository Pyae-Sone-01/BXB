import 'package:bxb/datasources/services/local/local_storage_service.dart';
import 'package:bxb/router/router.dart';
import 'package:bxb/services/auth/auth_service.dart';
import 'package:bxb/services/auth/providers/auth_service_provider.dart';
import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/user/models/user_model.dart';
import 'package:bxb/services/user/providers/user_service_provider.dart';
import 'package:bxb/services/user/user_service.dart';
import 'package:bxb/utils/common/dialog_manager/dialog_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
part 'home_view_model.g.dart';

abstract class HomeViewModel {
  void logout(BuildContext context);
  void updateAgentCode(BuildContext context, {required String value});
  void updateWidthdrawPin(BuildContext context,
      {required String currentPin, required String newPin});

  void showRuleAndRegulationDialog(
    BuildContext context,
  );

  void setLanguage({required String lan});
}

class HomeState {
  final bool isLoading;
  final num? myCoin;
  final BffCoinModel? bffCoin;
  final UserModel? userData;
  final String language;

  HomeState(
      {this.isLoading = false,
      this.myCoin,
      this.bffCoin,
      this.userData,
      this.language = "mm"});

  HomeState copyWith({
    bool? isLoading,
    num? myCoin,
    BffCoinModel? bffCoin,
    UserModel? userData,
    String? language,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      myCoin: myCoin ?? this.myCoin,
      bffCoin: bffCoin ?? this.bffCoin,
      userData: userData ?? this.userData,
      language: language ?? this.language,
    );
  }
}

@riverpod
class HomeViewModelImpl extends _$HomeViewModelImpl implements HomeViewModel {
  late final AuthService _authService = ref.read(authServiceProvider);
  late final CoinService _coinService = ref.read(coinServiceProvider);
  late final UserService _userService = ref.read(userServiceProvider);

  @override
  HomeState build() {
    return HomeState();
  }

  @override
  void logout(BuildContext context) {
    _authService.logout();
    context.goNamed(RouteNames.auth.login);
  }

  Future<void> initializeData() async {
    final lan = LocalStorageServices.getData(LocalStorageKey.language);
    if (lan.isNotEmpty) {
      setLanguage(lan: lan);
    }

    state = state.copyWith(isLoading: true);
    final results = await Future.wait([
      _coinService.myCoin(),
      _coinService.getBffCoin(),
      _userService.me(),
    ]);
    final myCoinResult = results[0];
    final bffCoinResult = results[1];
    final userResult = results[2];
    state = state.copyWith(
      isLoading: false,
      myCoin: myCoinResult.isSuccess ? myCoinResult.data as num? : null,
      bffCoin:
          bffCoinResult.isSuccess ? bffCoinResult.data as BffCoinModel? : null,
      userData: userResult.isSuccess ? userResult.data as UserModel? : null,
    );
  }

  @override
  void updateAgentCode(BuildContext context, {required String value}) async {
    DialogManger.showLoading(context);
    final res = await _userService.updateAgentCode({"agent_code": value});

    DialogManger.closeDialog(context);

    initializeData();

    DialogManger.showAutoCloseResultDialog(context,
        isSuccess: res.isSuccess,
        description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
  }

  @override
  void updateWidthdrawPin(BuildContext context,
      {required String currentPin, required String newPin}) async {
    DialogManger.showLoading(context);
    final res = await _userService
        .updateWidthdrawPin({"current_pin": currentPin, "new_pin": newPin});

    DialogManger.closeDialog(context);
    DialogManger.showAutoCloseResultDialog(context,
        isSuccess: res.isSuccess,
        description: res.isSuccess ? res.msg ?? "" : res.error ?? "");
  }

  @override
  void showRuleAndRegulationDialog(BuildContext context) {
    final isNotFirstTimeUser =
        LocalStorageServices.getBoolData(LocalStorageKey.isNotFirstTimeUser);
    if (!isNotFirstTimeUser) {
      DialogManger.showRuleAndRegulationDialog(context);
      LocalStorageServices.setBoolData(
          LocalStorageKey.isNotFirstTimeUser, true);
    }
  }

  @override
  void setLanguage({required String lan}) {
    print(lan);
    LocalStorageServices.setData(LocalStorageKey.language, lan);
    state = state.copyWith(language: lan);
  }
}
