import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> historyItem;

  const HistoryDetailScreen({
    Key? key,
    required this.historyItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCompleted = historyItem['status'] == 'Delivered';

    // Sample order items - in a real app, this would come from your data source
    final List<Map<String, dynamic>> orderItems = [
      {'name': 'Jacket', 'quantity': 1, 'coins': 75},
      {'name': 'Shirt', 'quantity': 2, 'coins': 100},
    ];

    // Calculate totals
    final int totalItems = orderItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    final int subtotalCoins = orderItems.fold(0, (sum, item) => sum + (item['coins'] as int));
    const int deliveryFee = -10; // Negative because it's a deduction
    final int totalCoins = subtotalCoins + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B367C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button


            const SizedBox(height: 40),

            // Delivery truck image
            Center(
              child: Image.asset(
                isCompleted
                    ? 'assets/images/green_coins.png'
                    : 'assets/images/delivery_truck.png',
                width: 150,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.local_shipping,
                      size: 80,
                      color: Color(0xFF4B367C),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Order ID
            Center(
              child: Text(
                'ORDER ${historyItem['id']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B367C),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status
            Center(
              child: Text(
                historyItem['status'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status message
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  isCompleted
                      ? 'Congratulations! you earned $totalCoins coins, check your email for the order invoice.'
                      : 'Make sure your goods was right before courier picked up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Order details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order details:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B367C),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Table header
                  Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B367C),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Quantity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B367C),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Coins',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4B367C),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Order items
                  ...orderItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item['quantity'].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['coins'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B367C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )).toList(),

                  const Divider(thickness: 1),

                  // Subtotal
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '$totalItems items',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                subtotalCoins.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B367C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delivery fee
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Delivery Fee',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Text(
                            deliveryFee.toString(),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(thickness: 1),

                  // Total
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B367C),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                totalCoins.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B367C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // History tab
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'history',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}

