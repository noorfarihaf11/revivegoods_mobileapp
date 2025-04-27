import 'package:flutter/material.dart';
import 'set_address_screen.dart';
import '../utils/app_colors.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key? key}) : super(key: key);

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String _selectedCategory = 'Clothes';

  // Item quantities
  Map<String, int> quantities = {
    'baby clothes': 0,
    'jacket': 0,
    'shirt': 0,
    'shoes': 0,

    // Toys
    'teddy bear': 0,
    'car': 0,

    // Others
    'books': 0,
    'kitchenware': 0,
    'electronics': 0,
  };

  // Item points
  Map<String, int> points = {
    'baby clothes': 20,
    'jacket': 75,
    'shirt': 50,
    'shoes' : 60,

    // Toys
    'teddy bear': 30,
    'car': 35,

    // Others
    'books': 15,
    'kitchenware': 45,
    'electronics': 100,
  };

  // Items in each category
  Map<String, List<String>> categoryItems = {
    'Clothes': ['baby clothes', 'jacket', 'shirt', 'shoes'],
    'Toys': ['teddy bear', 'car'],
    'Others': ['books', 'kitchenware', 'electronics'],
  };

  // Update the quantity of an item
  void _updateQuantity(String item, int change) {
    setState(() {
      quantities[item] = (quantities[item] ?? 0) + change;
      if (quantities[item]! < 0) {
        quantities[item] = 0;
      }
    });
  }

  // Check if any item has a quantity greater than 0
  bool get _hasSelectedItems {
    return quantities.values.any((quantity) => quantity > 0);
  }

  // Get selected items for order summary
  List<Map<String, dynamic>> get _selectedItems {
    List<Map<String, dynamic>> items = [];
    quantities.forEach((item, quantity) {
      if (quantity > 0) {
        items.add({
          'name': item,
          'quantity': quantity,
          'coins': points[item] ?? 0,
        });
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: categoryItems[_selectedCategory]?.length ?? 0,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.divider,
            ),
            itemBuilder: (context, index) {
              final itemName = categoryItems[_selectedCategory]![index];
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
                      builder: (context) => SetAddressScreen(
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Item icon with colored background
          Container(
            width: 75,
            height: 75,
            child: Center(
              child: _getItemImage(itemName),
            ),
          ),
          const SizedBox(width: 16),

          // Item name
          Text(
            itemName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),

          const Spacer(),

          // Points
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.coinColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${points[itemName]}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Quantity selector
          Row(
            children: [
              InkWell(
                onTap: () => _updateQuantity(itemName, -1),
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
                  '${quantities[itemName]}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _updateQuantity(itemName, 1),
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

  // Get the image for an item
  Widget _getItemImage(String itemName) {
    String imagePath;

    // Different image paths based on category
    if (categoryItems['Clothes']?.contains(itemName) ?? false) {
      switch (itemName) {
        case 'baby clothes':
          imagePath = 'images/onesie.png';
          break;
        case 'jacket':
          imagePath = 'images/jacket.png';
          break;
        case 'shirt':
          imagePath = 'images/tshirt.png';
          break;
        case 'shoes':
          imagePath = 'images/shoes.png';
          break;
        default:
          imagePath = 'images/default.png';
      }
    } else if (categoryItems['Toys']?.contains(itemName) ?? false) {
      switch (itemName) {
        case 'teddy bear':
          imagePath = 'images/cute.png';
          break;
        case 'car':
          imagePath = 'images/sport-car.png';
          break;
        default:
          imagePath = 'images/default.png';
      }
    } else {
      switch (itemName) {
        case 'books':
          imagePath = 'images/stack-of-books.png';
          break;
        case 'kitchenware':
          imagePath = 'images/kitchenware.png';
          break;
        case 'electronics':
          imagePath = 'images/gadget.png';
          break;
        default:
          imagePath = 'images/default.png';
      }
    }

    return Image.asset(
      imagePath,
      width: 75,
      height: 75,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image for $itemName: $error');
        // Fallback to a simple colored box if image fails to load
        return Container(
          width: 32,
          height: 32,
        );
      },
    );
  }
}
