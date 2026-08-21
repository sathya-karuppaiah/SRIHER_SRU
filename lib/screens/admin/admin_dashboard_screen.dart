import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_home_page_management_view.dart';
import 'widgets/admin_overview_view.dart';
import 'widgets/admin_section_placeholder.dart';
import 'widgets/admin_sidebar.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Close drawer on tablet/mobile if open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  void _toggleSidebarCollapse() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1024;

        final AdminNavItem currentItem = AdminSidebar.navItems[_selectedIndex];

        // Content renderer depending on selected tab index
        Widget mainViewContent;
        if (_selectedIndex == 0) {
          mainViewContent = AdminOverviewView(
            onNavigateToTab: _onDestinationSelected,
          );
        } else if (currentItem.title == "Home Page Management") {
          mainViewContent = const AdminHomePageManagementView();
        } else {
          mainViewContent = AdminSectionPlaceholder(
            title: currentItem.title,
            description: "Manage, update, and monitor ${currentItem.title.toLowerCase()} for SRIHER.",
            icon: currentItem.filledIcon,
            quickStats: [
              "Total ${currentItem.title}: ${currentItem.badgeText ?? '12'}",
              "Active Module Status: Ready",
              "Integration: Standby",
            ],
          );
        }

        if (isDesktop) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: Row(
              children: [
                // Desktop Persistent Sidebar
                AdminSidebar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  isCollapsed: _isSidebarCollapsed,
                  onToggleCollapse: _toggleSidebarCollapse,
                ),

                // Main Dashboard Body with Top Header
                Expanded(
                  child: Column(
                    children: [
                      AdminHeader(
                        title: currentItem.title,
                        subtitle: "SRIHER Administration Portal",
                        isDesktop: true,
                        onMenuToggle: _toggleSidebarCollapse,
                      ),
                      Expanded(
                        child: mainViewContent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Tablet & Small Screen Layout with Drawer
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppTheme.background,
          drawer: Drawer(
            child: AdminSidebar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              isCollapsed: false,
            ),
          ),
          appBar: AdminHeader(
            title: currentItem.title,
            subtitle: "SRIHER Admin Portal",
            isDesktop: false,
            onMenuToggle: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          body: mainViewContent,
        );
      },
    );
  }
}
