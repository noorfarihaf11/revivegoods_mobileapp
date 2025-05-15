import 'PickupItemModel.dart';

class PickupRequest {
  final int userId;
  final List<PickupItem> items;
  final String scheduledAt;
  final String address;
  final int totalCoins;

  PickupRequest({
    required this.userId,
    required this.items,
    required this.scheduledAt,
    required this.address,
    required this.totalCoins,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_user': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'scheduled_at': scheduledAt,
      'address': address,
      'total_coins': totalCoins,
    };
  }
}
