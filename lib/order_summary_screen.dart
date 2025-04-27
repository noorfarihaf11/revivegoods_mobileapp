import 'package:flutter/material.dart';
import 'history_screen.dart';

class OrderSummaryScreen extends StatelessWidget {
  final String selectedDate;
  final String selectedTime;
  final String address;
  final List<Map<String, dynamic>> orderItems;

  const OrderSummaryScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.orderItems,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {

    void history() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HistoryScreen()),
      );
    }

    final theme = Theme.of(context);

    // Generate a random order ID
    final String orderId = 'ID-110805';

    // Calculate totals
    final int totalItems = orderItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    final int subtotalCoins = orderItems.fold(0, (sum, item) => sum + ((item['coins'] as int) * (item['quantity'] as int)));
    const int deliveryFee = -10; // Negative because it's a deduction
    final int totalCoins = subtotalCoins + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B367C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery truck image
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Image.asset(
                    'assets/images/delivery_truck.png',
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
              ),

              // Order ID
              Center(
                child: Text(
                  'ORDER $orderId',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B367C),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Pickup details section
              const Text(
                'Pickup details:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B367C),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                selectedDate,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B367C),
                ),
              ),

              const SizedBox(height: 8),

              // Address details - split into parts for better formatting
              Text(
                address.split(',')[0].trim(), // First line of address
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4B367C),
                ),
              ),

              Text(
                address.split(',').length > 1 ? address.substring(address.indexOf(',') + 1).trim() : '',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4B367C),
                ),
              ),

              const SizedBox(height: 40),

              // Order details section
              const Text(
                'Order details:',
                style: TextStyle(
                  fontSize: 24,
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
                        fontSize: 18,
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
                        fontSize: 18,
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
                        fontSize: 18,
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
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        // Capitalize first letter of item name
                        item['name'].toString().substring(0, 1).toUpperCase() +
                            item['name'].toString().substring(1),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4B367C),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item['quantity'].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4B367C),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (item['coins'] * item['quantity']).toString(),
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
                          fontSize: 18,
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
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            subtotalCoins.toString(),
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
                          fontSize: 18,
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
                          fontSize: 18,
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
                          fontSize: 20,
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
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            totalCoins.toString(),
                            style: const TextStyle(
                              fontSize: 20,
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

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Donation'),
                    content: const Text('Your donation has been scheduled. Thank you for your contribution!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // tutup AlertDialog dulu

                          Future.delayed(Duration(milliseconds: 200), () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const HistoryScreen()),
                            );
                          });
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B367C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

