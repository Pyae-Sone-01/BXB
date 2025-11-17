import 'package:bxb/features/auth/presentation/fill_information_screen.dart';
import 'package:bxb/features/auth/presentation/login_screen.dart';
import 'package:bxb/features/auth/presentation/login_with_password_screen.dart';
import 'package:bxb/features/auth/presentation/login_with_screen.dart';
import 'package:bxb/features/auth/presentation/otp_verify_screen.dart';
import 'package:bxb/features/auth/presentation/register_screen.dart';
import 'package:bxb/features/coin/coin_history/presentation/coin_history_screen.dart';
import 'package:bxb/features/coin/coin_in/presentation/coin_in_screen.dart';
import 'package:bxb/features/coin/coin_out/presentation/coin_out_screen.dart';
import 'package:bxb/features/coin/transfer_bff/presentation/transfer_bff_screen.dart';
import 'package:bxb/features/fixture/accumulator/presentation/accumulator_screen.dart';
import 'package:bxb/features/fixture/handicap/presentation/handicap_screen.dart';
import 'package:bxb/features/fixture/score/presentation/score_screen.dart';
import 'package:bxb/features/main/home/presentation/home_screen.dart';
import 'package:bxb/features/main/splash/presentation/splash_screen.dart';
import 'package:bxb/features/misc/notification/presentation/notification_detail_screen.dart';
import 'package:bxb/features/misc/notification/presentation/notification_screen.dart';
import 'package:bxb/features/prediction/finished_history/presentation/finished_history_screen.dart';
import 'package:bxb/features/prediction/history_detail/presentation/history_detail_screen.dart';
import 'package:bxb/features/prediction/on_going_history/presentation/on_going_history_screen.dart';
import 'package:bxb/features/prediction/share_accumulator_result/share_accumulator_result_screen.dart';
import 'package:bxb/features/prediction/share_handicap_result/share_handicap_result_screen.dart';
import 'package:bxb/services/misc/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/user/presentation/set_withdraw_pin_screen.dart'
    show SetWithdrawPinScreen;

class RouteNames {
  RouteNames._();
  static const mainMenu = "main-menu";
  static final main = _Main();
  static final auth = _Auth();
  static final fixture = _Fixture();
  static final prediciton = _Prediction();
  static final coin = _Coin();
  static final user = _User();
  static final misc = _Misc();
}

class _User {
  final String setWithdrawPin = "set-withdraw-pin";
}

class _Auth {
  final String login = "login";
  final String loginWith = "login-with";
  final String fillUserInfo = "fill-user-info";
  final String otpVerify = "otp-verify";
  final String loginWithPassword = "login-with-password";
  final String register = "register";
}

class _Main {
  final String splash = "splash_page";
  final String webView = "web-view";
  final String home = "home";
}

class _Fixture {
  final String handicap = "handicap";
  final String accumulator = "accumulator";
  final String score = "score";
}

class _Prediction {
  final String onGoingHistory = "on-going-history";
  final String finishedHistory = "finished-history";
  final String historyDetail = "history-detail";
  final String shareAccumulatorResult = "share_accumulator_result";
  final String shareHandicapResult = "share_handicap_result";
}

class _Coin {
  final String coinHistory = "coin-history";
  final String coinIn = "coin-in";
  final String coinOut = "coin-out";
  final String transferBff = "transfer-bff";
}

class _Misc {
  final String notification = "notification";
  final String notificationDetail = "notification_detail";
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final appRouter = GoRouter(observers: [
  routeObserver
], routes: [
  ..._mainRoutes,
  ..._authRoutes,
  ..._fixtureRoutes,
  ..._predictionRoutes,
  ..._coinRoutes,
  ..._miscRoute
], initialLocation: "/${RouteNames.main.splash}");

final _mainRoutes = [
  GoRoute(
      name: RouteNames.main.splash,
      path: "/${RouteNames.main.splash}",
      builder: (context, state) => SplashScreen()),
  GoRoute(
    name: RouteNames.main.home,
    path: "/${RouteNames.main.home}",
    builder: (context, state) => const HomeScreen(),
  ),
];

final _authRoutes = [
  GoRoute(
    name: RouteNames.auth.login,
    path: "/${RouteNames.auth.login}",
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RouteNames.auth.loginWith,
    path: "/${RouteNames.auth.loginWith}",
    builder: (context, state) => LoginWithScreen(
      isLoginWithPhone: state.extra as bool? ?? false,
      isLoginWithAtom:
          (state.uri.queryParameters["is_login_with_atom"]?.toLowerCase() ==
              'true'),
    ),
  ),
  GoRoute(
    name: RouteNames.auth.otpVerify,
    path: "/${RouteNames.auth.otpVerify}",
    builder: (context, state) => const OtpVerifyScreen(),
  ),
  GoRoute(
    name: RouteNames.auth.fillUserInfo,
    path: "/${RouteNames.auth.fillUserInfo}",
    builder: (context, state) => const FillUserInformationScreen(),
  ),
  GoRoute(
    name: RouteNames.auth.loginWithPassword,
    path: "/${RouteNames.auth.loginWithPassword}",
    builder: (context, state) => LoginWithPasswordScreen(
      phone: state.uri.queryParameters['phone'] ?? "",
      msg: state.uri.queryParameters['msg'] ?? "",
    ),
  ),
  GoRoute(
    name: RouteNames.auth.register,
    path: "/${RouteNames.auth.register}",
    builder: (context, state) => RegisterScreen(
      phone: state.uri.queryParameters['phone'] ?? "",
    ),
  ),
];

final _fixtureRoutes = [
  GoRoute(
    name: RouteNames.fixture.handicap,
    path: "/${RouteNames.fixture.handicap}",
    builder: (context, state) => const HandicapScreen(),
  ),
  GoRoute(
    name: RouteNames.fixture.accumulator,
    path: "/${RouteNames.fixture.accumulator}",
    builder: (context, state) => const AccumulatorScreen(),
  ),
  GoRoute(
    name: RouteNames.fixture.score,
    path: "/${RouteNames.fixture.score}",
    builder: (context, state) => const ScoreScreen(),
  ),
];

final _predictionRoutes = [
  GoRoute(
    name: RouteNames.prediciton.finishedHistory,
    path: "/${RouteNames.prediciton.finishedHistory}",
    builder: (context, state) => const FinishedHistoryScreen(),
  ),
  GoRoute(
    name: RouteNames.prediciton.onGoingHistory,
    path: "/${RouteNames.prediciton.onGoingHistory}",
    builder: (context, state) => const OnGoingHistoryScreen(),
  ),
  GoRoute(
    name: RouteNames.prediciton.historyDetail,
    path: "/${RouteNames.prediciton.historyDetail}",
    builder: (context, state) => HistoryDetailScreen(
      id: int.tryParse(state.uri.queryParameters["id"] ?? '') ?? 0,
    ),
  ),
  GoRoute(
    name: RouteNames.prediciton.shareAccumulatorResult,
    path: "/${RouteNames.prediciton.shareAccumulatorResult}",
    builder: (context, state) => ShareAccumulatorResultScreen(
      orderId: int.tryParse(state.uri.queryParameters["order_id"] ?? '') ?? 0,
    ),
  ),
  GoRoute(
    name: RouteNames.prediciton.shareHandicapResult,
    path: "/${RouteNames.prediciton.shareHandicapResult}",
    builder: (context, state) => ShareHandicapResultScreen(
      orderId: int.tryParse(state.uri.queryParameters["order_id"] ?? '') ?? 0,
    ),
  ),
];

final _coinRoutes = [
  GoRoute(
    name: RouteNames.coin.coinHistory,
    path: "/${RouteNames.coin.coinHistory}",
    builder: (context, state) => const CoinHistoryScreen(),
  ),
  GoRoute(
    name: RouteNames.coin.coinIn,
    path: "/${RouteNames.coin.coinIn}",
    builder: (context, state) => const CoinInScreen(),
  ),
  GoRoute(
    name: RouteNames.coin.coinOut,
    path: "/${RouteNames.coin.coinOut}",
    builder: (context, state) => const CoinOutScreen(),
  ),
  GoRoute(
    name: RouteNames.coin.transferBff,
    path: "/${RouteNames.coin.transferBff}",
    builder: (context, state) => const TransferBffScreen(),
  ),
  GoRoute(
    name: RouteNames.user.setWithdrawPin,
    path: "/${RouteNames.user.setWithdrawPin}",
    builder: (context, state) => const SetWithdrawPinScreen(),
  ),
];

final _miscRoute = [
  GoRoute(
    name: RouteNames.misc.notification,
    path: "/${RouteNames.misc.notification}",
    builder: (context, state) => const NotificationScreen(),
  ),
  GoRoute(
    name: RouteNames.misc.notificationDetail,
    path: "/${RouteNames.misc.notificationDetail}",
    builder: (context, state) => NotificationDetailScreen(
      data: state.extra as NotificationModel,
    ),
  ),
];
