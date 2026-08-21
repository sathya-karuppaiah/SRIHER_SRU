import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_menu_item.dart';

class AdminMenuFormDialog extends StatefulWidget {
  final AdminHomeMenuItem? initialItem;
  final int nextDisplayOrder;
  final ValueChanged<AdminHomeMenuItem> onSave;

  const AdminMenuFormDialog({
    super.key,
    this.initialItem,
    required this.nextDisplayOrder,
    required this.onSave,
  });

  @override
  State<AdminMenuFormDialog> createState() => _AdminMenuFormDialogState();
}

class _AdminMenuFormDialogState extends State<AdminMenuFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _routeController;
  late TextEditingController _orderController;
  late IconData _selectedIcon;
  late bool _isActive;

  // Available icon selection palette for public navigation menu items
  static const List<Map<String, dynamic>> _availableIcons = [
    {'name': 'Home', 'icon': Icons.home_outlined},
    {'name': 'Events', 'icon': Icons.calendar_today_outlined},
    {'name': 'SDG / World', 'icon': Icons.public_outlined},
    {'name': 'Tickets', 'icon': Icons.confirmation_number_outlined},
    {'name': 'Profile', 'icon': Icons.person_outline},
    {'name': 'Info', 'icon': Icons.info_outline},
    {'name': 'Phone', 'icon': Icons.phone_outlined},
    {'name': 'School', 'icon': Icons.school_outlined},
    {'name': 'News', 'icon': Icons.newspaper_outlined},
    {'name': 'Campaign', 'icon': Icons.campaign_outlined},
    {'name': 'Search', 'icon': Icons.search_outlined},
    {'name': 'Bookmark', 'icon': Icons.bookmark_outline},
    {'name': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'name': 'Notifications', 'icon': Icons.notifications_outlined},
    {'name': 'Help', 'icon': Icons.help_outline},
    {'name': 'Settings', 'icon': Icons.settings_outlined},
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _titleController = TextEditingController(text: item?.title ?? '');
    _routeController = TextEditingController(text: item?.route ?? '');
    _orderController = TextEditingController(
      text: (item?.displayOrder ?? widget.nextDisplayOrder).toString(),
    );
    _selectedIcon = item?.icon ?? Icons.home_outlined;
    _isActive = item?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _routeController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final String id = widget.initialItem?.id ??
          'menu_${DateTime.now().millisecondsSinceEpoch}';
      final int order = int.tryParse(_orderController.text.trim()) ??
          widget.nextDisplayOrder;

      final newItem = AdminHomeMenuItem(
        id: id,
        title: _titleController.text.trim(),
        icon: _selectedIcon,
        route: _routeController.text.trim(),
        displayOrder: order,
        isActive: _isActive,
      );

      widget.onSave(newItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialItem != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: AppTheme.surface,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isEditing ? Icons.edit_note : Icons.add_link,
                        color: AppTheme.primaryDark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? "Edit Menu Item" : "Add New Menu Item",
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          Text(
                            "Configure navigation label, icon, route, and order",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textLight),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: "Close",
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 20),

                // Form Fields
                // 1. Menu Title
                Text(
                  "Menu Title *",
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.textDark),
                  decoration: _buildInputDecoration(
                    hintText: "e.g., Upcoming Events, Campus Life",
                    prefixIcon: Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a menu title";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // 2. Route / Page Identifier & Display Order Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Route / Identifier *",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _routeController,
                            style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.textDark),
                            decoration: _buildInputDecoration(
                              hintText: "e.g., /events or events_screen",
                              prefixIcon: Icons.link,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please enter a route identifier";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Display Order *",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _orderController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: GoogleFonts.outfit(fontSize: 14, color: AppTheme.textDark),
                            decoration: _buildInputDecoration(
                              hintText: "Order (1..N)",
                              prefixIcon: Icons.format_list_numbered,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Icon Selection Grid
                Text(
                  "Select Icon *",
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableIcons.map((item) {
                      final IconData icon = item['icon'];
                      final String name = item['name'];
                      final isSelected = _selectedIcon.codePoint == icon.codePoint;

                      return Tooltip(
                        message: name,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryDark
                                  : AppTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryDark
                                    : const Color(0xFFCBD5E1),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              size: 22,
                              color: isSelected ? Colors.white : AppTheme.textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Status Toggle Switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? const Color(0xFFE8F5E9)
                        : Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isActive
                          ? const Color(0xFFA5D6A7)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isActive ? Icons.check_circle : Icons.visibility_off,
                            color: _isActive
                                ? const Color(0xFF2E7D32)
                                : Colors.orange[800],
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Menu Status",
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Text(
                                _isActive
                                    ? "Active — Visible on public app"
                                    : "Inactive — Hidden from navigation",
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _isActive,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (val) {
                          setState(() {
                            _isActive = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: Icon(
                        isEditing ? Icons.save : Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        isEditing ? "Save Changes" : "Add Menu Item",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryLight,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight),
      prefixIcon: Icon(prefixIcon, size: 18, color: AppTheme.textLight),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: AppTheme.background,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
