import 'package:flutter/cupertino.dart';

class DonationProvider with ChangeNotifier {
  Map<String, int> _quantities = {};
  Map<String, int> _coins = {};
  List<String> _itemNames = [];
  Map<String, List<Map<String, dynamic>>> _categorizedItems = {};

  Map<String, int> get quantities => _quantities;
  Map<String, int> get coins => _coins;
  List<String> get itemNames => _itemNames;
  Map<String, List<Map<String, dynamic>>> get categorizedItems => _categorizedItems;

  void updateQuantity(String item, int change) {
    _quantities[item] = (_quantities[item] ?? 0) + change;
    if (_quantities[item]! < 0) _quantities[item] = 0;
    notifyListeners();
  }

  int getCoin(String item) => _coins[item] ?? 0;

  List<Map<String, dynamic>> get selectedItems => _quantities.entries
      .where((e) => e.value > 0)
      .map((e) => {
    'name': e.key,
    'quantity': e.value,
    'coins': _coins[e.key] ?? 0,
  })
      .toList();

  bool get hasSelectedItems => _quantities.values.any((q) => q > 0);

  // ✅ Function to set items from API response
  void setItemsFromApi(List<dynamic> apiItems) {
    _coins.clear();
    _itemNames.clear();
    _categorizedItems.clear();

    for (var item in apiItems) {
      final name = item['name'];
      final coinValue = int.tryParse(item['coins'].toString()) ?? 0;
      final category = item['category_name'] ?? 'Others';
      final image = item['image']; // Assume image_url is present in the API response

      _coins[name] = coinValue;
      _quantities[name] = 0;
      _itemNames.add(name);

      // Categorize items by category
      if (_categorizedItems[category] == null) {
        _categorizedItems[category] = [];
      }
      // Add image_url along with other item data
      _categorizedItems[category]!.add({
        'name': name,
        'image': image,
        'coins': coinValue,
        'category_name': category,
      });
    }

    notifyListeners();
  }
}
