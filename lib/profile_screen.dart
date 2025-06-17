import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Noor Fariha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Location
                const Text(
                  'New York, USA',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),
                // Contact info
                const Text(
                  'noorfarihaf@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textGrey,
                  ),
                ),
                const Text(
                  '0819 2783 3334',
                  style: TextStyle(
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

                // Right side - Donated items
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your donated items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildDonationTag('Clothes'),
                          _buildDonationTag('Books'),
                          _buildDonationTag('Toys'),
                          _buildDonationTag('Electronics'),
                          _buildDonationTag('Paper'),
                          _buildDonationTag('Mobile'),
                        ],
                      ),
                    ],
                  ),
                ),
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
        Container(
          height: 200,
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

              // Stats items
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(context, 'Donations done', '15'),
                  _buildStatItem(context, 'Reward Points', '250'),
                  _buildStatItem(context, 'Coupons used', '5'),
                  _buildStatItem(context, 'Referred', '11'),
                ],
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
