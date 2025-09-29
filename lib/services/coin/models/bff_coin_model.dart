class BffCoinModel {
  int? coin;
  String? coinCurrency;

  BffCoinModel({this.coin, this.coinCurrency});

  BffCoinModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    coinCurrency = json['coin_currency'];
  }
}
