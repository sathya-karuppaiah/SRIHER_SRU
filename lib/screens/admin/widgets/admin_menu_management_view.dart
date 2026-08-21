import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_menu_item.dart';
import 'admin_menu_form_dialog.dart';

class AdminMenuManagementView extends StatefulWidget {
  const AdminMenuManagementView({super.key});

  @override
  State<AdminMenuManagementView> createState() => _AdminMenuManagementViewState();
}

class _AdminMenuManagementViewState extends State<AdminMenuManagementView> {
  // Local mock list state
  late List<AdminHomeMenuItem> _items;

  // Search & Filter state
  String _searchQuery = "";
  String _statusFilter = "All"; // "All", "Active", "Inactive"

  @override
  void initState() {
    super.initState();
    // Load default mock items and sort by display order
    _items = List<AdminHomeMenuItem>.from(AdminHomeMenuItem.defaultMenuItems);
    _sortItems();
  }

  void _sortItems() {
    _items.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  int get _nextDisplayOrder {
    if (_items.isEmpty) return 1;
    final maxOrder = _items.map((e) => e.displayOrder).reduce((a, b) => a > b ? a : b);
    return maxOrder + 1;
  }

  // --- CRUD Operations ---

  void _addItem(AdminHomeMenuItem newItem) {
    setState(() {
      _items.add(newItem);
      _sortItems();
    });
    _showSnackBar("Menu item '${newItem.title}' added successfully.");
  }

  void _updateItem(AdminHomeMenuItem updatedItem) {
    setState(() {
      final index = _items.indexWhere((e) => e.id == updatedItem.id);
      if (index != -1) {
        _items[index] = updatedItem;
        _sortItems();
      }
    });
    _showSnackBar("Menu item '${updatedItem.title}' updated successfully.");
  }

  void _deleteItem(AdminHomeMenuItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                "Delete Menu Item?",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '${item.title}' (${item.route})? This action will remove it from the local menu configuration.",
            style: GoogleFonts.outfit(color: AppTheme.textDark, fontSize: 13.5, height: 1.4),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              child: Text("Cancel", style: GoogleFonts.outfit(color: AppTheme.textDark)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _items.removeWhere((e) => e.id == item.id);
                });
                _showSnackBar("Menu item '${item.title}' deleted.", isWarning: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text("Delete", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _toggleStatus(AdminHomeMenuItem item) {
    final updated = item.copyWith(isActive: !item.isActive);
    _updateItem(updated);
  }

  void _moveItem(int currentIndex, int direction) {
    // direction: -1 for UP, 1 for DOWN
    final targetIndex = currentIndex + direction;
    if (targetIndex < 0 || targetIndex >= _items.length) return;

    setState(() {
      final currentItem = _items[currentIndex];
      final targetItem = _items[targetIndex];

      // Swap display orders
      final currentOrder = currentItem.displayOrder;
      final targetOrder = targetItem.displayOrder;

      _items[currentIndex] = currentItem.copyWith(displayOrder: targetOrder);
      _items[targetIndex] = targetItem.copyWith(displayOrder: currentOrder);

      _sortItems();
    });

    _showSnackBar("Display order updated for '${_items[targetIndex].title}'.");
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AdminMenuFormDialog(
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _addItem,
      ),
    );
  }

  void _openEditDialog(AdminHomeMenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AdminMenuFormDialog(
        initialItem: item,
        nextDisplayOrder: _nextDisplayOrder,
        onSave: _updateItem,
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
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500),
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

  List<AdminHomeMenuItem> get _filteredItems {
    return _items.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.route.toLowerCase().contains(_searchQuery.toLowerCase());

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
    final activeCount = _items.where((e) => e.isActive).length;
    final inactiveCount = _items.where((e) => !e.isActive).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Metric Cards Summary Row
        _buildMetricSummaryRow(activeCount, inactiveCount),

        const SizedBox(height: 20),

        // Controls Bar (Search, Filter Chips, Add Button)
        _buildControlsBar(),

        const SizedBox(height: 16),

        // Data Table / List View Container
        _buildMenuItemsTable(),
      ],
    );
  }

  Widget _buildMetricSummaryRow(int activeCount, int inactiveCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;

        final cards = [
          _buildSummaryCard(
            title: "Total Menu Items",
            value: "${_items.length}",
            subtitle: "Configured navigation links",
            icon: Icons.list_alt,
            accentColor: AppTheme.primaryDark,
          ),
          _buildSummaryCard(
            title: "Active Nav Items",
            value: "$activeCount",
            subtitle: "Visible on public home page",
            icon: Icons.check_circle_outline,
            accentColor: const Color(0xFF2E7D32),
          ),
          _buildSummaryCard(
            title: "Inactive Nav Items",
            value: "$inactiveCount",
            subtitle: "Hidden from public view",
            icon: Icons.visibility_off_outlined,
            accentColor: Colors.orange[800]!,
          ),
          _buildSummaryCard(
            title: "Next Order Index",
            value: "#$_nextDisplayOrder",
            subtitle: "Auto-assigned display order",
            icon: Icons.format_list_numbered,
            accentColor: AppTheme.primaryLight,
          ),
        ];

        if (isWide) {
          return Row(
            children: cards.map((c) => Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: c,
            ))).toList(),
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
            color: Colors.black.withOpacity(0.02),
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
              color: accentColor.withOpacity(0.1),
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
                hintText: "Search menu items or routes...",
                hintStyle: GoogleFonts.outfit(fontSize: 12.5, color: AppTheme.textLight),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.textLight),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryDark : const Color(0xFFE2E8F0),
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

          // Add Menu Item Button
          ElevatedButton.icon(
            onPressed: _openAddDialog,
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: Text(
              "+ Add Menu Item",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemsTable() {
    final filtered = _filteredItems;

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
            const Icon(Icons.find_in_page_outlined, size: 48, color: AppTheme.textLight),
            const SizedBox(height: 12),
            Text(
              "No menu items match your criteria",
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try adjusting your search query or status filter",
              style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight),
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
            color: Colors.black.withOpacity(0.02),
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
                  "Navigation Menu Configuration (${filtered.length})",
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
                Text(
                  "Use arrow buttons to adjust display order",
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
              horizontalMargin: 20,
              columnSpacing: 24,
              columns: [
                DataColumn(
                  label: Text("ORDER", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("MENU ITEM", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("ROUTE / IDENTIFIER", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("STATUS", style: _headerStyle),
                ),
                DataColumn(
                  label: Text("ACTIONS", style: _headerStyle),
                ),
              ],
              rows: filtered.asMap().entries.map((entry) {
                final AdminHomeMenuItem item = entry.value;
                final int originalIndex = _items.indexWhere((e) => e.id == item.id);

                return DataRow(
                  cells: [
                    // Order cell with up/down arrows
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryDark.withOpacity(0.08),
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
                          const SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: originalIndex > 0
                                    ? () => _moveItem(originalIndex, -1)
                                    : null,
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  size: 20,
                                  color: originalIndex > 0
                                      ? AppTheme.primaryDark
                                      : Colors.grey[300],
                                ),
                              ),
                              InkWell(
                                onTap: originalIndex < _items.length - 1
                                    ? () => _moveItem(originalIndex, 1)
                                    : null,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: originalIndex < _items.length - 1
                                      ? AppTheme.primaryDark
                                      : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Menu title with icon avatar
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: item.isActive
                                  ? AppTheme.primaryDark.withOpacity(0.08)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: item.isActive
                                  ? AppTheme.primaryDark
                                  : AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                "ID: ${item.id}",
                                style: GoogleFonts.outfit(
                                  fontSize: 10.5,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Route identifier
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.link, size: 14, color: AppTheme.textLight),
                            const SizedBox(width: 6),
                            Text(
                              item.route,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textDark,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Status Switch & Chip
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch.adaptive(
                            value: item.isActive,
                            activeColor: const Color(0xFF2E7D32),
                            onChanged: (val) => _toggleStatus(item),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: item.isActive
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.isActive ? "Active" : "Inactive",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
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
                            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryDark, size: 18),
                            onPressed: () => _openEditDialog(item),
                            tooltip: "Edit Menu Item",
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            onPressed: () => _deleteItem(item),
                            tooltip: "Delete Menu Item",
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
