import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SdgGoalsScreen extends StatelessWidget {
  final bool showBackButton;
  const SdgGoalsScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkAccent, // Premium dark theme matching navy blue theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : null,
        title: Center(
          child: Text(
            "SDG Goals",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: const [
          SizedBox(width: 48), // Balancing title
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 80),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: sdgGoals.length,
              itemBuilder: (context, index) {
                final goal = sdgGoals[index];
                return _buildGoalCard(context, goal);
              },
            ),
          ),
          // Colorful SDG Wheel badge in bottom right corner
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryDark,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: CustomPaint(
                  painter: SdgWheelPainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, SDGGoal goal) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showGoalDetailDialog(context, goal);
        },
        child: Image.asset(
          goal.imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void _showGoalDetailDialog(BuildContext context, SDGGoal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          backgroundColor: AppTheme.primaryDark,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    goal.imagePath,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  goal.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Goal ${goal.number} is part of the 17 Global Goals for Sustainable Development. This event platform features conferences, workshops, and exhibitions aimed at raising awareness and driving actions to fulfill this goal.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goal.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(120, 44),
                  ),
                  child: Text(
                    "Close",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Painter for the SDG Color Wheel in the bottom corner
class SdgWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Rect rect = Rect.fromCircle(center: center, radius: radius - 6);

    final List<Color> colors = [
      const Color(0xFFE5243B), // 1
      const Color(0xFFDDA63A), // 2
      const Color(0xFF4C9F38), // 3
      const Color(0xFFC5192D), // 4
      const Color(0xFFFF3A21), // 5
      const Color(0xFF26BDE2), // 6
      const Color(0xFFFCC30B), // 7
      const Color(0xFFA21942), // 8
      const Color(0xFFFD6925), // 9
      const Color(0xFFDD1367), // 10
      const Color(0xFFFD9D24), // 11
      const Color(0xFFC28B23), // 12
      const Color(0xFF3F7E44), // 13
      const Color(0xFF0A97D9), // 14
      const Color(0xFF56C02B), // 15
      const Color(0xFF00689D), // 16
      const Color(0xFF19486A), // 17
    ];

    final double sweepAngle = 2 * 3.1415926535 / colors.length;
    double startAngle = -3.1415926535 / 2;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;
      canvas.drawArc(rect, startAngle, sweepAngle - 0.05, false, paint);
      startAngle += sweepAngle;
    }

    // Inner details of the wheel
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 15, innerPaint);

    final logoPaint = Paint()
      ..color = AppTheme.darkAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 20, logoPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
