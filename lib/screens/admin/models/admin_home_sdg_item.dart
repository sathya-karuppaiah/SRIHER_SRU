import 'package:flutter/material.dart';

/// Data model representing an UN SDG Goal Card on the public Home page.
/// Used in Admin Home Page Management -> SDG Goals Section.
class AdminHomeSdgItem {
  final String id;
  final int goalNumber;
  final String title;
  final String imageUrl;
  final String cardDimension;
  final String hyperlink;
  final int displayOrder;
  final bool isActive;

  static const String fixedDimension = "400 × 400 px";

  const AdminHomeSdgItem({
    required this.id,
    required this.goalNumber,
    required this.title,
    required this.imageUrl,
    this.cardDimension = fixedDimension,
    required this.hyperlink,
    required this.displayOrder,
    this.isActive = true,
  });

  /// Create a copy of this object with updated fields
  AdminHomeSdgItem copyWith({
    String? id,
    int? goalNumber,
    String? title,
    String? imageUrl,
    String? cardDimension,
    String? hyperlink,
    int? displayOrder,
    bool? isActive,
  }) {
    return AdminHomeSdgItem(
      id: id ?? this.id,
      goalNumber: goalNumber ?? this.goalNumber,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      cardDimension: cardDimension ?? this.cardDimension,
      hyperlink: hyperlink ?? this.hyperlink,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Serialize to JSON for future API integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalNumber': goalNumber,
      'title': title,
      'imageUrl': imageUrl,
      'cardDimension': cardDimension,
      'hyperlink': hyperlink,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  /// Factory constructor for deserializing from API response payload
  factory AdminHomeSdgItem.fromJson(Map<String, dynamic> json) {
    return AdminHomeSdgItem(
      id: json['id'] as String? ?? '',
      goalNumber: json['goalNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      cardDimension: json['cardDimension'] as String? ?? fixedDimension,
      hyperlink: json['hyperlink'] as String? ?? '',
      displayOrder: json['displayOrder'] as int? ?? 1,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Default mock SDG goal card items
  static List<AdminHomeSdgItem> get defaultSdgItems => const [
        AdminHomeSdgItem(
          id: 'sdg_3',
          goalNumber: 3,
          title: 'Good Health and Well-Being',
          imageUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_GOALS_FINAL-03.png',
          hyperlink: 'https://sdgs.un.org/goals/goal3',
          displayOrder: 1,
          isActive: true,
        ),
        AdminHomeSdgItem(
          id: 'sdg_4',
          goalNumber: 4,
          title: 'Quality Education',
          imageUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_GOALS_FINAL-04.png',
          hyperlink: 'https://sdgs.un.org/goals/goal4',
          displayOrder: 2,
          isActive: true,
        ),
        AdminHomeSdgItem(
          id: 'sdg_9',
          goalNumber: 9,
          title: 'Industry, Innovation and Infrastructure',
          imageUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_GOALS_FINAL-09.png',
          hyperlink: 'https://sdgs.un.org/goals/goal9',
          displayOrder: 3,
          isActive: true,
        ),
        AdminHomeSdgItem(
          id: 'sdg_17',
          goalNumber: 17,
          title: 'Partnerships for the Goals',
          imageUrl: 'https://sdgs.un.org/sites/default/files/goals/E_SDG_GOALS_FINAL-17.png',
          hyperlink: 'https://sdgs.un.org/goals/goal17',
          displayOrder: 4,
          isActive: true,
        ),
      ];
}
