import 'package:flutter/material.dart';

/// Maps icon string names to Flutter Material Icons
/// Used for dynamically setting tab icons from configuration
class IconMapper {
  /// Map of icon string names to IconData
  static final Map<String, IconData> _iconMap = {
    'home': Icons.home,
    'search': Icons.search,
    'person': Icons.person,
    'settings': Icons.settings,
    'favorite': Icons.favorite,
    'star': Icons.star,
    'shopping_cart': Icons.shopping_cart,
    'notifications': Icons.notifications,
    'mail': Icons.mail,
    'dashboard': Icons.dashboard,
    'explore': Icons.explore,
    'account_circle': Icons.account_circle,
    'menu': Icons.menu,
    'info': Icons.info,
    'help': Icons.help,
    'bookmark': Icons.bookmark,
    'calendar_today': Icons.calendar_today,
    'category': Icons.category,
    'language': Icons.language,
    'local_offer': Icons.local_offer,
  };

  /// Default icon to use when icon name is not found or is null
  static const IconData _defaultIcon = Icons.tab;

  /// Gets IconData from icon string name
  /// Returns default icon if name is null or not found
  ///
  /// Example:
  /// ```dart
  /// final icon = IconMapper.getIcon('home'); // Returns Icons.home
  /// final icon = IconMapper.getIcon('unknown'); // Returns Icons.tab (default)
  /// final icon = IconMapper.getIcon(null); // Returns Icons.tab (default)
  /// ```
  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return _defaultIcon;
    }
    return _iconMap[iconName] ?? _defaultIcon;
  }

  /// Gets list of available icon names
  static List<String> getAvailableIcons() {
    return _iconMap.keys.toList();
  }
}
