import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF06273D); // Navy Blue
  static const Color primaryLight = Color(0xFF890E0E); // Deep Red/Burgundy Accent
  static const Color background = Color(0xFFF2F5F7); // Light Gray/Blue background
  static const Color surface = Color(0xFFFFFFFF); // White cards
  static const Color textDark = Color(0xFF141B1F); // Dark Navy/Black text
  static const Color textLight = Color(0xFF75828A); // Grayish Blue text
  static const Color darkAccent = Color(0xFF03141F); // Darker Bottom Bar/Card background

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryDark,
        secondary: primaryLight,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: textDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.outfit(
          color: textDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: textDark,
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: textLight,
        ),
      ),
      useMaterial3: true,
    );
  }

  // Premium Glassmorphism decoration
  static BoxDecoration glassDecoration({
    Color color = Colors.white,
    double opacity = 0.85,
    double blur = 10,
    double borderRadius = 16,
    Border? border,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// Data models
class SDGGoal {
  final int number;
  final String title;
  final Color color;
  final IconData icon;
  final String imagePath;

  const SDGGoal({
    required this.number,
    required this.title,
    required this.color,
    required this.icon,
    required this.imagePath,
  });
}

class Event {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final String location;
  final String category; // Conference, Competition, Webinar, Exhibition, Meetup
  final Color categoryColor;
  final String imageUrl;
  final bool isFeatured;
  final String time;
  final String description;
  final List<String> highlights;

  const Event({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.location,
    required this.category,
    required this.categoryColor,
    required this.imageUrl,
    this.isFeatured = false,
    this.time = "09:00 AM - 05:00 PM",
    this.description = "",
    this.highlights = const [],
  });
}

// Sample Data
final List<SDGGoal> sdgGoals = [
  const SDGGoal(
    number: 1,
    title: "No Poverty",
    color: Color(0xFFE5243B),
    icon: Icons.sentiment_very_dissatisfied,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-01.png",
  ),
  const SDGGoal(
    number: 2,
    title: "Zero Hunger",
    color: Color(0xFFDDA63A),
    icon: Icons.restaurant,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-02.png",
  ),
  const SDGGoal(
    number: 3,
    title: "Good Health & Well-being",
    color: Color(0xFF4C9F38),
    icon: Icons.favorite,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-03.png",
  ),
  const SDGGoal(
    number: 4,
    title: "Quality Education",
    color: Color(0xFFC5192D),
    icon: Icons.menu_book,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-04.png",
  ),
  const SDGGoal(
    number: 5,
    title: "Gender Equality",
    color: Color(0xFFFF3A21),
    icon: Icons.wc,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-05.png",
  ),
  const SDGGoal(
    number: 6,
    title: "Clean Water & Sanitation",
    color: Color(0xFF26BDE2),
    icon: Icons.water_drop,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-06.png",
  ),
  const SDGGoal(
    number: 7,
    title: "Affordable & Clean Energy",
    color: Color(0xFFFCC30B),
    icon: Icons.wb_sunny,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-07.png",
  ),
  const SDGGoal(
    number: 8,
    title: "Decent Work & Econ Growth",
    color: Color(0xFFA21942),
    icon: Icons.trending_up,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-08.png",
  ),
  const SDGGoal(
    number: 9,
    title: "Industry, Innov & Infra",
    color: Color(0xFFFD6925),
    icon: Icons.build,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-09.png",
  ),
  const SDGGoal(
    number: 10,
    title: "Reduced Inequalities",
    color: Color(0xFFDD1367),
    icon: Icons.thumbs_up_down,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-10.png",
  ),
  const SDGGoal(
    number: 11,
    title: "Sustainable Cities",
    color: Color(0xFFFD9D24),
    icon: Icons.location_city,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-11.png",
  ),
  const SDGGoal(
    number: 12,
    title: "Responsible Consumption",
    color: Color(0xFFC28B23),
    icon: Icons.loop,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-12.png",
  ),
  const SDGGoal(
    number: 13,
    title: "Climate Action",
    color: Color(0xFF3F7E44),
    icon: Icons.thunderstorm,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-13.png",
  ),
  const SDGGoal(
    number: 14,
    title: "Life Below Water",
    color: Color(0xFF0A97D9),
    icon: Icons.sailing,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-14.png",
  ),
  const SDGGoal(
    number: 15,
    title: "Life on Land",
    color: Color(0xFF56C02B),
    icon: Icons.forest,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-15.png",
  ),
  const SDGGoal(
    number: 16,
    title: "Peace, Justice & Institutions",
    color: Color(0xFF00689D),
    icon: Icons.gavel,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-16.png",
  ),
  const SDGGoal(
    number: 17,
    title: "Partnerships for Goals",
    color: Color(0xFF19486A),
    icon: Icons.handshake,
    imagePath: "SDG Icons 2019_WEB - Copy/English SDG icons/E-WEB-Goal-17.png",
  ),
];

final List<Event> sampleEvents = [
  Event(
    id: "evt1",
    title: "International SDG Summit 2026",
    subtitle: "Building a Sustainable Tomorrow, Together",
    date: DateTime(2026, 11, 15),
    location: "Sri Ramachandra Campus, Chennai",
    category: "Conference",
    categoryColor: const Color(0xFF890E0E),
    imageUrl: "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600&auto=format&fit=crop&q=60",
    isFeatured: true,
    time: "09:00 AM - 05:00 PM",
    description: "Join global leaders, innovators, and changemakers in a powerful dialogue for a better and more sustainable future aligned with the Sustainable Development Goals.",
    highlights: const ["Keynote Speakers", "Panel Discussions", "Networking", "SDG Exhibition"],
  ),
  Event(
    id: "evt2",
    title: "SDG Innovation Challenge",
    subtitle: "Pitch your green tech solutions",
    date: DateTime(2026, 8, 5),
    location: "Online",
    category: "Competition",
    categoryColor: const Color(0xFF1E88E5),
    imageUrl: "https://images.unsplash.com/photo-1497436072909-60f360e1d4b1?w=600&auto=format&fit=crop&q=60",
    time: "10:00 AM - 04:00 PM",
    description: "Compete with global innovators to design tech-based answers to climate change, circular economies, and clean energies.",
    highlights: const ["Mentorship", "Cash Prizes", "Venture Pitching"],
  ),
  Event(
    id: "evt3",
    title: "Sustainability Webinar",
    subtitle: "Eco-friendly lifestyle tips",
    date: DateTime(2026, 9, 12),
    location: "Online",
    category: "Webinar",
    categoryColor: const Color(0xFFFB8C00),
    imageUrl: "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=600&auto=format&fit=crop&q=60",
    time: "02:00 PM - 03:30 PM",
    description: "A digital workshop dedicated to practical, day-to-day changes individuals can implement to lower carbon footprint.",
    highlights: const ["Q&A Session", "Eco Toolkit PDF", "Specialist Guest Panel"],
  ),
  Event(
    id: "evt4",
    title: "Clean Energy Expo",
    subtitle: "Solar & Wind Tech Showcase",
    date: DateTime(2026, 10, 2),
    location: "Sri Ramachandra Campus, Chennai",
    category: "Exhibition",
    categoryColor: const Color(0xFFE53935),
    imageUrl: "https://images.unsplash.com/photo-1466611653911-95081537e5b7?w=600&auto=format&fit=crop&q=60",
    time: "09:00 AM - 06:00 PM",
    description: "Explore the latest physical designs in solar panels, wind turbine generators, and energy storage networks.",
    highlights: const ["Live Demos", "B2B Meetings", "Startup Pavilion"],
  ),
  Event(
    id: "evt5",
    title: "Youth for SDGs Meet",
    subtitle: "Connect with young climate activists",
    date: DateTime(2026, 11, 20),
    location: "College Campus, Chennai",
    category: "Meetup",
    categoryColor: const Color(0xFF8E24AA),
    imageUrl: "https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=600&auto=format&fit=crop&q=60",
    time: "03:00 PM - 06:00 PM",
    description: "An informal session bringing together students and youth organizers to coordinate local green actions.",
    highlights: const ["Idea Circle", "Signmaking Workroom", "Campaign Launchpad"],
  ),
];
