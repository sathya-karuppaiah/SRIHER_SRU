import 'package:flutter/material.dart';

/// Data model representing a navigation menu item on the public Home page.
/// Used in Admin Home Page Management -> Menu Management.
class AdminHomeMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final int displayOrder;
  final bool isActive;

  const AdminHomeMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    required this.displayOrder,
    this.isActive = true,
  });

  /// Create a copy of this object with updated fields
  AdminHomeMenuItem copyWith({
    String? id,
    String? title,
    IconData? icon,
    String? route,
    int? displayOrder,
    bool? isActive,
  }) {
    return AdminHomeMenuItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Serialize to JSON for future API integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'route': route,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  /// Factory constructor for deserializing from API response payload
  factory AdminHomeMenuItem.fromJson(Map<String, dynamic> json) {
    final int codePoint = json['iconCodePoint'] as int? ?? Icons.link.codePoint;
    final String fontFamily = json['iconFontFamily'] as String? ?? 'MaterialIcons';

    return AdminHomeMenuItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      // ignore: non_const_argument_for_const_parameter
      icon: IconData(codePoint, fontFamily: fontFamily),
      route: json['route'] as String? ?? '/',
      displayOrder: json['displayOrder'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Default mock menu items representing the public home page navigation structure
  static List<AdminHomeMenuItem> get defaultMenuItems => const [
        AdminHomeMenuItem(
          id: 'menu_1',
          title: 'Home',
          icon: Icons.home_outlined,
          route: '/home',
          displayOrder: 1,
          isActive: true,
        ),
        AdminHomeMenuItem(
          id: 'menu_2',
          title: 'Events',
          icon: Icons.calendar_today_outlined,
          route: '/events',
          displayOrder: 2,
          isActive: true,
        ),
        AdminHomeMenuItem(
          id: 'menu_3',
          title: 'SDG Goals',
          icon: Icons.public_outlined,
          route: '/sdg-goals',
          displayOrder: 3,
          isActive: true,
        ),
        AdminHomeMenuItem(
          id: 'menu_4',
          title: 'Tickets',
          icon: Icons.confirmation_number_outlined,
          route: '/tickets',
          displayOrder: 4,
          isActive: true,
        ),
        AdminHomeMenuItem(
          id: 'menu_5',
          title: 'Profile',
          icon: Icons.person_outline,
          route: '/profile',
          displayOrder: 5,
          isActive: true,
        ),
        AdminHomeMenuItem(
          id: 'menu_6',
          title: 'About SRIHER',
          icon: Icons.info_outline,
          route: '/about',
          displayOrder: 6,
          isActive: false,
        ),
      ];
}
