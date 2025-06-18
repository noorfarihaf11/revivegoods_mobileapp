import 'package:flutter/material.dart';
import 'set_address_screen.dart';
import '../utils/app_colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:revivegoods/api_url.dart';
import 'package:revivegoods/providers/donation_provider.dart';
import 'package:revivegoods/global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String _selectedCategory = 'Clothes';

  @override
  void initState() {
    super.initState();
    getDonateScreen();
  }


  Future<void> getDonateScreen() async {
    try {
      // Load token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      Global.access_token = prefs.getString('access_token') ?? '';

      if (Global.access_token.isEmpty) {
        // Kalau token kosong, kasih info error dan return
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please login first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Request ke API dengan token di header Authorization
      final itemdonate = await http.get(
        Uri.parse("${ApiUrl.GetItemUrl}"),
        headers: {
          'Authorization': 'Bearer ${Global.access_token}',
          'Accept': 'application/json',
        },
      );

      final itemData = json.decode(itemdonate.body);

      if (itemdonate.statusCode == 200) {
        List<dynamic> items = itemData['items'];

        if (items.isEmpty) {
          Global.message = "Data Barang Kosong";
        } else {
          final donationProvider = Provider.of<DonationProvider>(
              context, listen: false);
          donationProvider.setItemsFromApi(items);

          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load items. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  // Update the quantity of an item
  void _updateQuantity(BuildContext context, String item, int change) {
    final provider = Provider.of<DonationProvider>(context, listen: false);
    provider.updateQuantity(item, change);
  }

  // Check if any item has a quantity greater than 0
  bool get _hasSelectedItems {
    final provider = Provider.of<DonationProvider>(context);
    return provider.hasSelectedItems;
  }

  List<Map<String, dynamic>> get _selectedItems {
    final provider = Provider.of<DonationProvider>(context);
    return provider.selectedItems;
  }

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    return Column(
      children: [
        // Category tabs
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildCategoryTab('Clothes'),
              _buildCategoryTab('Toys'),
              _buildCategoryTab('Others'),
            ],
          ),
        ),

        // Items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: donationProvider.categorizedItems[_selectedCategory]
                ?.length ?? 0,
            separatorBuilder: (context, index) =>
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final item = donationProvider
                  .categorizedItems[_selectedCategory]![index];
              final itemName = item['name'];
              return _buildDonationItem(itemName);
            },
          ),
        ),

        // Set Address button - only show if items are selected
        if (_hasSelectedItems)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 47,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to set address screen with selected items
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SetAddressScreen(
                            selectedItems: _selectedItems,
                          ),
                    ),
                  );
                },
                child: const Text(
                  'Set Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Build a category tab
  Widget _buildCategoryTab(String category) {
    bool isSelected = _selectedCategory == category;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Build a donation item
  Widget _buildDonationItem(String itemName) {
    final provider = Provider.of<DonationProvider>(context);
    final quantity = provider.quantities[itemName] ?? 0;
    final coin = provider.getCoin(itemName);

    // Ambil URL gambar dari data item
    String imagePath = ''; // Ambil URL gambar dari data item

    // Misalnya, jika data item memiliki key 'image_url'
    final itemData = provider.categorizedItems[_selectedCategory]?.firstWhere(
          (item) => item['name'] == itemName,
      orElse: () => {}, // Kembalikan Map kosong jika item tidak ditemukan
    );

    if (itemData!.isNotEmpty) {
      imagePath = itemData['image'] ?? ''; // Menyimpan URL gambar dari data
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Menampilkan gambar dari path lokal
          imagePath.isNotEmpty
              ? Image.asset(
            imagePath, // Path lokal di dalam folder 'assets'
            width: 75,
            height: 75,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                  Icons.error); // Menampilkan ikon jika gambar gagal dimuat
            },
          )
              : const Icon(Icons.image),
          // Menampilkan ikon jika URL gambar kosong
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              itemName,
              maxLines: 2, // Biar bisa turun satu baris kalau terlalu panjang
              overflow: TextOverflow.ellipsis, // Atau bisa diganti `TextOverflow.fade`
              softWrap: true,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.coinColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$coin',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              InkWell(
                onTap: () => _updateQuantity(context, itemName, -1),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _updateQuantity(context, itemName, 1),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}