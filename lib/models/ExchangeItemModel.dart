class ExchangeItem {
  final int id_exchangeitem;
  final String name;
  final String description;
  final String image;
  final int coin_cost;
  final int stock;

  ExchangeItem({
    required this.id_exchangeitem,
    required this.name,
    required this.description,
    required this.image,
    required this.coin_cost,
    required this.stock,
  });

  factory ExchangeItem.fromJson(Map<String, dynamic> json) {
    return ExchangeItem(
      id_exchangeitem: json['id_exchangeitem'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      coin_cost: json['coin_cost'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_exchangeitem': id_exchangeitem,
      'name': name,
      'description': description,
      'image': image,
      'coin_cost': coin_cost,
      'stock': stock,
    };
  }
}
