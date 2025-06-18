import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revivegoods/providers/exchange_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revivegoods/providers/pickup_provider.dart';
import '../utils/app_colors.dart';
import 'history_detail_screen.dart';
import 'models/ExchangeRequest.dart';
import 'models/PickupRequestModel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Panggil fetchPickupData setelah frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPickups();
      _loadExchange();
    });
  }

  Future<void> _loadExchange() async {
    try {
      // Load token dari SharedPreferences
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

      // Panggil provider dengan token
      final exchangeProvider = Provider.of<ExchangeProvider>(
        context,
        listen: false,
      );
      await exchangeProvider.fetchExchangeRequests(token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _loadPickups() async {
    try {
      // Load token dari SharedPreferences
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

      // Panggil provider dengan token
      final pickupProvider = Provider.of<PickupProvider>(
        context,
        listen: false,
      );
      await pickupProvider.fetchPickupData(token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Tab selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _buildTabButton('Donation', 0),
                  _buildTabButton('Trade', 1),
                ],
              ),
            ),
          ),

          // History list pakai Consumer supaya rebuild saat data berubah
          Expanded(
            child:
                _selectedTabIndex == 0
                    ? Consumer<PickupProvider>(
                      builder: (context, pickupProvider, _) {
                        final items = pickupProvider.pickupData;

                        if (pickupProvider.isLoading)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        if (pickupProvider.errorMessage != null)
                          return Center(
                            child: Text(pickupProvider.errorMessage!),
                          );
                        if (items.isEmpty)
                          return const Center(
                            child: Text("No donation history found"),
                          );

                        return ListView.builder(
                          itemCount: items.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildHistoryItem(item, pickupProvider);
                          },
                        );
                      },
                    )
                    : Consumer<ExchangeProvider>(
                      builder: (context, exchangeProvider, _) {
                        final items = exchangeProvider.requests;

                        if (exchangeProvider.isLoading)
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        if (exchangeProvider.errorMessage != null)
                          return Center(
                            child: Text(exchangeProvider.errorMessage!),
                          );
                        if (items.isEmpty)
                          return const Center(
                            child: Text("No trade history found"),
                          );

                        return ListView.builder(
                          itemCount: items.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildTradeItem(item);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeItem(ExchangeRequest item) {
    DateTime dt = DateTime.parse(item.requestedAt);
    String date = "${dt.day} ${_monthName(dt.month)} ${dt.year}";
    String time = _formatTime(item.requestedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${dt.day}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${_monthName(dt.month)} ${dt.year}",
                style: const TextStyle(color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (item.address != null && item.address!.isNotEmpty) ...[
                  Text(item.address!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.monetization_on,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.totalCoins ?? 0}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item.status,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a tab button
  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build a history item using PickupData object
  Widget _buildHistoryItem(PickupData item, PickupProvider pickupProvider) {
    final bool isOngoing = _selectedTabIndex == 0;

    String date = _formatDate(item.scheduledAt);
    String time = _formatTime(item.scheduledAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date.split(' ')[0], // misal "4" (tanggal)
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                date.substring(date.indexOf(' ') + 1), // misal "April 2025"
                style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup #${item.idPickupReq}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.address, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.monetization_on,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${item.totalCoins ?? 0}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status column
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isOngoing
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              item.status,
              style: TextStyle(
                color: isOngoing ? AppColors.primary : Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String scheduledAt) {
    try {
      DateTime dt = DateTime.parse(scheduledAt);
      return "${dt.day} ${_monthName(dt.month)} ${dt.year}";
    } catch (e) {
      return scheduledAt;
    }
  }

 String _formatTime(String scheduledAt) {
  try {
    // Parse dan konversi waktu ke zona lokal
    DateTime dt = DateTime.parse(scheduledAt).toLocal(); // Tambahkan toLocal()
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final ampm = dt.hour >= 12 ? "PM" : "AM";
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute $ampm";
  } catch (e) {
    print('Error parsing time: $e');
    return scheduledAt; // Kembalikan string asli jika gagal
  }
}

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
