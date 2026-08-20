import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AdminHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool isDesktop;
  final VoidCallback? onMenuToggle;

  const AdminHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isDesktop = true,
    this.onMenuToggle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side: Menu toggle icon & Title
          if (!isDesktop || onMenuToggle != null)
            IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.primaryDark),
              onPressed: onMenuToggle,
              tooltip: "Toggle Navigation",
            ),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: AppTheme.textLight,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Center/Right Search Bar (Visible on wider screens)
          if (isWide)
            Container(
              width: 260,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textDark),
                decoration: InputDecoration(
                  hintText: "Search admin dashboard...",
                  hintStyle: GoogleFonts.outfit(fontSize: 12.5, color: AppTheme.textLight),
                  prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.textLight),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),

          if (isWide) const SizedBox(width: 16),

          // Academic Session Badge
          if (isWide)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primaryDark.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryDark.withOpacity(0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "AY 2026-27",
                    style: GoogleFonts.outfit(
                      color: AppTheme.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 12),

          // Notification Icon with Counter Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: AppTheme.primaryDark, size: 22),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Notifications: 3 new registration alerts",
                        style: GoogleFonts.outfit(),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppTheme.primaryDark,
                    ),
                  );
                },
                tooltip: "Notifications",
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "3",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Admin User Profile
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryDark,
                  border: Border.all(color: AppTheme.primaryLight, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    "SR",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (isWide) ...[
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SRIHER Admin",
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      "Event Controller",
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
