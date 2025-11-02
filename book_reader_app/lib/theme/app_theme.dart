import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - sử dụng gradient xanh dương nhất quán
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF42A5F5);
  
  // Secondary colors - xanh lá cho Project Gutenberg
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryDark = Color(0xFF1B5E20);
  static const Color secondaryLight = Color(0xFF66BB6A);
  
  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF2C2C2C);
  static const Color grey = Color(0xFF757575);
  static const Color greyLight = Color(0xFFE0E0E0);
  
  // Gradient definitions
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );
  
  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondary, secondaryDark],
  );
}

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );
  
  static const TextStyle captionWhite = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );
}

class AppShadows {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> headerShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 30.0;
  
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
}