import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'trade_confirmation_screen.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String _selectedCategory = 'All';

  // Sample eco products for trading
  final List<Map<String, dynamic>> _ecoProducts = [
    {
      'id': 'eco_001',
      'name': 'Eco Tote Bag',
      'description': 'Reusable cotton tote bag made from organic materials',
      'image': 'images/tote_bag.png',
      'coins': 150,
      'category': 'Bags',
      'inStock': true,
      'rating': 4.8,
      'reviews': 124,
      'features': ['100% Organic Cotton', 'Machine Washable', 'Durable'],
    },
    {
      'id': 'eco_002',
      'name': 'Bamboo Water Bottle',
      'description': 'Sustainable bamboo water bottle with stainless steel interior',
      'image': 'images/bamboo_bottle.png',
      'coins': 200,
      'category': 'Bottles',
      'inStock': true,
      'rating': 4.9,
      'reviews': 89,
      'features': ['BPA Free', 'Leak Proof', 'Eco-Friendly'],
    },
    {
      'id': 'eco_003',
      'name': 'Solar Power Bank',
      'description': 'Portable solar charger for eco-friendly energy on the go',
      'image': 'images/solar_powerbank.png',
      'coins': 350,
      'category': 'Electronics',
      'inStock': true,
      'rating': 4.7,
      'reviews': 67,
      'features': ['Solar Powered', '10000mAh', 'Waterproof'],
    },
    {
      'id': 'eco_004',
      'name': 'Reusable Food Wraps',
      'description': 'Beeswax food wraps set - plastic-free food storage',
      'image': 'images/food_wraps.png',
      'coins': 120,
      'category': 'Kitchen',
      'inStock': true,
      'rating': 4.6,
      'reviews': 156,
      'features': ['Plastic Free', 'Reusable', 'Natural Beeswax'],
    },
    {
      'id': 'eco_005',
      'name': 'Bamboo Cutlery Set',
      'description': 'Portable bamboo cutlery set with carrying case',
      'image': 'images/bamboo_cutlery.png',
      'coins': 80,
      'category': 'Kitchen',
      'inStock': true,
      'rating': 4.5,
      'reviews': 203,
      'features': ['Portable', 'Dishwasher Safe', 'Includes Case'],
    },
    {
      'id': 'eco_006',
      'name': 'Organic Cotton T-Shirt',
      'description': 'Soft organic cotton t-shirt with eco-friendly dyes',
      'image': 'images/organic_tshirt.png',
      'coins': 180,
      'category': 'Clothing',
      'inStock': false,
      'rating': 4.8,
      'reviews': 91,
      'features': ['Organic Cotton', 'Fair Trade', 'Eco Dyes'],
    },
    {
      'id': 'eco_007',
      'name': 'Seed Paper Notebook',
      'description': 'Plantable notebook made from recycled paper with seeds',
      'image': 'images/seed_notebook.png',
      'coins': 100,
      'category': 'Stationery',
      'inStock': true,
      'rating': 4.4,
      'reviews': 78,
      'features': ['Plantable', 'Recycled Paper', 'Wildflower Seeds'],
    },
    {
      'id': 'eco_008',
      'name': 'Cork Yoga Mat',
      'description': 'Natural cork yoga mat with rubber base',
      'image': 'images/cork_yoga_mat.png',
      'coins': 280,
      'category': 'Fitness',
      'inStock': true,
      'rating': 4.9,
      'reviews': 45,
      'features': ['Natural Cork', 'Non-Slip', 'Antimicrobial'],
    },
  ];

  final List<String> _categories = ['All', 'Bags', 'Bottles', 'Electronics', 'Kitchen', 'Clothing', 'Stationery', 'Fitness'];

  // Filter products based on selected category
  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _ecoProducts;
    }
    return _ecoProducts.where((product) => product['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trade Eco Coins',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with user coins
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Your Eco Coins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '450',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Category filter
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.grey[600],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Products grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final bool inStock = product['inStock'];

    return GestureDetector(
      onTap: () {
        if (inStock) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TradeConfirmationScreen(product: product),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This item is currently out of stock'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Colors.grey[100],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        product['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.eco,
                            size: 60,
                            color: AppColors.primary.withOpacity(0.5),
                          );
                        },
                      ),
                    ),

                    // Stock status
                    if (!inStock)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Rating
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Reviews count
                    Text(
                      '${product['reviews']} reviews',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),

                    const Spacer(),

                    // Price in coins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product['coins']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: inStock ? AppColors.primary : Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        // Trade button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: inStock ? AppColors.primary : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            inStock ? 'Trade' : 'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
