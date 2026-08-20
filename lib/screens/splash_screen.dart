import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Navigate to MainNavigationScreen after 4 seconds if not on admin route
    Timer(const Duration(milliseconds: 4000), () {
      if (mounted) {
        final fragment = Uri.base.fragment;
        final path = Uri.base.path;
        final routeName = ModalRoute.of(context)?.settings.name;
        if (fragment.contains('admin') || path.contains('admin') || (routeName != null && routeName.contains('/admin'))) {
          return; // Do NOT redirect if Admin Dashboard was opened!
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDotGrid(int rows, int cols, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(rows, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(cols, (c) {
            return Container(
              width: 3.5,
              height: 3.5,
              margin: const EdgeInsets.all(3.5),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Solid background matching the building sketch background color
          Container(
            width: size.width,
            height: size.height,
            color: const Color(0xFFFBFCFB),
          ),

          // 2. Decorative concentric arches in top-right
          Positioned(
            top: -20,
            right: -20,
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: ElegantArchesPainter(color: const Color(0xFFD31A14).withOpacity(0.06)),
              ),
            ),
          ),

          // 3. Dot Grids for texture
          Positioned(
            left: 16,
            top: size.height * 0.15,
            child: _buildDotGrid(8, 4, const Color(0xFFD31A14).withOpacity(0.18)),
          ),
          Positioned(
            right: 16,
            top: size.height * 0.45,
            child: _buildDotGrid(8, 4, const Color(0xFFD31A14).withOpacity(0.18)),
          ),

          // 4. Highly Visible Hospital Sketch at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.35,
              child: Opacity(
                opacity: 0.85, // Highly visible!
                child: Image.asset(
                  'assets/building_sketch.jpg',
                  width: size.width,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),

          // 5. Main Center Content (No card container, directly in center of screen)
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Red Logo
                        Image.asset(
                          'assets/sriher_logo.png',
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.shield,
                              color: Color(0xFFD31A14),
                              size: 80,
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Brand Label
                        Text(
                          "— SRIHER —",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9E8482),
                            letterSpacing: 4.0,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // App Name
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "BACK",
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFD31A14),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              TextSpan(
                                text: "STAGE",
                                style: GoogleFonts.outfit(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF1B205D),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Tagline
                        Text(
                          "Event Management Simplified",
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF7A6E71),
                            letterSpacing: 0.5,
                        ),
                        ),
                        const SizedBox(height: 36),

                        // Linear Progress Bar
                        Container(
                          width: 140,
                          height: 4,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xFFF7D5D4),
                          ),
                          child: const LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFD31A14),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Loading Text
                        Text(
                          "Loading great experiences...",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: const Color(0xFFD31A14),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        
                        // Extra space to offset the building image at the bottom
                        SizedBox(height: size.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Minimal, elegant concentric arches background detail
class ElegantArchesPainter extends CustomPainter {
  final Color color;
  ElegantArchesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final center = Offset(size.width, 0);
    canvas.drawCircle(center, 120, paint);
    canvas.drawCircle(center, 170, paint);
    canvas.drawCircle(center, 220, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
