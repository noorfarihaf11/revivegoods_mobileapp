import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:revivegoods/providers/pickup_provider.dart';
import '../utils/app_colors.dart';
import 'history_detail_screen.dart';

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
    });
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
      final pickupProvider = Provider.of<PickupProvider>(context, listen: false);
      await pickupProvider.fetchPickupData(token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  _buildTabButton('On going', 0),
                  _buildTabButton('Complete', 1),
                ],
              ),
            ),
          ),

          // History list pakai Consumer supaya rebuild saat data berubah
          Expanded(
            child: Consumer<PickupProvider>(
              builder: (context, pickupProvider, _) {
                final items = _selectedTabIndex == 0
                    ? pickupProvider.ongoingItems
                    : pickupProvider.completedItems;

                if (pickupProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pickupProvider.errorMessage != null) {
                  return Center(child: Text(pickupProvider.errorMessage!));
                }

                if (items.isEmpty) {
                  return const Center(child: Text("No history found"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => HistoryDetailScreen(pickup: item),
                      //     ),
                      //   );
                      // },
                      child: _buildHistoryItem(item),
                    );
                  },
                );
              },
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
  Widget _buildHistoryItem(PickupData item) {
    final bool isOngoing = _selectedTabIndex == 0;

    String date = _formatDate(item.scheduledAt);
    String time = _formatTime(item.scheduledAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
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
                Text(
                  item.address,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          // Status column
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOngoing
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
      DateTime dt = DateTime.parse(scheduledAt);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
      final ampm = dt.hour >= 12 ? "PM" : "AM";
      final minute = dt.minute.toString().padLeft(2, '0');
      return "$hour:$minute $ampm";
    } catch (e) {
      return scheduledAt;
    }
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}