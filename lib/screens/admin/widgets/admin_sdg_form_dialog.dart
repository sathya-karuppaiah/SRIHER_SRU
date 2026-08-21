import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../models/admin_home_sdg_item.dart';

class AdminSdgFormDialog extends StatefulWidget {
  final AdminHomeSdgItem? initialItem;
  final int nextDisplayOrder;
  final ValueChanged<AdminHomeSdgItem> onSave;

  const AdminSdgFormDialog({
    super.key,
    this.initialItem,
    required this.nextDisplayOrder,
    required this.onSave,
  });

  @override
  State<AdminSdgFormDialog> createState() => _AdminSdgFormDialogState();
}

class _AdminSdgFormDialogState extends State<AdminSdgFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _goalNumberController;
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late TextEditingController _hyperlinkController;
  late TextEditingController _orderController;

  bool _isActive = true;
  bool _isDimensionVerified = true;
  String _previewUrl = "";

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;

    _goalNumberController =
        TextEditingController(text: (item?.goalNumber ?? 1).toString());
    _titleController = TextEditingController(text: item?.title ?? '');
    _imageUrlController = TextEditingController(text: item?.imageUrl ?? '');
    _hyperlinkController = TextEditingController(
        text: item?.hyperlink ?? 'https://sdgs.un.org/goals');
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
    _goalNumberController.dispose();
    _titleController.dispose();
    _imageUrlController.dispose();
    _hyperlinkController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_isDimensionVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please confirm that the image matches the strict 400 × 400 px card dimension requirement.",
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        ),
      );
      return;
    }

    final int goalNumber = int.parse(_goalNumberController.text.trim());
    final String title = _titleController.text.trim();
    final String imageUrl = _imageUrlController.text.trim();
    final String hyperlink = _hyperlinkController.text.trim();
    final int displayOrder = int.parse(_orderController.text.trim());

    final sdgItem = AdminHomeSdgItem(
      id: widget.initialItem?.id ??
          'sdg_${goalNumber}_${DateTime.now().millisecondsSinceEpoch}',
      goalNumber: goalNumber,
      title: title,
      imageUrl: imageUrl,
      cardDimension: AdminHomeSdgItem.fixedDimension,
      hyperlink: hyperlink,
      displayOrder: displayOrder,
      isActive: _isActive,
    );

    widget.onSave(sdgItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
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
                                ? Icons.edit_note
                                : Icons.public_outlined,
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
                                  ? "Edit SDG Goal Card"
                                  : "Add New SDG Goal Card",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            Text(
                              _isEditing
                                  ? "Update UN SDG Goal card details & hyperlink"
                                  : "Highlight a UN Sustainable Development Goal on homepage",
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

                // Row: SDG Goal Number & Goal Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Goal Number
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SDG NUMBER *",
                            style: _fieldLabelStyle,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _goalNumberController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.outfit(
                                fontSize: 13.5, color: AppTheme.textDark),
                            decoration: _inputDecoration(
                              hint: "3",
                              icon: Icons.tag,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Required";
                              }
                              final val = int.tryParse(value.trim());
                              if (val == null || val <= 0 || val > 17) {
                                return "1 to 17";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Goal Name Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SDG GOAL NAME *",
                            style: _fieldLabelStyle,
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _titleController,
                            style: GoogleFonts.outfit(
                                fontSize: 13.5, color: AppTheme.textDark),
                            decoration: _inputDecoration(
                              hint: "e.g. Good Health and Well-Being",
                              icon: Icons.subtitles_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "SDG goal name is required";
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

                // Card Dimension Info Banner (Strict 400 x 400 px)
                _buildCardDimensionInfoBox(),

                const SizedBox(height: 16),

                // Image URL Field
                Text(
                  "CARD IMAGE URL / PATH *",
                  style: _fieldLabelStyle,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _imageUrlController,
                  style: GoogleFonts.outfit(
                      fontSize: 13.5, color: AppTheme.textDark),
                  decoration: _inputDecoration(
                    hint: "https://sdgs.un.org/sites/default/files/goals/E_SDG_GOALS_FINAL-03.png",
                    icon: Icons.image_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Card image URL is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Live Thumbnail Preview (Square 400x400 aspect ratio)
                _buildSquareImagePreviewCard(),

                const SizedBox(height: 16),

                // Hyperlink URL Field
                Text(
                  "HYPERLINK URL *",
                  style: _fieldLabelStyle,
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _hyperlinkController,
                  style: GoogleFonts.outfit(
                      fontSize: 13.5, color: AppTheme.textDark),
                  decoration: _inputDecoration(
                    hint: "https://sdgs.un.org/goals/goal3",
                    icon: Icons.link,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Hyperlink URL is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Dimension Verification Checkbox
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
                          "I confirm this card image matches the strict required 400 × 400 px aspect dimension.",
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
                        _isEditing ? "Save Changes" : "Create Goal Card",
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

  Widget _buildCardDimensionInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryDark.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.crop_square,
                size: 20, color: AppTheme.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "STRICT CARD DIMENSION: 400 × 400 PX",
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "SDG goal cards require square 1:1 format (400 × 400 px). Arbitrary dimensions are not accepted.",
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareImagePreviewCard() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: _previewUrl.isEmpty
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.crop_square,
                        size: 24, color: AppTheme.textLight),
                    const SizedBox(width: 8),
                    Text(
                      "Enter image URL to preview 400 × 400 px card",
                      style: GoogleFonts.outfit(
                          fontSize: 12, color: AppTheme.textLight),
                    ),
                  ],
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        _previewUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              "Unable to load image URL",
                              style: GoogleFonts.outfit(
                                  fontSize: 11, color: Colors.red[700]),
                            ),
                          );
                        },
                      ),
                    ),
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
                        "400 × 400 PX PREVIEW",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
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
