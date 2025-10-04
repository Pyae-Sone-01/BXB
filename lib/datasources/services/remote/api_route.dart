class ApiRoute {
  ApiRoute._();
  // Use your local network IP (e.g., 192.168.1.100) instead of localhost for mobile device access
  static const String baseUrl = 'https://football-api.cactusminds.com/api/v1';

  static const String socketUrl = "http://192.168.2.101:4000";
  static final misc = _Misc();
  static final auth = _Authentication();
  static final user = _User();
  static final coin = _Coin();
  static final fixture = _Fixture();
  static final prediction = _Prediction();
}

class _Misc {}

class _Authentication {
  final String userLogin = "/login";
  final String userLoginVerify = "/verify";

  /////
  final String loginWithBff = "/auth/login-with-bff";
  final String getOtp = "/auth/get-otp";

  final String verifyOtp = "/auth/verify-otp";
  final String register = "/auth/register";
}

class _Coin {
  final String myCoin = "/coins/my-coin";
  final String bankInfoForDeposit = "/coins/bank-info-for-deposit";
  final String bankInfoForWithdraw = "/coins/bank-info-for-withdraw";
  final String bffCoin = "/coins/get-coin-from-bff";
  final String coinHistories = "/coins/histories";
  final String depositCoin = "/coins/deposit";
  final String withdraw = "/coins/withdraw";
}

class _User {
  final String me = "/users/me";
  final String updateAgent = "/users/update-agent";
  final String setUpWidthdrawPin = "/users/setup-pin";
  final String updateWidthdrawPin = "/users/update-pin";
}

class _Fixture {
  final String getAllLeagues = "/leagues/all";
  final String getHandicapFixture = "/fixtures/for-handicap";
  final String getAccumulatorFixture = "/fixtures/for-accumulator";
  final String getScoreForFixture = "/fixtures/for-score";
}

class _Prediction {
  final String onGoingHistory = "/predictions/on-going-histories";
  final String finishedHistory = "/predictions/finished-histories";
  final String historyDetail = "/predictions/history";
  final String handicapEstimateWinning =
      "/predictions/handicap-estimated-winning";
  final String handicapPrediction = "/predictions/handicap";
}
