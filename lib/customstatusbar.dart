import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomStatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Tinggi status bar
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color(0xFF4B3B76), // Warna ungu custom
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Waktu (seperti iPhone)
          const Text(
            "9:41",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "SF Pro Display", // Gunakan font mirip iOS
            ),
          ),

          // Ikon di sisi kanan (mirip iOS)
          Row(
            children: [
              Icon(CupertinoIcons.airplane, color: Colors.white, size: 18), // Mirip sinyal iOS
              const SizedBox(width: 6),
              Icon(CupertinoIcons.wifi, color: Colors.white, size: 18), // Mirip WiFi iOS
              const SizedBox(width: 6),
              Icon(CupertinoIcons.battery_full, color: Colors.white, size: 20), // Mirip baterai iOS
            ],
          ),
        ],
      ),
    );
  }
}
