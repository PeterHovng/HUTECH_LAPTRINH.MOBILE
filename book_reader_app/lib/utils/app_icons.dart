// lib/utils/app_icons.dart
import 'package:flutter/material.dart';

class AppIcons {
  // Define commonly used icons explicitly
  static const IconData home = Icons.home;
  static const IconData search = Icons.search;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteBorder = Icons.favorite_border;
  static const IconData menuBook = Icons.menu_book;
  static const IconData launch = Icons.launch;
  static const IconData refresh = Icons.refresh;
  static const IconData add = Icons.add;
  static const IconData logout = Icons.logout;
  static const IconData book = Icons.book;
  static const IconData bookOutlined = Icons.book_outlined;
  static const IconData libraryBooks = Icons.library_books;
  static const IconData smartphone = Icons.smartphone;
  static const IconData infoOutline = Icons.info_outline;
  static const IconData errorOutline = Icons.error_outline;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData bugReport = Icons.bug_report;
  static const IconData archive = Icons.archive;
  
  // Fallback icons if Material Icons don't work
  static const IconData fallbackHome = IconData(0xe318, fontFamily: 'MaterialIcons');
  static const IconData fallbackSearch = IconData(0xe567, fontFamily: 'MaterialIcons');
  static const IconData fallbackFavorite = IconData(0xe87d, fontFamily: 'MaterialIcons');
  static const IconData fallbackBook = IconData(0xe865, fontFamily: 'MaterialIcons');
  
  // Method to get icon with fallback
  static IconData getIcon(String iconName) {
    switch (iconName) {
      case 'home':
        return home;
      case 'search':
        return search;
      case 'favorite':
        return favorite;
      case 'book':
        return book;
      case 'launch':
        return launch;
      case 'refresh':
        return refresh;
      default:
        return book; // Default fallback
    }
  }
}