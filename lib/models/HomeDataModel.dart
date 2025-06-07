import 'package:revivegoods/models/UserModel.dart';
import 'package:revivegoods/models/ExchangeItemModel.dart';

class HomeData {
  final UserModel user;
  final List<ExchangeItem> exchangeItems;

  HomeData({required this.user, required this.exchangeItems});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      user: UserModel.fromJson(json['user']),
      exchangeItems: List<ExchangeItem>.from(
        json['exchange_items'].map((item) => ExchangeItem.fromJson(item)),
      ),
    );
  }
}
