import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onViewAllEvents;
  final Function(int) onViewAllSdg;
  final Function() onRegisterSuccess;

  const HomeScreen({
    super.key,
    required this.onViewAllEvents,
    required this.onViewAllSdg,
    required this.onRegisterSuccess,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _carouselIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Featured events (using first event from sample)
    final featuredEvent = sampleEvents[0];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Header Block (Green gradient wave feeling)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF031624), AppTheme.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drawer Icon & Notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                              onPressed: () {},
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Greeting text
                    Text(
                      "Hello, Gokul! 👋",
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Let's create a sustainable future together.",
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search events, speakers, topics...",
                          hintStyle: GoogleFonts.outfit(color: AppTheme.textLight, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryDark),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.tune, color: AppTheme.primaryDark, size: 18),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Featured Event Section
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slideable Card (Real PageView Carousel)
                    SizedBox(
                      height: 190,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _carouselIndex = index;
                          });
                        },
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final event = sampleEvents[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsScreen(
                                    event: event,
                                    onRegisterSuccess: widget.onRegisterSuccess,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ClipPath(
                                clipper: CardWaveClipper(),
                                child: Container(
                                  color: const Color(0xFFFAF0EE),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final cardWidth = constraints.maxWidth;
                                      final cardHeight = constraints.maxHeight;

                                      return Stack(
                                        children: [
                                          // 1. Right side building sketch background
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            width: cardWidth * 0.65,
                                            child: Image.asset(
                                              'assets/building_sketch.jpg',
                                              fit: BoxFit.cover,
                                              alignment: Alignment.centerLeft,
                                              color: const Color(0xFFFAF0EE),
                                              colorBlendMode: BlendMode.multiply,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const SizedBox();
                                              },
                                            ),
                                          ),

                                          // 2. Birds Painter in the sky
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            width: cardWidth * 0.6,
                                            height: cardHeight * 0.5,
                                            child: CustomPaint(
                                              painter: BirdsPainter(),
                                            ),
                                          ),

                                          // 3. SRIHER Red Logo Overlay on the Building
                                          Positioned(
                                            right: cardWidth * 0.16,
                                            top: cardHeight * 0.32,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/sriher_logo.png',
                                                  height: 28,
                                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                                    Icons.shield,
                                                    color: Color(0xFFD31A14),
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  "SRIHER",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(0xFF1B205D),
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // 4a. Outer Lighter Red Wave (glow overlay)
                                          Positioned.fill(
                                            child: ClipPath(
                                              clipper: FeaturedWaveClipper(),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFE53935), // Vibrant red/coral
                                                      Color(0xFFBA1A1A), // Brand red
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 4b. Inner Darker Red Wave
                                          Positioned.fill(
                                            child: ClipPath(
                                              clipper: InnerWaveClipper(),
                                              child: Container(
                                                color: const Color(0xFFBA1A1A), // Brand red
                                              ),
                                            ),
                                          ),

                                          // 5. Left Section Content
                                          Positioned(
                                            left: 20,
                                            top: 18,
                                            bottom: 18,
                                            width: cardWidth * 0.44,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      index == 0
                                                          ? "Plan. Manage.\nDeliver. Repeat."
                                                          : index == 1
                                                              ? "Learn. Grow.\nSustain. Adapt."
                                                              : "Build. Connect.\nInnovate. Lead.",
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1.15,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      index == 0
                                                          ? "Your events,\nour expertise."
                                                          : index == 1
                                                              ? "Sustainability and\ninnovation goals."
                                                              : "Together, for a\ngreener campus.",
                                                      style: GoogleFonts.outfit(
                                                        color: const Color(0xFFF7D5D4),
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1.25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Dynamic Action Button
                                                UnconstrainedBox(
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF031624),
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 16,
                                                          height: 16,
                                                          decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              index == 0
                                                                  ? Icons.add
                                                                  : index == 1
                                                                      ? Icons.rocket_launch
                                                                      : Icons.videocam,
                                                              size: 10,
                                                              color: const Color(0xFF031624),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          index == 0
                                                              ? "Create Event"
                                                              : index == 1
                                                                  ? "Join Challenge"
                                                                  : "Register Now",
                                                          style: GoogleFonts.outfit(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Carousel Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          width: index == _carouselIndex ? 16 : 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: index == _carouselIndex 
                                ? const Color(0xFFBA1A1A) 
                                : const Color(0xFFD1D1D6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // 3. Explore SDG Goals
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore SDG Goals",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onViewAllSdg(2), // Switch to SDG Goals tab
                      child: Text(
                        "View All",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Horizontal list of goals
              SizedBox(
                height: 120,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5, // Just show first 5 on home
                  itemBuilder: (context, index) {
                    final goal = sdgGoals[index + 2]; // Show Good Health, Education, Gender, Clean Water, Clean Energy
                    return GestureDetector(
                      onTap: () => widget.onViewAllSdg(2), // Switch to SDG Goals tab
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            goal.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 4. Upcoming Events
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcoming Events",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onViewAllEvents(1), // Switch to Events tab
                      child: Text(
                        "View All",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // List of upcoming events
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 2, // Show two items matching screenshot
                itemBuilder: (context, index) {
                  final event = sampleEvents[index + 1]; // Skip featured
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(
                            event: event,
                            onRegisterSuccess: widget.onRegisterSuccess,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Left Date block
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  index == 0 ? "JUL" : "JUL",
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryLight,
                                  ),
                                ),
                                Text(
                                  index == 0 ? "28" : "30",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Content details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  event.subtitle,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppTheme.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: AppTheme.textLight, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      event.location,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: AppTheme.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Right Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              event.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
     ),
    );
  }
}

class FeaturedWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.38, size.height);

    path.cubicTo(
      size.width * 0.36, size.height * 0.65,
      size.width * 0.54, size.height * 0.45,
      size.width * 0.54, 0,
    );

    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class InnerWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.28, size.height);

    path.cubicTo(
      size.width * 0.26, size.height * 0.65,
      size.width * 0.44, size.height * 0.45,
      size.width * 0.44, 0,
    );

    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class BirdsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B7280).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Bird 1
    final path1 = Path();
    path1.moveTo(size.width * 0.25, size.height * 0.15);
    path1.quadraticBezierTo(size.width * 0.27, size.height * 0.12, size.width * 0.29, size.height * 0.16);
    path1.quadraticBezierTo(size.width * 0.31, size.height * 0.12, size.width * 0.33, size.height * 0.15);
    canvas.drawPath(path1, paint);

    // Bird 2
    final path2 = Path();
    path2.moveTo(size.width * 0.55, size.height * 0.1);
    path2.quadraticBezierTo(size.width * 0.57, size.height * 0.08, size.width * 0.59, size.height * 0.11);
    path2.quadraticBezierTo(size.width * 0.61, size.height * 0.08, size.width * 0.63, size.height * 0.1);
    canvas.drawPath(path2, paint);

    // Bird 3
    final path3 = Path();
    path3.moveTo(size.width * 0.72, size.height * 0.18);
    path3.quadraticBezierTo(size.width * 0.74, size.height * 0.16, size.width * 0.76, size.height * 0.19);
    path3.quadraticBezierTo(size.width * 0.78, size.height * 0.16, size.width * 0.8, size.height * 0.18);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CardWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final r = 24.0; // corner radius

    // Start at top-left corner
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    // Top edge curve: slants down and dips in the middle
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.16,
      size.width - r, size.height * 0.06,
    );

    // Top-right corner
    path.quadraticBezierTo(
      size.width, size.height * 0.06,
      size.width, size.height * 0.06 + r,
    );

    // Right edge
    path.lineTo(size.width, size.height * 0.94 - r);

    // Bottom-right corner
    path.quadraticBezierTo(
      size.width, size.height * 0.94,
      size.width - r, size.height * 0.94,
    );

    // Bottom edge curve: slants up and arches in the middle
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.84,
      r, size.height,
    );

    // Bottom-left corner
    path.quadraticBezierTo(
      0, size.height,
      0, size.height - r,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
