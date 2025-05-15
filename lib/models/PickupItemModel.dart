class PickupItem {
  final int idDonationItem;
  final String name;
  final int coins;
  final int quantity; // Tambahkan jika diperlukan untuk UI

  PickupItem({
    required this.idDonationItem,
    required this.name,
    required this.coins,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_donationitem': idDonationItem,
      'name': name,
      'coins': coins,
      'quantity': quantity,
    };
  }
}