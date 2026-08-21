import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_sdg_item.dart';
import 'admin_sdg_form_dialog.dart';

class AdminSdgManagementView extends StatefulWidget {
  const AdminSdgManagementView({super.key});

  @override
  State<AdminSdgManagementView> createState() =>
      _AdminSdgManagementViewState();
}

class _AdminSdgManagementViewState extends State<AdminSdgManagementView> {
  // Local mock state list for SDG goal items
  late List<AdminHomeSdgItem> _sdgItems;

  // Search & Filter state
  String _searchQuery = "";
  String _statusFilter = "All"; // "All", "Active", "Inactive"

  @override
  void initState() {
    super.initState();
    _sdgItems = List<AdminHomeSdgItem>.from(AdminHomeSdgItem.defaultSdgItems);
    _sortAndNormalizeOrders();
  }

  /// Sorts by display order and normalizes displayOrder sequentially starting from 1
  void _sortAndNormalizeOrders() {
    _sdgItems.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    _normalizeOrders();
  }

  /// Recalculates displayOrder sequentially 1, 2, 3, 4... with no duplicates or gaps
  void _normalizeOrders() {
    for (int i = 0; i < _sdgItems.length; i++) {
      _sdgItems[i] = _sdgItems[i].copyWith(displayOrder: i + 1);
    }
  }

  int get _nextDisplayOrder => _sdgItems.length + 1;

  // --- CRUD Operations ---

  void _addSdgItem(AdminHomeSdgItem newItem) {
    setState(() {
      _sdgItems.add(newItem);
      _normalizeOrders();
    });
    _showSnackBar("SDG Goal #${newItem.goalNumber} added successfully.");
  }

  void _updateSdgItem(AdminHomeSdgItem updatedItem) {
    setState(() {
      final index = _sdgItems.indexWhere((e) => e.id == updatedItem.id);
      if (index != -1) {
        _sdgItems[index] = updatedItem;
        _sortAndNormalizeOrders();
      }
    });
    _showSnackBar("SDG Goal #${updatedItem.goalNumber} updated successfully.");
  }

  void _deleteSdgItem(AdminHomeSdgItem item) {
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
                "Delete SDG Goal Card?",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete 'SDG ${item.goalNumber}: ${item.title}'? This card will be removed from the homepage SDG section.",
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
                  _sdgItems.removeWhere((e) => e.id == item.id);
                  _normalizeOrders();
                });
                _showSnackBar("SDG Goal #${item.goalNumber} deleted.", isWarning: true);
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

  void _toggleStatus(AdminHomeSdgItem item) {
    final updated = item.copyWith(isActive: !item.isActive);
    _updateSdgItem(updated);
  }

  void _moveSdgItem(int currentIndex, int direction) {
    final targetIndex = currentIndex + direction;
    if (targetIndex < 0 || targetIndex >= _sdgItems.length) return;

    setState(() {
      final item = _sdgItems.removeAt(currentIndex);
      _sdgItems.insert(targetIndex, item);
      _normalizeOrders();
    });

    _showSnackBar("Display order normalized for 'SDG ${_sdgItems[targetIndex].goalNumber}'.");
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AdminSdgFormDialog(
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _addSdgItem,
      ),
    );
  }

  void _openEditDialog(AdminHomeSdgItem item) {
    showDialog(
      context: context,
      builder: (context) => AdminSdgFormDialog(
        initialItem: item,
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _updateSdgItem,
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

  List<AdminHomeSdgItem> get _filteredSdgItems {
    return _sdgItems.where((item) {
      final matchesSearch = item.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          "sdg ${item.goalNumber}"
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      if (_statusFilter == "Active") {
        return matchesSearch && item.isActive;
      } else if (_statusFilter == "Inactive") {
        return matchesSearch && !item.isActive;
      }
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _sdgItems.where((e) => e.isActive).length;
    final inactiveCount = _sdgItems.where((e) => !e.isActive).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Metric Summary Cards
        _buildMetricSummaryRow(activeCount, inactiveCount),

        const SizedBox(height: 20),

        // Controls Bar (Search, Filter Chips, Add SDG Button)
        _buildControlsBar(),

        const SizedBox(height: 16),

        // SDG Table Container
        _buildSdgTable(),
      ],
    );
  }

  Widget _buildMetricSummaryRow(int activeCount, int inactiveCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;

        final cards = [
          _buildSummaryCard(
            title: "Total SDG Goals",
            value: "${_sdgItems.length}",
            subtitle: "Featured goal cards",
            icon: Icons.public,
            accentColor: AppTheme.primaryDark,
          ),
          _buildSummaryCard(
            title: "Active Cards",
            value: "$activeCount",
            subtitle: "Live on public home page",
            icon: Icons.check_circle_outline,
            accentColor: const Color(0xFF2E7D32),
          ),
          _buildSummaryCard(
            title: "Inactive Cards",
            value: "$inactiveCount",
            subtitle: "Draft/Hidden cards",
            icon: Icons.visibility_off_outlined,
            accentColor: Colors.orange[800]!,
          ),
          _buildSummaryCard(
            title: "Card Format",
            value: "400 × 400",
            subtitle: "Strict 1:1 ratio dimension",
            icon: Icons.crop_square,
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
                    fontSize: 19,
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
                hintText: "Search SDG goals...",
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

          // Add SDG Goal Button
          ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: Text(
              "+ Add SDG Goal",
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

  Widget _buildSdgTable() {
    final filtered = _filteredSdgItems;

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
            const Icon(Icons.public_off_outlined,
                size: 48, color: AppTheme.textLight),
            const SizedBox(height: 12),
            Text(
              "No SDG goal cards match your criteria",
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
                  "SDG Goal Cards (${filtered.length})",
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  "All cards strictly format to 400 × 400 px with unique sequential orders",
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
              columnSpacing: 18,
              columns: [
                DataColumn(
                  label: Text("ORDER", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("SDG #", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("THUMBNAIL", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("GOAL NAME", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("CARD DIMENSION", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("HYPERLINK", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("STATUS", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("ACTIONS", style: _headerStyle),
                ),
              ],
              rows: filtered.asMap().entries.map((entry) {
                final AdminHomeSdgItem item = entry.value;
                final int originalIndex =
                    _sdgItems.indexWhere((e) => e.id == item.id);

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
                                    ? () => _moveSdgItem(originalIndex, -1)
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
                                onTap: originalIndex < _sdgItems.length - 1
                                    ? () => _moveSdgItem(originalIndex, 1)
                                    : null,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 18,
                                  color: originalIndex < _sdgItems.length - 1
                                      ? AppTheme.primaryDark
                                      : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Goal Number Badge
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "SDG ${item.goalNumber}",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ),

                    // Square Thumbnail Preview Cell (400x400 aspect ratio)
                    DataCell(
                      Container(
                        width: 44,
                        height: 44,
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
                                  Icons.broken_image_outlined,
                                  size: 18,
                                  color: AppTheme.textLight,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Goal Name Title
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
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

                    // Fixed Card Dimension Badge (400 x 400 px)
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.crop_square,
                                size: 14, color: AppTheme.primaryDark),
                            const SizedBox(width: 4),
                            Text(
                              item.cardDimension,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textDark,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Hyperlink URL
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          item.hyperlink,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            color: const Color(0xFF1565C0),
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                            tooltip: "Edit SDG Goal",
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red, size: 18),
                            onPressed: () => _deleteSdgItem(item),
                            tooltip: "Delete SDG Goal",
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
