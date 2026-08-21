import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'admin_banner_management_view.dart';
import 'admin_menu_management_view.dart';
import 'admin_sdg_management_view.dart';

class AdminHomePageManagementView extends StatefulWidget {
  const AdminHomePageManagementView({super.key});

  @override
  State<AdminHomePageManagementView> createState() =>
      _AdminHomePageManagementViewState();
}

class _AdminHomePageManagementViewState
    extends State<AdminHomePageManagementView> {
  // Selected sub-module index: 0 = Menu Management, 1 = Carousel / Banners, 2 = SDG Goals Section
  int _activeSubModuleIndex = 0;

  final List<Map<String, dynamic>> _subModules = const [
    {
      'id': 'menu',
      'title': 'Menu Management',
      'subtitle': 'Top navigation & route links',
      'icon': Icons.menu_book,
      'badge': 'Active Module',
      'isImplemented': true,
    },
    {
      'id': 'carousel',
      'title': 'Carousel / Banners',
      'subtitle': 'Hero slider banners & posters',
      'icon': Icons.view_carousel_outlined,
      'badge': 'Active Module',
      'isImplemented': true,
    },
    {
      'id': 'sdg',
      'title': 'SDG Goals Section',
      'subtitle': 'Featured UN SDG goal highlights',
      'icon': Icons.public_outlined,
      'badge': 'Active Module',
      'isImplemented': true,
    },
    {
      'id': 'upcoming',
      'title': 'Upcoming Events',
      'subtitle': 'Featured homepage event cards',
      'icon': Icons.upcoming_outlined,
      'badge': 'Ready for Binding',
      'isImplemented': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Header
          _buildHeaderBanner(),

          const SizedBox(height: 24),

          // Navigation Sub-Module Tabs Grid / Selector
          _buildSubModuleSelector(),

          const SizedBox(height: 24),

          // Sub-module view renderer
          if (_activeSubModuleIndex == 0)
            const AdminMenuManagementView()
          else if (_activeSubModuleIndex == 1)
            const AdminBannerManagementView()
          else if (_activeSubModuleIndex == 2)
            const AdminSdgManagementView()
          else
            _buildModulePlaceholderCard(_subModules[_activeSubModuleIndex]),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryDark,
            AppTheme.darkAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "PUBLIC FRONTEND CMS",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SRIHER Admin Architecture",
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Home Page Management",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage navigation menus, hero banners, SDG goal sections, and upcoming event showcases displayed on Gokul's public home page.",
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: const Icon(
              Icons.home_max,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubModuleSelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        final items = _subModules.asMap().entries.map((entry) {
          final index = entry.key;
          final module = entry.value;
          final isSelected = _activeSubModuleIndex == index;

          return InkWell(
            onTap: () {
              setState(() {
                _activeSubModuleIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryDark : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryDark
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppTheme.primaryDark.withOpacity(0.15)
                        : Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.primaryDark.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      module['icon'] as IconData,
                      color: isSelected ? Colors.white : AppTheme.primaryDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          module['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppTheme.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          module['subtitle'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 10.5,
                            color: isSelected
                                ? Colors.white70
                                : AppTheme.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (module['isImplemented'] as bool
                              ? const Color(0xFFE8F5E9)
                              : AppTheme.background),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      module['badge'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : (module['isImplemented'] as bool
                                ? const Color(0xFF2E7D32)
                                : AppTheme.textLight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        if (isWide) {
          return Row(
            children: items
                .map((item) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: item,
                    )))
                .toList(),
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: items,
        );
      },
    );
  }

  Widget _buildModulePlaceholderCard(Map<String, dynamic> module) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              module['icon'] as IconData,
              size: 48,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${module['title']} Module",
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "This sub-module of Home Page Management is architected and ready for future CMS feature binding.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.architecture, size: 16, color: AppTheme.primaryDark),
                const SizedBox(width: 6),
                Text(
                  "Home Page Management Foundation Ready",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
