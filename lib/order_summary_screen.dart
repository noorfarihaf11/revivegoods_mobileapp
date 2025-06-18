import 'package:flutter/material.dart';
import 'package:revivegoods/models/PickupItemModel.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:revivegoods/api_url.dart';
import 'models/PickupRequestModel.dart';


class OrderSummaryScreen extends StatelessWidget {
  final DateTime selectedDate;   // DateTime, bukan String
  final TimeOfDay selectedTime;  // TimeOfDay, bukan String
  final String address;
  final List<PickupItem> orderItems;

  const OrderSummaryScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.orderItems
  }) : super(key: key);

  int getTotalCoins() {
    final int subtotalCoins = orderItems.fold(0, (sum, item) => sum + (item.coins * item.quantity));
    const int deliveryFee = -10;
    return subtotalCoins + deliveryFee;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Use the correct key
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    print('User ID: $userId');
    return userId?.toString(); // Convert to string for the API
  }


  Future<bool> submitPickupRequest() async {
    var urlPickupRequest = "${ApiUrl.PickupRequestUrl}";
    try {
      final String? token = await getToken();
      print('JWT Token: $token');
      if (token == null) {
        print('No JWT token found');
        return false;
      }

      final String? userId = await getUserId();
      print('User ID: $userId');
      if (userId == null) {
        print('No user ID found');
        return false;
      }

      final DateTime combinedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Gunakan waktu lokal (WIB) tanpa konversi ke UTC
      final String scheduledAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedDateTime);
      print('Scheduled At (formatted): $scheduledAt');

      // Validasi id_donationitem
      for (var item in orderItems) {
        if (item.idDonationItem <= 0) {
          print('Error: Invalid id_donationitem for item: ${item.name}');
          return false;
        }
      }

      final Map<String, dynamic> requestBody = {
        'id_user': userId,
        'scheduled_at': scheduledAt,
        'status': 'requested',
        'address': address,
        'total_coins': getTotalCoins(),
        'items': orderItems.map((item) => {
          'id_donationitem': item.idDonationItem,
          'name': item.name,
        }).toList(),
      };
      print('Request Body: $requestBody');

      final response = await http.post(
        Uri.parse(urlPickupRequest),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Pickup request submitted successfully: ${responseData['message']}');
        return true;
      } else {
        final responseData = json.decode(response.body);
        print('Error message from server: ${responseData['message'] ?? 'No message provided'}');
        return false;
      }
    } catch (e) {
      print('Error submitting pickup request: $e');
      if (e is http.ClientException) {
        print('ClientException details: ${e.message}, URI: ${e.uri}');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
    DateFormat('EEEE, d MMMM y', 'en_US').format(selectedDate); // contoh: Friday, 20 June 2025

    final String formattedTime = selectedTime.format(context); // contoh: 2:30 PM
    final theme = Theme.of(context);

    // Generate a random order ID
    final String orderId = 'ID-110805';

    // Calculate totals
    final int totalItems = orderItems.fold(0, (sum, item) => sum + item.quantity);
    final int subtotalCoins = orderItems.fold(0, (sum, item) => sum + (item.coins * item.quantity));
    const int deliveryFee = -10;
    final int totalCoins = subtotalCoins + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
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

              // Pickup details section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pickup Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B367C),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date and time row
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF4B367C),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Time row
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF4B367C),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Address row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF4B367C),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Order details section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Details',
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
                              'Qty',
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

                      const Divider(height: 24, thickness: 1),

                      // Order items
                      ...orderItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.name.substring(0, 1).toUpperCase() + item.name.substring(1),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4B367C),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item.quantity.toString(),
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
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (item.coins * item.quantity).toString(),
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
                      const Divider(height: 24, thickness: 1),

                      // Subtotal
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                  const Icon(
                                    Icons.monetization_on,
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
                        padding: const EdgeInsets.symmetric(vertical: 4),
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

                      const Divider(height: 24, thickness: 1),

                      // Total
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
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
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.amber,
                                    size: 24,
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              // Tampilkan loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              // Panggil submitPickupRequest
              bool success = await submitPickupRequest();

              // Tutup loading indicator
              if (!context.mounted) return;
              Navigator.of(context).pop();

              // Jika berhasil, tampilkan dialog "Thank you"
              if (success) {
                if (!context.mounted) return;
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Thank You!'),
                      content: const Text('Your donation has been successfully scheduled. Thank you for your contribution!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Tutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

                // Pindah ke HistoryScreen setelah dialog ditutup
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(initialIndex: 2), // 2 = History
                  ),
                      (route) => false,
                );

              } else {
                // Jika gagal, tampilkan dialog error
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Failed to submit pickup request. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B367C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'Confirm Donation',
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
