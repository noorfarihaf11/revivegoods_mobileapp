import 'package:flutter/material.dart';
import 'donate_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:revivegoods/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  bool _isDarkMode = false;

  final List<Widget> _screens = [
    const HomeContent(),
    const DonateScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Donate Items',
    'History',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated. Please login first.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUserData(token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidIndex = _selectedIndex >= 0 && _selectedIndex < _titles.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isValidIndex ? _titles[_selectedIndex] : '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: isValidIndex ? _screens[_selectedIndex] : const Center(child: Text('Halaman tidak ditemukan')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentCarouselIndex = 0;

  // Track favorite products
  final Set<String> _favoriteProducts = {};

  final List<Map<String, dynamic>> _newsItems = [
    {
      'title': 'Reuse Old Clothes to Reduce Waste',
      'description': 'Learn how to transform your old clothes into new useful items.',
      'image': 'images/joy.jpg',
      'color': AppColors.primary,
    },
    {
      'title': 'Plastic-Free Living Guide',
      'description': 'Simple steps to reduce plastic usage in your daily life.',
      'image': 'images/donate.webp',
      'color': AppColors.secondary,
    },
  ];

  // Updated eco-green products with more details
  final List<Map<String, dynamic>> _ecoProducts = [
    {
      'id': 'bamboo_utensil_set',
      'name': 'Bamboo Utensil Set',
      'logo': 'images/bamboo_utensil.jpg',
      'coins': 250,
      'brand': 'EcoLiving',
      'category': 'Home & Living',
      'description': 'Portable and reusable bamboo utensils with carrying case.',
      'rating': 4.5,
      'reviews': 28,
      'isNew': true,
    },
    {
      'id': 'recycled_tote',
      'name': 'Recycled Tote Bag',
      'logo': 'images/tote_bag.png',
      'coins': 150,
      'brand': 'GreenCycle',
      'category': 'Fashion',
      'description': 'Durable tote bag made from recycled plastic bottles.',
      'rating': 4.8,
      'reviews': 42,
      'isNew': false,
    },
    {
      'id': 'solar_charger',
      'name': 'Solar Phone Charger',
      'logo': 'images/solar_charger.png',
      'coins': 350,
      'brand': 'SunPower',
      'category': 'Electronics',
      'description': 'Portable solar-powered phone charger for eco-friendly charging.',
      'rating': 4.2,
      'reviews': 15,
      'isNew': true,
    },
    {
      'id': 'water_bottle',
      'name': 'Eco-Friendly Water Bottle',
      'logo': 'images/water_bottle.png',
      'coins': 200,
      'brand': 'PureEco',
      'category': 'Home & Living',
      'description': 'Stainless steel water bottle with bamboo cap.',
      'rating': 4.7,
      'reviews': 36,
      'isNew': false,
    },
    {
      'id': 'beeswax_wraps',
      'name': 'Beeswax Food Wraps',
      'logo': 'images/beeswax_wraps.jpg',
      'coins': 180,
      'brand': 'NaturalWrap',
      'category': 'Kitchen',
      'description': 'Reusable beeswax food wraps, plastic-free alternative to cling film.',
      'rating': 4.6,
      'reviews': 23,
      'isNew': true,
    },
    {
      'id': 'bamboo_toothbrush',
      'name': 'Bamboo Toothbrushes',
      'logo': 'images/bamboo_toothbrush.jpg',
      'coins': 120,
      'brand': 'EcoDental',
      'category': 'Personal Care',
      'description': 'Pack of 4 biodegradable bamboo toothbrushes.',
      'rating': 4.4,
      'reviews': 19,
      'isNew': false,
    },
  ];

  void _toggleFavorite(String productId) {
    setState(() {
      if (_favoriteProducts.contains(productId)) {
        _favoriteProducts.remove(productId);
      } else {
        _favoriteProducts.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: PageView.builder(
              itemCount: _newsItems.length,
              onPageChanged: (index) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildNewsCard(_newsItems[index]);
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _newsItems.length,
                  (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentCarouselIndex == index
                      ? AppColors.primary
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final coins = userProvider.user?.coins ?? 0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Coins Earned',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coins.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to coin history or details
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Eco-Friendly Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full eco products catalog
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Grid view of eco products with new card design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85, // Changed from 0.75 to 0.85 for more compact cards
                crossAxisSpacing: 8, // Reduced from 12
                mainAxisSpacing: 12, // Reduced from 16
              ),
              itemCount: _ecoProducts.length,
              itemBuilder: (context, index) {
                final product = _ecoProducts[index];
                return _buildNewEcoProductCard(product);
              },
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: news['color'],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    news['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news['description'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.asset(
                news['image'],
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white.withOpacity(0.2),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // New product card design based on the reference image
  Widget _buildNewEcoProductCard(Map<String, dynamic> product) {
    final bool isFavorite = _favoriteProducts.contains(product['id']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with New tag and Favorite button
            Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 100, // Reduced from 140
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Image.asset(
                      product['logo'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.eco,
                            size: 50,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // New tag
                if (product['isNew'] == true)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(product['id']),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product details
            Padding(
              padding: const EdgeInsets.all(8), // Reduced from 12
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product['category'],
                    style: TextStyle(
                      fontSize: 10, //reduced from 12
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 2), //change from 4 to 2

                  // Product name
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14, //reduced from 16
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2), //change from 4 to 2

                  // Description
                  Text(
                    product['description'],
                    style: TextStyle(
                      fontSize: 10, //reduced from 12
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4), //change from 8 to 4

                  // Rating
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ...List.generate(5, (index) {
                              final double rating = product['rating'] ?? 0;
                              if (index < rating.floor()) {
                                return const Icon(Icons.star, color: Colors.amber, size: 14);
                              } else if (index < rating.ceil() && rating.floor() != rating.ceil()) {
                                return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                              } else {
                                return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                              }
                            }),
                            const SizedBox(width: 2),
                            Text(
                              "(${product['reviews']})",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4), //change from 8 to 4

                  // Price in coins
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${product['coins']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
