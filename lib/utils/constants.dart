import 'package:flutter/material.dart';

// App colors
class AppColors {
  static const Color primary = Color(0xFF4B367C);
  static const Color secondary = Color(0xFFB5A9F8);
  static const Color background = Color(0xFF4B367C);
  static const Color lightPurple = Color(0xFFC3ADFC);
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
}

// Extension to show snackbars easily
extension ShowSnackBar on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}

// App text styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: "Poppins",
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: "Poppins",
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle body = TextStyle(
    fontFamily: "Poppins",
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}
