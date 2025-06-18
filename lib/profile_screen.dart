import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // Pastikan path sesuai


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context).user;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Simple profile header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                // User name
                Text(
                  user?.name ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Contact info
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          const Divider(),

          // Stats and donated items section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Stats with timeline
                Expanded(
                  flex: 1,
                  child: _buildStatsTimeline(context),
                ),

                const SizedBox(width: 20),
              ],
            ),
          ),

          const Divider(),

          // Logout button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // Navigasi ke SplashScreen dan hapus semua riwayat sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build stats timeline
  Widget _buildStatsTimeline(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Stats',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              // Vertical line
              Positioned(
                left: 6,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.grey.withOpacity(0.3),
                ),
              ),
              // Stats item
              Align(
                alignment: Alignment.topLeft,
                child: _buildStatItem(
                  context,
                  'Reward Points',
                  user?.coins.toString() ?? '0',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // Build stat item
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Row(
      children: [
        // Dot on timeline
        Container(
          margin: const EdgeInsets.only(right: 12),
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        // Label and value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build donation tag
  Widget _buildDonationTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
