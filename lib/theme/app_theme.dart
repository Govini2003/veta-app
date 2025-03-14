import 'package:flutter/material.dart';
class AppTheme {
  static const Color primaryColor = Color(0xFF1D4D4F);     // Deep teal
  static const Color accentColor = Color(0xFFDEC092);      // Cream
  static const Color backgroundColor = Color(0xFFF8F9FA);  // Light gray
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1D4D4F);        // Deep teal for text
  static const Color secondaryTextColor = Color(0xFF6BABA9); // Lighter teal
  static const Color subtitleColor = Color(0xFF6BABA9);    // Lighter teal
  
  static const double borderRadius = 16.0;
  static const double spacing = 16.0;
  static const double avatarSize = 60.0;

  
  static BoxDecoration neumorphicDecoration({
    double radius = borderRadius,
    bool isPressed = false,
    Color bgColor = backgroundColor,
  }) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isPressed ? [] : [
        BoxShadow(
          color: Colors.white.withOpacity(0.8),
          offset: Offset(-4, -4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.grey.shade300,
          offset: Offset(4, 4),
          blurRadius: 8,
        ),
      ],
    );
  }
  
  static BoxDecoration avatarDecoration() {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    );
  }

  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: secondaryTextColor,
  );

  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
}
