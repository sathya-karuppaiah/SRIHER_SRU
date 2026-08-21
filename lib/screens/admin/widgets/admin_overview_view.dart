import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'admin_stat_card.dart';

class AdminOverviewView extends StatelessWidget {
  final ValueChanged<int>? onNavigateToTab;

  const AdminOverviewView({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isDesktop = width >= 1024;
        final bool isTablet = width >= 600 && width < 1024;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner Header
              _buildWelcomeBanner(context),

              const SizedBox(height: 24),

              // KPI / Stat Cards Grid (7 Key Sections Required)
              _buildStatCardsGrid(context, isDesktop, isTablet),

              const SizedBox(height: 28),

              // Main Dashboard Body: Event Management Preview & SDG Coverage Distribution
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildRecentEventsTable(context),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          _buildSdgDistributionSection(context),
                          const SizedBox(height: 24),
                          _buildRecentActivityFeed(context),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                _buildRecentEventsTable(context),
                const SizedBox(height: 24),
                _buildSdgDistributionSection(context),
                const SizedBox(height: 24),
                _buildRecentActivityFeed(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryDark,
            AppTheme.darkAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "CONTROL CENTER",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "SRIHER Event Platform",
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome to SRIHER Admin Dashboard",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Overview of active institutional events, student registrations, SDG alignment metrics, and attendance tracking.",
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardsGrid(BuildContext context, bool isDesktop, bool isTablet) {
    int crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    // List of stat items covering the 7 requested sections:
    // Total Events, Upcoming Events, Ongoing Events, Completed Events, Registrations, Attendees, SDG Goals
    final List<Map<String, dynamic>> stats = [
      {
        "title": "Total Events",
        "value": "24",
        "subtitle": "+3 added this month",
        "icon": Icons.event_available,
        "accentColor": AppTheme.primaryDark,
        "trend": "+12.5%",
        "isPositive": true,
        "tabIndex": 2,
      },
      {
        "title": "Upcoming Events",
        "value": "8",
        "subtitle": "Next: SDG Summit 2026",
        "icon": Icons.upcoming,
        "accentColor": const Color(0xFF0288D1), // Blue
        "trend": "Scheduled",
        "isPositive": true,
        "tabIndex": 3,
      },
      {
        "title": "Ongoing Events",
        "value": "3",
        "subtitle": "Active on campus now",
        "icon": Icons.play_circle_fill,
        "accentColor": AppTheme.primaryLight, // SRIHER Red
        "badgeText": "3 LIVE NOW",
        "tabIndex": 2,
      },
      {
        "title": "Completed Events",
        "value": "13",
        "subtitle": "98% satisfaction rating",
        "icon": Icons.task_alt,
        "accentColor": const Color(0xFF2E7D32), // Green
        "trend": "Finished",
        "isPositive": true,
        "tabIndex": 2,
      },
      {
        "title": "Registrations",
        "value": "1,480",
        "subtitle": "+240 new signups this week",
        "icon": Icons.assignment_turned_in,
        "accentColor": const Color(0xFFED6C02), // Orange
        "trend": "+18.4%",
        "isPositive": true,
        "tabIndex": 5,
      },
      {
        "title": "Attendees",
        "value": "1,120",
        "subtitle": "75.6% check-in rate",
        "icon": Icons.groups_3,
        "accentColor": const Color(0xFF7B1FA2), // Purple
        "trend": "+8.2%",
        "isPositive": true,
        "tabIndex": 6,
      },
      {
        "title": "SDG Goals Tracked",
        "value": "17",
        "subtitle": "100% UN Goals covered",
        "icon": Icons.public,
        "accentColor": const Color(0xFF00838F), // Teal
        "badgeText": "17/17 GOALS",
        "tabIndex": 4,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 165,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return AdminStatCard(
          title: stat["title"],
          value: stat["value"],
          subtitle: stat["subtitle"],
          icon: stat["icon"],
          accentColor: stat["accentColor"],
          trend: stat["trend"],
          isPositiveTrend: stat["isPositive"] ?? true,
          badgeText: stat["badgeText"],
          onTap: () {
            if (onNavigateToTab != null && stat["tabIndex"] != null) {
              onNavigateToTab!(stat["tabIndex"]);
            }
          },
        );
      },
    );
  }

  Widget _buildRecentEventsTable(BuildContext context) {
    // Helper status generator matching required sections (Upcoming, Ongoing, Completed)
    final List<Map<String, dynamic>> mockEventTableData = [
      {
        "event": sampleEvents[0], // SDG Summit
        "status": "Upcoming",
        "statusColor": const Color(0xFF0288D1),
        "registrations": 420,
        "sdgGoal": "SDG 17",
      },
      {
        "event": sampleEvents[1], // SDG Innovation Challenge
        "status": "Ongoing",
        "statusColor": AppTheme.primaryLight,
        "registrations": 310,
        "sdgGoal": "SDG 9",
      },
      {
        "event": sampleEvents[2], // Sustainability Webinar
        "status": "Upcoming",
        "statusColor": const Color(0xFF0288D1),
        "registrations": 185,
        "sdgGoal": "SDG 12",
      },
      {
        "event": sampleEvents[3], // Clean Energy Expo
        "status": "Upcoming",
        "statusColor": const Color(0xFF0288D1),
        "registrations": 290,
        "sdgGoal": "SDG 7",
      },
      {
        "event": sampleEvents[4], // Youth for SDGs Meet
        "status": "Completed",
        "statusColor": const Color(0xFF2E7D32),
        "registrations": 275,
        "sdgGoal": "SDG 4",
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Bar
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Status Summary",
                        style: GoogleFonts.outfit(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Live status across Upcoming, Ongoing & Completed events",
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          color: AppTheme.textLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (onNavigateToTab != null) onNavigateToTab!(2);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 14, color: AppTheme.primaryLight),
                  label: Text(
                    "View All Events",
                    style: GoogleFonts.outfit(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFFE2E8F0), height: 1),

          // Scrollable Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppTheme.background),
              horizontalMargin: 18,
              columnSpacing: 14,
              columns: [
                DataColumn(label: Text("EVENT TITLE", style: _tableHeaderStyle)),
                DataColumn(label: Text("CATEGORY", style: _tableHeaderStyle)),
                DataColumn(label: Text("DATE", style: _tableHeaderStyle)),
                DataColumn(label: Text("STATUS", style: _tableHeaderStyle)),
                DataColumn(label: Text("REGISTRATIONS", style: _tableHeaderStyle)),
                DataColumn(label: Text("SDG ALIGNMENT", style: _tableHeaderStyle)),
              ],
              rows: mockEventTableData.map((item) {
                final Event event = item["event"];
                final String status = item["status"];
                final Color statusColor = item["statusColor"];
                final int registrations = item["registrations"];
                final String sdgGoal = item["sdgGoal"];

                final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                final dateStr = "${event.date.day} ${months[event.date.month - 1]} ${event.date.year}";

                return DataRow(
                  cells: [
                    // Title Cell
                    DataCell(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              event.imageUrl,
                              width: 34,
                              height: 34,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 34,
                                height: 34,
                                color: Colors.grey[200],
                                child: const Icon(Icons.event, size: 18, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  event.location,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10.5,
                                    color: AppTheme.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Category Cell
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: event.categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.category,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: event.categoryColor,
                          ),
                        ),
                      ),
                    ),
                    // Date Cell
                    DataCell(
                      Text(
                        dateStr,
                        style: GoogleFonts.outfit(fontSize: 12, color: AppTheme.textDark),
                      ),
                    ),
                    // Status Cell
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (status == "Ongoing") ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              status,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Registrations Cell
                    DataCell(
                      Text(
                        "$registrations Students",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                    // SDG Alignment Cell
                    DataCell(
                      Chip(
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                        backgroundColor: AppTheme.primaryDark.withOpacity(0.06),
                        label: Text(
                          sdgGoal,
                          style: GoogleFonts.outfit(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        side: BorderSide.none,
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

  Widget _buildSdgDistributionSection(BuildContext context) {
    // Use the sdgGoals array imported from app_theme.dart!
    final topGoals = sdgGoals.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "SDG Alignment Coverage",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "17 Goals Active",
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Event mapping across UN Sustainable Development Goals",
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: topGoals.map((sdg) {
              final double percent = (0.9 - (sdg.number * 0.1)).clamp(0.2, 0.95);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: sdg.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              "${sdg.number}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            sdg.title,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${(percent * 100).toInt()}%",
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: sdg.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: sdg.color.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(sdg.color),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityFeed(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        "title": "New Registration: SDG Summit",
        "subtitle": "Student ID: 2026-CS-104 registered",
        "time": "10 mins ago",
        "icon": Icons.person_add_alt_1,
        "color": const Color(0xFF2E7D32),
      },
      {
        "title": "Ticket Verified #SRI-904",
        "subtitle": "QR Check-in at Hall 2",
        "time": "32 mins ago",
        "icon": Icons.qr_code_scanner,
        "color": AppTheme.primaryDark,
      },
      {
        "title": "Event Schedule Updated",
        "subtitle": "Clean Energy Expo time modified",
        "time": "2 hours ago",
        "icon": Icons.edit_calendar,
        "color": AppTheme.primaryLight,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Activity Log",
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Live student & admin interaction stream",
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: activities.map((act) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (act["color"] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(act["icon"], color: act["color"], size: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            act["title"],
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            act["subtitle"],
                            style: GoogleFonts.outfit(
                              fontSize: 10.5,
                              color: AppTheme.textLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      act["time"],
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  TextStyle get _tableHeaderStyle => GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryDark,
        letterSpacing: 0.5,
      );
}
