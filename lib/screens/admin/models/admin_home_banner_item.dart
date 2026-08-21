import 'package:flutter/material.dart';

/// Data model representing a hero banner/carousel item on the public Home page.
/// Used in Admin Home Page Management -> Carousel / Banner Management.
class AdminHomeBannerItem {
  final String id;
  final String title;
  final String imageUrl;
  final String desktopDimension;
  final String tabletDimension;
  final String mobileDimension;
  final int displayOrder;
  final bool isActive;

  static const String defaultDesktopDim = "1920 × 600 px";
  static const String defaultTabletDim = "1280 × 500 px";
  static const String defaultMobileDim = "768 × 900 px";

  const AdminHomeBannerItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.desktopDimension = defaultDesktopDim,
    this.tabletDimension = defaultTabletDim,
    this.mobileDimension = defaultMobileDim,
    required this.displayOrder,
    this.isActive = true,
  });

  /// Legacy width helper for desktop
  double get width => 1920.0;

  /// Legacy height helper for desktop
  double get height => 600.0;

  /// Create a copy of this object with updated fields
  AdminHomeBannerItem copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? desktopDimension,
    String? tabletDimension,
    String? mobileDimension,
    int? displayOrder,
    bool? isActive,
  }) {
    return AdminHomeBannerItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      desktopDimension: desktopDimension ?? this.desktopDimension,
      tabletDimension: tabletDimension ?? this.tabletDimension,
      mobileDimension: mobileDimension ?? this.mobileDimension,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Serialize to JSON for future API integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'desktopDimension': desktopDimension,
      'tabletDimension': tabletDimension,
      'mobileDimension': mobileDimension,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  /// Factory constructor for deserializing from API response payload
  factory AdminHomeBannerItem.fromJson(Map<String, dynamic> json) {
    return AdminHomeBannerItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      desktopDimension: json['desktopDimension'] as String? ?? defaultDesktopDim,
      tabletDimension: json['tabletDimension'] as String? ?? defaultTabletDim,
      mobileDimension: json['mobileDimension'] as String? ?? defaultMobileDim,
      displayOrder: json['displayOrder'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Default mock banner items representing the public home page hero carousel slider
  static List<AdminHomeBannerItem> get defaultBanners => const [
        AdminHomeBannerItem(
          id: 'banner_1',
          title: 'Welcome to SRIHER - Excellence in Higher Education & Research',
          imageUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?q=80&w=1000&auto=format&fit=crop',
          displayOrder: 1,
          isActive: true,
        ),
        AdminHomeBannerItem(
          id: 'banner_2',
          title: 'Admissions Open 2026-27 - Medical, Dental & Allied Health Sciences',
          imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=1000&auto=format&fit=crop',
          displayOrder: 2,
          isActive: true,
        ),
        AdminHomeBannerItem(
          id: 'banner_3',
          title: 'Annual Sustainable Development Goals (SDG) Summit 2026',
          imageUrl: 'https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?q=80&w=1000&auto=format&fit=crop',
          displayOrder: 3,
          isActive: true,
        ),
        AdminHomeBannerItem(
          id: 'banner_4',
          title: 'State-of-the-Art Research Center & Global Partnerships',
          imageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?q=80&w=1000&auto=format&fit=crop',
          displayOrder: 4,
          isActive: false,
        ),
      ];
}
