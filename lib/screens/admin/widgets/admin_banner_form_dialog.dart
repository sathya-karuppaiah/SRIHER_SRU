import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_banner_item.dart';

class AdminBannerFormDialog extends StatefulWidget {
  final AdminHomeBannerItem? initialItem;
  final int nextDisplayOrder;
  final ValueChanged<AdminHomeBannerItem> onSave;

  const AdminBannerFormDialog({
    super.key,
    this.initialItem,
    required this.nextDisplayOrder,
    required this.onSave,
  });

  @override
  State<AdminBannerFormDialog> createState() => _AdminBannerFormDialogState();
}

class _AdminBannerFormDialogState extends State<AdminBannerFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late TextEditingController _orderController;

  bool _isActive = true;
  bool _isDimensionVerified = true;
  String _previewUrl = "";

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;

    _titleController = TextEditingController(text: item?.title ?? '');
    _imageUrlController = TextEditingController(text: item?.imageUrl ?? '');
    _orderController = TextEditingController(
        text: (item?.displayOrder ?? widget.nextDisplayOrder).toString());

    _isActive = item?.isActive ?? true;
    _previewUrl = item?.imageUrl ?? '';

    _imageUrlController.addListener(() {
      setState(() {
        _previewUrl = _imageUrlController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isDimensionVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please verify that your banner matches the required responsive dimensions.",
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    final String title = _titleController.text.trim();
    final String imageUrl = _imageUrlController.text.trim();
    final int displayOrder = int.parse(_orderController.text.trim());

    final bannerItem = AdminHomeBannerItem(
      id: widget.initialItem?.id ??
          'banner_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      imageUrl: imageUrl,
      desktopDimension: AdminHomeBannerItem.defaultDesktopDim,
      tabletDimension: AdminHomeBannerItem.defaultTabletDim,
      mobileDimension: AdminHomeBannerItem.defaultMobileDim,
      displayOrder: displayOrder,
      isActive: _isActive,
    );

    widget.onSave(bannerItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title & Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDark.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _isEditing
                                ? Icons.edit_calendar
                                : Icons.add_photo_alternate_outlined,
                            color: AppTheme.primaryDark,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing
                                  ? "Edit Carousel Banner"
                                  : "Add New Carousel Banner",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            Text(
                              _isEditing
                                  ? "Update hero banner details & display settings"
                                  : "Configure a new hero banner for the homepage",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textLight),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 20),

                // Banner Title Field
                Text(
                  "BANNER TITLE / HEADING *",
                  style: _fieldLabelStyle,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.outfit(
                      fontSize: 13.5, color: AppTheme.textDark),
                  decoration: _inputDecoration(
                    hint: "e.g. Welcome to SRIHER - Admissions Open 2026",
                    icon: Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Banner title is required";
                    }
                    if (value.trim().length < 3) {
                      return "Title must be at least 3 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Strict Predefined Dimensions Notice Card
                _buildStrictDimensionsCard(),

                const SizedBox(height: 16),

                // Image URL Field
                Text(
                  "IMAGE URL / PATH *",
                  style: _fieldLabelStyle,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _imageUrlController,
                  style: GoogleFonts.outfit(
                      fontSize: 13.5, color: AppTheme.textDark),
                  decoration: _inputDecoration(
                    hint: "https://example.com/banner.jpg or assets/banner.png",
                    icon: Icons.image_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Image URL or asset path is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Live Image Thumbnail Preview Container
                _buildImagePreviewCard(),

                const SizedBox(height: 16),

                // Dimension Compliance Verification Checkbox
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isDimensionVerified
                          ? const Color(0xFFCBD5E1)
                          : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isDimensionVerified,
                        activeColor: AppTheme.primaryDark,
                        onChanged: (val) {
                          setState(() {
                            _isDimensionVerified = val ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "I confirm this banner image matches the required predefined dimensions (Desktop: 1920×600, Tablet: 1280×500, Mobile: 768×900 px).",
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Display Order & Active Status Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Order Input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DISPLAY ORDER *",
                            style: _fieldLabelStyle,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _orderController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.outfit(
                                fontSize: 13.5, color: AppTheme.textDark),
                            decoration: _inputDecoration(
                              hint: "1",
                              icon: Icons.format_list_numbered,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter display order";
                              }
                              final val = int.tryParse(value.trim());
                              if (val == null || val <= 0) {
                                return "Order must be >= 1";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Active Toggle Container
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "STATUS TOGGLE",
                            style: _fieldLabelStyle,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _isActive ? "Active" : "Inactive",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _isActive
                                        ? const Color(0xFF2E7D32)
                                        : Colors.orange[800],
                                  ),
                                ),
                                Switch.adaptive(
                                  value: _isActive,
                                  activeTrackColor: const Color(0xFF2E7D32),
                                  onChanged: (val) {
                                    setState(() {
                                      _isActive = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
                const SizedBox(height: 16),

                // Action Buttons (Cancel / Save)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _isDimensionVerified ? _submitForm : null,
                      icon: const Icon(Icons.check, size: 18, color: Colors.white),
                      label: Text(
                        _isEditing ? "Save Changes" : "Create Banner",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        disabledBackgroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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

  Widget _buildStrictDimensionsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryDark.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.straighten, size: 18, color: AppTheme.primaryDark),
              const SizedBox(width: 8),
              Text(
                "STRICT REQUIRED IMAGE DIMENSIONS",
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDark,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildDimensionBadge(
                  device: "Desktop",
                  dimension: "1920 × 600 px",
                  icon: Icons.desktop_windows,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDimensionBadge(
                  device: "Tablet",
                  dimension: "1280 × 500 px",
                  icon: Icons.tablet_mac,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDimensionBadge(
                  device: "Mobile",
                  dimension: "768 × 900 px",
                  icon: Icons.smartphone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Custom/arbitrary dimensions are not allowed. Provide high-resolution assets formatted to these exact breakpoints.",
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppTheme.textLight,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionBadge({
    required String device,
    required String dimension,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryDark),
          const SizedBox(height: 4),
          Text(
            device,
            style: GoogleFonts.outfit(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          Text(
            dimension,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewCard() {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: _previewUrl.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined,
                        size: 32, color: AppTheme.textLight),
                    const SizedBox(height: 6),
                    Text(
                      "Enter image URL above to preview thumbnail",
                      style: GoogleFonts.outfit(
                          fontSize: 12, color: AppTheme.textLight),
                    ),
                  ],
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _previewUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.broken_image_outlined,
                                size: 32, color: Colors.red),
                            const SizedBox(height: 6),
                            Text(
                              "Unable to load image preview from URL",
                              style: GoogleFonts.outfit(
                                  fontSize: 12, color: Colors.red[700]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "LIVE PREVIEW",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.outfit(fontSize: 13, color: AppTheme.textLight),
      prefixIcon: Icon(icon, size: 18, color: AppTheme.textLight),
      filled: true,
      fillColor: AppTheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryDark, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }

  TextStyle get _fieldLabelStyle => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
        letterSpacing: 0.5,
      );
}
