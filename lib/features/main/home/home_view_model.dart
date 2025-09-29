import 'package:bxb/router/router.dart';
import 'package:bxb/services/auth/auth_service.dart';
import 'package:bxb/services/auth/providers/auth_service_provider.dart';
import 'package:bxb/services/coin/coin_service.dart';
import 'package:bxb/services/user/models/user_model.dart';
import 'package:bxb/services/user/providers/user_service_provider.dart';
import 'package:bxb/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/coin/providers/coin_service_provider.dart';
import 'package:bxb/services/coin/models/bff_coin_model.dart';
part 'home_view_model.g.dart';

abstract class HomeViewModel {
  void logout(BuildContext context);
}

class HomeState {
  final bool isLoading;
  final num? myCoin;
  final BffCoinModel? bffCoin;
  final UserModel? userData;

  HomeState({this.isLoading = false, this.myCoin, this.bffCoin, this.userData});

  HomeState copyWith({
    bool? isLoading,
    num? myCoin,
    BffCoinModel? bffCoin,
    UserModel? userData,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      myCoin: myCoin ?? this.myCoin,
      bffCoin: bffCoin ?? this.bffCoin,
      userData: userData ?? this.userData,
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
}
