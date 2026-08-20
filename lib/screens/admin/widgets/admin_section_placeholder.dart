import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class AdminSectionPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> quickStats;

  const AdminSectionPlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.quickStats = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header Bar with Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppTheme.primaryDark, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Export feature ready for backend integration", style: GoogleFonts.outfit()),
                          backgroundColor: AppTheme.primaryDark,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, size: 16, color: AppTheme.primaryDark),
                    label: Text("Export Data", style: GoogleFonts.outfit(color: AppTheme.primaryDark, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Action modal ready for module development", style: GoogleFonts.outfit()),
                          backgroundColor: AppTheme.primaryLight,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: Text("+ New Entry", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryLight,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Integration Info Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primaryDark.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$title Management Module — Architecture Ready",
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "This Admin navigation section foundation is isolated and prepared for upcoming dynamic backend API data bindings.",
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          color: AppTheme.textLight,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Stats Cards Grid if provided
          if (quickStats.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisExtent: 90,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: quickStats.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "METRIC ${index + 1}",
                        style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textLight, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quickStats[index],
                        style: GoogleFonts.outfit(fontSize: 15, color: AppTheme.primaryDark, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Placeholder Data Table Mockup Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64, color: AppTheme.textLight.withOpacity(0.4)),
                const SizedBox(height: 16),
                Text(
                  "$title Section Overview",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Detailed list views, search filters, and CRUD controllers for $title will be connected here.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                Chip(
                  avatar: const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
                  label: Text("Module Routing Active", style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                  backgroundColor: const Color(0xFFE8F5E9),
                  side: BorderSide.none,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
