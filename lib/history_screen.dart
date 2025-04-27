import 'package:flutter/material.dart';
import 'history_detail_screen.dart';
import '../utils/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTabIndex = 0;

  // Sample data for history items
  final List<Map<String, dynamic>> _ongoingItems = [
    {
      'id': 'ID-110805',
      'location': 'Emerald Cluster B-1',
      'time': '4:30 PM',
      'date': '4th April 2025',
      'status': 'Waiting Courier',
    },
    {
      'id': 'ID-110806',
      'location': 'Palm Gardens C-3',
      'time': '2:15 PM',
      'date': '5th April 2025',
      'status': 'Processing',
    },
    {
      'id': 'ID-110809',
      'location': 'Sunset Heights A-2',
      'time': '10:00 AM',
      'date': '7th April 2025',
      'status': 'Scheduled',
    },
  ];

  final List<Map<String, dynamic>> _completedItems = [
    {
      'id': 'ID-110801',
      'location': 'Maple Avenue D-4',
      'time': '1:45 PM',
      'date': '1st April 2025',
      'status': 'Delivered',
    },
    {
      'id': 'ID-110799',
      'location': 'Oak Street F-2',
      'time': '11:30 AM',
      'date': '29th March 2025',
      'status': 'Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // History list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _selectedTabIndex == 0
                ? _ongoingItems.length
                : _completedItems.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = _selectedTabIndex == 0
                  ? _ongoingItems[index]
                  : _completedItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryDetailScreen(historyItem: item),
                    ),
                  );
                },
                child: _buildHistoryItem(item),
              );
            },
          ),
        ),
      ],
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

  // Build a history item
  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final bool isOngoing = _selectedTabIndex == 0;

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
                item['date'].split(' ')[0], // Extract day number
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item['date'].substring(item['date'].indexOf(' ') + 1), // Extract month and year
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
                  item['id'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['location'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time'],
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
              item['status'],
              style: TextStyle(
                color: isOngoing
                    ? AppColors.primary
                    : Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
