import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'trade_confirmation_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;

  // Additional product images for carousel
  List<String> get _productImages => [
    widget.product['image'] ?? 'images/eco_placeholder.png',
  ];

  @override
  Widget build(BuildContext context) {
    // Enhance product data for trade confirmation
    final completeProduct = {
      ...widget.product,
      'id_exchangeitem': widget.product['id_exchangeitem'], // Preserve id_exchangeitem
      'rating': widget.product['rating'] ?? 4.8,
      'reviews': widget.product['reviews'] ?? 120,
      'inStock': widget.product['stock'] > 0, // Use stock from API
      'category': _getCategoryFromProduct(widget.product['name']),
      'features': _getFeaturesFromProduct(widget.product['name']),
      'image': widget.product['image'], // Use 'image' instead of 'logo'
      'coin_cost': widget.product['coin_cost'], // Ensure consistency with API
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App bar with product images
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[50],
                child: Column(
                  children: [
                    const SizedBox(height: 80), // Space for app bar
                    // Product image carousel
                    Expanded(
                      child: PageView.builder(
                        itemCount: _productImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Image.asset(
                                _productImages[index],
                                height: 200,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image ${_productImages[index]}: $error');
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.eco,
                                      size: 80,
                                      color: AppColors.primary.withOpacity(0.5),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Image indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _productImages.length,
                            (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedImageIndex == index
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Product details
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name and rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product['name'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product['brand'] ?? 'Eco Brand', // Fallback for brand
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${completeProduct['rating']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${completeProduct['reviews']})',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Price section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: Colors.amber,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Trade with Eco Coins',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              Text(
                                '${widget.product['coin_cost']} Coins', // Use coin_cost
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Consumer<UserProvider>(
                            builder: (context, userProvider, child) {
                              final userCoins = userProvider.user?.coins ?? 0;
                              final canAfford = userCoins >= widget.product['coin_cost'];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Your Balance',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                  Text(
                                    '$userCoins Coins',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: canAfford ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Features
                    const Text(
                      'Key Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...(_getFeaturesFromProduct(widget.product['name']).map((feature) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ).toList()),

                    const SizedBox(height: 24),

                    // Environmental Impact
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.eco,
                                color: Colors.green[700],
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Environmental Impact',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildImpactItem(
                            icon: Icons.recycling,
                            title: 'Reduces Waste',
                            description: 'Replaces single-use items and reduces environmental waste',
                          ),
                          const SizedBox(height: 8),
                          _buildImpactItem(
                            icon: Icons.nature,
                            title: 'Sustainable Materials',
                            description: 'Made from renewable and eco-friendly materials',
                          ),
                          const SizedBox(height: 8),
                          _buildImpactItem(
                            icon: Icons.co2,
                            title: 'Lower Carbon Footprint',
                            description: 'Production process creates fewer greenhouse gas emissions',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Reviews section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Customer Reviews',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to reviews page
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sample review
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary.withOpacity(0.2),
                                child: Text(
                                  'A',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Anonymous User',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) =>
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: index < 5 ? Colors.amber : Colors.grey[300],
                                          ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Great quality product! Really helps reduce my environmental impact. Highly recommended for anyone looking to live more sustainably.',
                            style: TextStyle(
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom trade button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final userCoins = userProvider.user?.coins ?? 0;
            final canAfford = userCoins >= widget.product['coin_cost'];

            return SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: canAfford ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TradeConfirmationScreen(product: completeProduct),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? AppColors.primary : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: canAfford ? 4 : 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      canAfford ? 'Trade Now' : 'Insufficient Coins',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImpactItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.green[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.green[700],
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryFromProduct(String productName) {
    if (productName.toLowerCase().contains('bag') || productName.toLowerCase().contains('tote')) {
      return 'Bags';
    } else if (productName.toLowerCase().contains('bottle') || productName.toLowerCase().contains('water')) {
      return 'Bottles';
    } else if (productName.toLowerCase().contains('charger') || productName.toLowerCase().contains('solar')) {
      return 'Electronics';
    } else if (productName.toLowerCase().contains('straw') || productName.toLowerCase().contains('cutlery')) {
      return 'Kitchen';
    } else {
      return 'Eco Products';
    }
  }

  List<String> _getFeaturesFromProduct(String productName) {
    if (productName.toLowerCase().contains('straw')) {
      return [
        'Set of 4 reusable bamboo straws',
        'Includes cleaning brush',
        'Biodegradable and compostable',
        'Perfect for hot and cold drinks',
        'Portable carrying case included'
      ];
    } else if (productName.toLowerCase().contains('bag') || productName.toLowerCase().contains('tote')) {
      return [
        '100% recycled materials',
        'Durable and long-lasting',
        'Machine washable',
        'Large capacity design',
        'Reinforced handles'
      ];
    } else if (productName.toLowerCase().contains('charger') || productName.toLowerCase().contains('solar')) {
      return [
        'Solar-powered charging',
        '10000mAh battery capacity',
        'Waterproof design',
        'Multiple device compatibility',
        'LED power indicator'
      ];
    } else if (productName.toLowerCase().contains('bottle') || productName.toLowerCase().contains('water')) {
      return [
        'BPA-free materials',
        'Leak-proof design',
        'Keeps drinks cold for 24 hours',
        'Easy-clean wide mouth',
        'Eco-friendly bamboo cap'
      ];
    } else {
      return [
        'Eco-friendly materials',
        'Sustainable production',
        'Reduces environmental impact',
        'High-quality construction',
        'Long-lasting durability'
      ];
    }
  }
}