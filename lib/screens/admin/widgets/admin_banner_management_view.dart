import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_banner_item.dart';
import 'admin_banner_form_dialog.dart';

class AdminBannerManagementView extends StatefulWidget {
  const AdminBannerManagementView({super.key});

  @override
  State<AdminBannerManagementView> createState() =>
      _AdminBannerManagementViewState();
}

class _AdminBannerManagementViewState
    extends State<AdminBannerManagementView> {
  // Local mock state list for carousel items
  late List<AdminHomeBannerItem> _banners;

  // Search & Filter state
  String _searchQuery = "";
  String _statusFilter = "All"; // "All", "Active", "Inactive"

  @override
  void initState() {
    super.initState();
    _banners = List<AdminHomeBannerItem>.from(AdminHomeBannerItem.defaultBanners);
    _sortAndNormalizeBanners();
  }

  /// Sorts by display order and normalizes displayOrder sequentially starting from 1
  void _sortAndNormalizeBanners() {
    _banners.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    _normalizeOrders();
  }

  /// Recalculates displayOrder sequentially 1, 2, 3, 4... with no duplicates or gaps
  void _normalizeOrders() {
    for (int i = 0; i < _banners.length; i++) {
      _banners[i] = _banners[i].copyWith(displayOrder: i + 1);
    }
  }

  int get _nextDisplayOrder => _banners.length + 1;

  // --- CRUD Operations ---

  void _addBanner(AdminHomeBannerItem newBanner) {
    setState(() {
      _banners.add(newBanner);
      _normalizeOrders();
    });
    _showSnackBar("Banner '${newBanner.title}' added successfully.");
  }

  void _updateBanner(AdminHomeBannerItem updatedBanner) {
    setState(() {
      final index = _banners.indexWhere((e) => e.id == updatedBanner.id);
      if (index != -1) {
        _banners[index] = updatedBanner;
        _sortAndNormalizeBanners();
      }
    });
    _showSnackBar("Banner '${updatedBanner.title}' updated successfully.");
  }

  void _deleteBanner(AdminHomeBannerItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                "Delete Carousel Banner?",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '${item.title}'? This banner will be removed from the homepage carousel slider.",
            style: GoogleFonts.outfit(
                color: AppTheme.textDark, fontSize: 13.5, height: 1.4),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              child: Text("Cancel",
                  style: GoogleFonts.outfit(color: AppTheme.textDark)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _banners.removeWhere((e) => e.id == item.id);
                  _normalizeOrders();
                });
                _showSnackBar("Banner '${item.title}' deleted.", isWarning: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text("Delete",
                  style: GoogleFonts.outfit(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _toggleStatus(AdminHomeBannerItem item) {
    final updated = item.copyWith(isActive: !item.isActive);
    _updateBanner(updated);
  }

  void _moveBanner(int currentIndex, int direction) {
    final targetIndex = currentIndex + direction;
    if (targetIndex < 0 || targetIndex >= _banners.length) return;

    setState(() {
      final item = _banners.removeAt(currentIndex);
      _banners.insert(targetIndex, item);
      _normalizeOrders();
    });

    _showSnackBar("Display order normalized for '${_banners[targetIndex].title}'.");
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AdminBannerFormDialog(
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _addBanner,
      ),
    );
  }

  void _openEditDialog(AdminHomeBannerItem item) {
    showDialog(
      context: context,
      builder: (context) => AdminBannerFormDialog(
        initialItem: item,
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _updateBanner,
      ),
    );
  }

  void _showSnackBar(String message, {bool isWarning = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isWarning ? Icons.warning_amber_rounded : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.outfit(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isWarning ? Colors.red[800] : AppTheme.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<AdminHomeBannerItem> get _filteredBanners {
    return _banners.where((banner) {
      final matchesSearch = banner.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      if (_statusFilter == "Active") {
        return matchesSearch && banner.isActive;
      } else if (_statusFilter == "Inactive") {
        return matchesSearch && !banner.isActive;
      }
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _banners.where((e) => e.isActive).length;
    final inactiveCount = _banners.where((e) => !e.isActive).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric Summary Cards
        _buildMetricSummaryRow(activeCount, inactiveCount),

        const SizedBox(height: 20),

        // Controls Bar (Search, Filter Chips, Add Banner Button)
        _buildControlsBar(),

        const SizedBox(height: 16),

        // Banners Data Table Container
        _buildBannersTable(),
      ],
    );
  }

  Widget _buildMetricSummaryRow(int activeCount, int inactiveCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;

        final cards = [
          _buildSummaryCard(
            title: "Total Hero Banners",
            value: "${_banners.length}",
            subtitle: "Configured homepage sliders",
            icon: Icons.view_carousel,
            accentColor: AppTheme.primaryDark,
          ),
          _buildSummaryCard(
            title: "Active Banners",
            value: "$activeCount",
            subtitle: "Live on homepage hero",
            icon: Icons.check_circle_outline,
            accentColor: const Color(0xFF2E7D32),
          ),
          _buildSummaryCard(
            title: "Inactive Banners",
            value: "$inactiveCount",
            subtitle: "Draft/Hidden from public",
            icon: Icons.visibility_off_outlined,
            accentColor: Colors.orange[800]!,
          ),
          _buildSummaryCard(
            title: "Next Order Index",
            value: "#$_nextDisplayOrder",
            subtitle: "Sequential order #",
            icon: Icons.format_list_numbered,
            accentColor: AppTheme.primaryLight,
          ),
        ];

        if (isWide) {
          return Row(
            children: cards
                .map((c) => Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: c,
                    )))
                .toList(),
          );
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: cards,
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Search Field
          Container(
            width: 260,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textDark),
              decoration: InputDecoration(
                hintText: "Search carousel banners...",
                hintStyle: GoogleFonts.outfit(
                    fontSize: 12.5, color: AppTheme.textLight),
                prefixIcon:
                    const Icon(Icons.search, size: 18, color: AppTheme.textLight),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Status Filter Chips
          Row(
            mainAxisSize: MainAxisSize.min,
            children: ["All", "Active", "Inactive"].map((status) {
              final isSelected = _statusFilter == status;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(
                    status,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryDark,
                  backgroundColor: AppTheme.background,
                  checkmarkColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryDark
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  onSelected: (val) {
                    setState(() {
                      _statusFilter = status;
                    });
                  },
                ),
              );
            }).toList(),
          ),

          // Add Carousel Banner Button
          ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: Text(
              "+ Add Carousel Banner",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannersTable() {
    final filtered = _filteredBanners;

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            const Icon(Icons.find_in_page_outlined,
                size: 48, color: AppTheme.textLight),
            const SizedBox(height: 12),
            Text(
              "No banner items match your criteria",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try adjusting your search query or status filter",
              style:
                  GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hero Slider Banner Items (${filtered.length})",
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  "Use arrow buttons to adjust normalized display order (1, 2, 3...)",
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 1),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppTheme.background),
              dataRowMinHeight: 65,
              dataRowMaxHeight: 75,
              horizontalMargin: 20,
              columnSpacing: 20,
              columns: [
                DataColumn(
                  label: Text("ORDER", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("THUMBNAIL", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("BANNER TITLE", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("REQUIRED DIMENSIONS", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("STATUS", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("ACTIONS", style: _headerStyle),
                ),
              ],
              rows: filtered.asMap().entries.map((entry) {
                final AdminHomeBannerItem item = entry.value;
                final int originalIndex =
                    _banners.indexWhere((e) => e.id == item.id);

                return DataRow(
                  cells: [
                    // Display Order & Reorder Arrows
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryDark.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "#${item.displayOrder}",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: originalIndex > 0
                                    ? () => _moveBanner(originalIndex, -1)
                                    : null,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 18,
                                  color: originalIndex > 0
                                      ? AppTheme.primaryDark
                                      : Colors.grey[300],
                                ),
                              ),
                              InkWell(
                                onTap: originalIndex < _banners.length - 1
                                    ? () => _moveBanner(originalIndex, 1)
                                    : null,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 18,
                                  color: originalIndex < _banners.length - 1
                                      ? AppTheme.primaryDark
                                      : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Thumbnail Preview Cell
                    DataCell(
                      Container(
                        width: 64,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.primaryDark.withValues(alpha: 0.08),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 16,
                                  color: AppTheme.textLight,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Banner Title & ID
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.title,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textDark,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "ID: ${item.id}",
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Required Predefined Dimensions Column
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Desktop: ${item.desktopDimension}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryDark,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Tab: ${item.tabletDimension} | Mob: ${item.mobileDimension}",
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: AppTheme.textLight,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Switch & Chip
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch.adaptive(
                            value: item.isActive,
                            activeTrackColor: const Color(0xFF2E7D32),
                            onChanged: (val) => _toggleStatus(item),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.isActive
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.isActive ? "Active" : "Inactive",
                              style: GoogleFonts.outfit(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: item.isActive
                                    ? const Color(0xFF2E7D32)
                                    : Colors.orange[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions (Edit, Delete)
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit_outlined,
                                color: AppTheme.primaryDark, size: 18),
                            onPressed: () => _openEditDialog(item),
                            tooltip: "Edit Banner",
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red, size: 18),
                            onPressed: () => _deleteBanner(item),
                            tooltip: "Delete Banner",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => GoogleFonts.outfit(
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
        color: AppTheme.textLight,
        letterSpacing: 0.5,
      );
}
