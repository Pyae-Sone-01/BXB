import 'package:bxb/features/auth/presentation/fill_information_screen.dart';
import 'package:bxb/features/auth/presentation/login_screen.dart';
import 'package:bxb/features/auth/presentation/login_with_screen.dart';
import 'package:bxb/features/auth/presentation/otp_verify_screen.dart';
import 'package:bxb/features/coin/coin_history/presentation/coin_history_screen.dart';
import 'package:bxb/features/coin/coin_in/presentation/coin_in_screen.dart';
import 'package:bxb/features/coin/coin_out/presentation/coin_out_screen.dart';
import 'package:bxb/features/fixture/accumulator/presentation/accumulator_screen.dart';
import 'package:bxb/features/fixture/handicap/presentation/handicap_screen.dart';
import 'package:bxb/features/fixture/score/presentation/score_screen.dart';
import 'package:bxb/features/main/home/presentation/home_screen.dart';
import 'package:bxb/features/main/splash/presentation/splash_screen.dart';
import 'package:bxb/features/prediction/finished_history/presentation/finished_history_screen.dart';
import 'package:bxb/features/prediction/history_detail/presentation/history_detail_screen.dart';
import 'package:bxb/features/prediction/on_going_history/presentation/on_going_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  RouteNames._();
  static const mainMenu = "main-menu";
  static final main = _Main();
  static final auth = _Auth();
  static final fixture = _Fixture();
  static final prediciton = _Prediction();
  static final coin = _Coin();
}

class _Auth {
  final String login = "login";
  final String loginWith = "login-with";
  final String fillUserInfo = "fill-user-info";
  final String otpVerify = "otp-verify";
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
}

class _Coin {
  final String coinHistory = "coin-history";
  final String coinIn = "coin-in";
  final String coinOut = "coin-out";
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final appRouter = GoRouter(observers: [
  routeObserver
], routes: [
  ..._mainRoutes,
  ..._authRoutes,
  ..._fixtureRoutes,
  ..._predictionRoutes,
  ..._coinRoutes,
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
];
