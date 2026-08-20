import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'events_screen.dart';
import 'sdg_goals_screen.dart';
import 'ticket_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // Handle switching tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Action callback after successful registration
  void _handleRegisterSuccess() {
    setState(() {
      _selectedIndex = 3; // Switch to Ticket tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onViewAllEvents: _onItemTapped,
        onViewAllSdg: _onItemTapped,
        onRegisterSuccess: _handleRegisterSuccess,
      ),
      EventsScreen(
        onRegisterSuccess: _handleRegisterSuccess,
      ),
      const SdgGoalsScreen(showBackButton: false),
      const TicketScreen(showBackButton: false),
      const ProfileScreen(),
    ];

    final Widget mainContent = Scaffold(
      drawer: _buildCustomDrawer(),
      body: screens[_selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );

    // Apply mobile mockup frame constraints for premium desktop display
    return Scaffold(
      backgroundColor: const Color(0xFF020B10), // Extra dark outer background
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          constraints: const BoxConstraints(maxWidth: 480),
          child: mainContent,
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.darkAccent, // Dark Navy background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home, "Home"),
            _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today, "Events"),
            
            // Middle custom float button: SDG Wheel or Center plus icon
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryLight,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            
            _buildNavItem(3, Icons.confirmation_number_outlined, Icons.confirmation_number, "Tickets"),
            _buildNavItem(4, Icons.person_outline, Icons.person, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _selectedIndex == index;
    final iconColor = isSelected ? Colors.white : Colors.white60;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: iconColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: iconColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDrawer() {
    return Drawer(
      backgroundColor: AppTheme.darkAccent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryDark,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=80",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Gokul R",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "gokul.r@sriramachandra.edu",
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home_outlined, "Home Dashboard", 0),
          _buildDrawerItem(Icons.calendar_today_outlined, "Explore Events", 1),
          _buildDrawerItem(Icons.public, "SDG Global Goals", 2),
          _buildDrawerItem(Icons.confirmation_number_outlined, "My Active Tickets", 3),
          _buildDrawerItem(Icons.person_outline, "My Profile", 4),
          const Divider(color: Colors.white12),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white70),
            title: Text(
              "About Srihers Backstage",
              style: GoogleFonts.outfit(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryLight : Colors.white70,
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        _onItemTapped(index);
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryDark,
          title: Text(
            "About Srihers Backstage App",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "This application was created to promote, track, and register for campus activities related to the UN's Sustainable Development Goals (SDGs) at Sri Ramachandra Institute of Higher Education and Research.",
            style: GoogleFonts.outfit(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: GoogleFonts.outfit(color: AppTheme.primaryLight, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
