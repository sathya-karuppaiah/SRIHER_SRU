import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AdminNavItem {
  final String title;
  final IconData outlineIcon;
  final IconData filledIcon;
  final String? badgeText;

  const AdminNavItem({
    required this.title,
    required this.outlineIcon,
    required this.filledIcon,
    this.badgeText,
  });
}

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  static const List<AdminNavItem> navItems = [
    AdminNavItem(
      title: "Dashboard",
      outlineIcon: Icons.dashboard_outlined,
      filledIcon: Icons.dashboard,
    ),
    AdminNavItem(
      title: "Events",
      outlineIcon: Icons.event_outlined,
      filledIcon: Icons.event,
      badgeText: "24",
    ),
    AdminNavItem(
      title: "Upcoming Events",
      outlineIcon: Icons.upcoming_outlined,
      filledIcon: Icons.upcoming,
      badgeText: "8",
    ),
    AdminNavItem(
      title: "SDG Goals",
      outlineIcon: Icons.public_outlined,
      filledIcon: Icons.public,
      badgeText: "17",
    ),
    AdminNavItem(
      title: "Registrations",
      outlineIcon: Icons.how_to_reg_outlined,
      filledIcon: Icons.how_to_reg,
      badgeText: "1.4k",
    ),
    AdminNavItem(
      title: "Attendees",
      outlineIcon: Icons.people_alt_outlined,
      filledIcon: Icons.people_alt,
    ),
    AdminNavItem(
      title: "Speakers",
      outlineIcon: Icons.record_voice_over_outlined,
      filledIcon: Icons.record_voice_over,
    ),
    AdminNavItem(
      title: "Tickets",
      outlineIcon: Icons.confirmation_number_outlined,
      filledIcon: Icons.confirmation_number,
    ),
    AdminNavItem(
      title: "Notifications",
      outlineIcon: Icons.notifications_outlined,
      filledIcon: Icons.notifications,
      badgeText: "3",
    ),
    AdminNavItem(
      title: "Analytics",
      outlineIcon: Icons.insights_outlined,
      filledIcon: Icons.insights,
    ),
    AdminNavItem(
      title: "Settings",
      outlineIcon: Icons.settings_outlined,
      filledIcon: Icons.settings,
    ),
  ];

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 76 : 260,
      decoration: const BoxDecoration(
        color: AppTheme.darkAccent, // Navy background matching theme
        border: Border(
          right: BorderSide(
            color: Colors.white10,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Branding Header
          _buildHeader(context),

          const Divider(color: Colors.white12, height: 1),

          // Navigation Links List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;
                return _buildNavItem(context, item, index, isSelected);
              },
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // Footer Profile & System Status
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "SRIHER ",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        TextSpan(
                          text: "ADMIN",
                          style: GoogleFonts.outfit(
                            color: AppTheme.primaryLight,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Event Management Hub",
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onToggleCollapse != null)
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white70, size: 20),
                onPressed: onToggleCollapse,
                tooltip: "Collapse Sidebar",
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, AdminNavItem item, int index, bool isSelected) {
    final activeColor = Colors.white;
    final inactiveColor = Colors.white60;

    Widget content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onDestinationSelected(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 14,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? const Border(
                    left: BorderSide(color: AppTheme.primaryLight, width: 3.5),
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                isSelected ? item.filledIcon : item.outlineIcon,
                color: isSelected ? AppTheme.primaryLight : inactiveColor,
                size: 22,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.outfit(
                      color: isSelected ? activeColor : inactiveColor,
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badgeText!,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: item.title,
          preferBelow: false,
          child: content,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: content,
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (isCollapsed) {
      return Container(
        height: 64,
        padding: const EdgeInsets.all(12),
        child: const CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.primaryDark,
          child: Icon(Icons.person, color: Colors.white, size: 18),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryDark,
            child: Text(
              "AD",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Admin Console",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "SRIHER Platform",
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50), // Online indicator
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
