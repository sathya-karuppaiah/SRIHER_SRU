import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final String time;
  final String location;
  final String region;
  final String orderId;
  final String ticketId;
  final String status; // "In Progress", "Upcoming", "Completed", "Cancelled"
  final String imageUrl;
  final String screen;
  final String seats;
  final String bookingId;

  TicketModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.location,
    required this.region,
    required this.orderId,
    required this.ticketId,
    required this.status,
    required this.imageUrl,
    required this.screen,
    required this.seats,
    required this.bookingId,
  });
}

class TicketScreen extends StatefulWidget {
  final bool showBackButton;
  const TicketScreen({super.key, this.showBackButton = false});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  int _activeTabIndex = 0; // 0: All, 1: Upcoming, 2: Completed, 3: Cancelled

  final List<TicketModel> _tickets = [
    TicketModel(
      id: "tkt1",
      title: "Annual Cultural Fest",
      subtitle: "Cultural showcase & performances",
      date: DateTime(2024, 5, 24),
      time: "09:00 AM",
      location: "SRIHER Campus, Chennai",
      region: "Tamil Nadu, India",
      orderId: "SRH2456DF",
      ticketId: "TKT123456",
      status: "In Progress",
      imageUrl: "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400&auto=format&fit=crop&q=60",
      screen: "SCREEN 1",
      seats: "G-12, G-13",
      bookingId: "SRH2456DF",
    ),
    TicketModel(
      id: "tkt2",
      title: "Medical Conclave 2024",
      subtitle: "Healthcare innovation seminar",
      date: DateTime(2024, 6, 2),
      time: "10:00 AM",
      location: "Auditorium, SRIHER",
      region: "Tamil Nadu, India",
      orderId: "SRH7890MC",
      ticketId: "TKT789012",
      status: "Upcoming",
      imageUrl: "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400&auto=format&fit=crop&q=60",
      screen: "MAIN HALL",
      seats: "A-5, A-6",
      bookingId: "SRH7890MC",
    ),
    TicketModel(
      id: "tkt3",
      title: "Health Awareness Workshop",
      subtitle: "Community wellness and outreach",
      date: DateTime(2024, 4, 15),
      time: "02:00 PM",
      location: "Lecture Hall 1, SRIHER",
      region: "Tamil Nadu, India",
      orderId: "SRH3456HW",
      ticketId: "TKT345678",
      status: "Completed",
      imageUrl: "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400&auto=format&fit=crop&q=60",
      screen: "ROOM 101",
      seats: "C-18",
      bookingId: "SRH3456HW",
    ),
  ];

  List<TicketModel> get _filteredTickets {
    if (_activeTabIndex == 0) {
      return _tickets;
    } else if (_activeTabIndex == 1) {
      // Include both Upcoming and In Progress as shown in mockup ("Upcoming (2)")
      return _tickets.where((t) => t.status == "Upcoming" || t.status == "In Progress").toList();
    } else if (_activeTabIndex == 2) {
      return _tickets.where((t) => t.status == "Completed").toList();
    } else {
      return _tickets.where((t) => t.status == "Cancelled").toList();
    }
  }

  void _showTicketDetails(TicketModel ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pull bar
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Text(
                          "Your Ticket",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF031624),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF6B7280),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Ticket card stub
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = constraints.maxWidth;
                        final cutX = cardWidth - 80;
                        return ClipPath(
                          clipper: HorizontalTicketClipper(cutX: cutX, cutRadius: 10),
                          child: Container(
                            width: cardWidth,
                            height: 140,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDFBF7),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Left image
                                Positioned(
                                  left: 12,
                                  top: 12,
                                  bottom: 12,
                                  width: 85,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      ticket.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(color: Colors.grey[300]);
                                      },
                                    ),
                                  ),
                                ),
                                // Center contents
                                Positioned(
                                  left: 110,
                                  top: 12,
                                  right: 90,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: ticket.status == "In Progress"
                                                  ? const Color(0xFFFFEBEE)
                                                  : ticket.status == "Upcoming"
                                                      ? const Color(0xFFE3F2FD)
                                                      : const Color(0xFFE8F5E9),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              ticket.status,
                                              style: GoogleFonts.outfit(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: ticket.status == "In Progress"
                                                    ? const Color(0xFFC62828)
                                                    : ticket.status == "Upcoming"
                                                        ? const Color(0xFF1565C0)
                                                        : const Color(0xFF2E7D32),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            ticket.title,
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF031624),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  "Sat, 24 May 2024 | 09:00 AM",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  ticket.location,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Vertical dotted separator
                                Positioned(
                                  left: cutX,
                                  top: 10,
                                  bottom: 10,
                                  child: CustomPaint(
                                    size: const Size(1, double.infinity),
                                    painter: VerticalDashLinePainter(),
                                  ),
                                ),
                                // Right rotated ID stub
                                Positioned(
                                  right: 0,
                                  top: 12,
                                  bottom: 12,
                                  width: 80,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "TICKET ID",
                                            style: GoogleFonts.outfit(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[400],
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            ticket.ticketId,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF031624),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // QR Code block
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBF7),
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
                          // QR Code Painter
                          Container(
                            width: 110,
                            height: 110,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomPaint(
                              painter: QrPainter(),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ticket.screen,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF031624),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Seats: ${ticket.seats}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "BOOKING ID",
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[400],
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ticket.bookingId,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF031624),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // scan helper text
                    Text(
                      "Show this QR code at the entry to scan your tickets",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_off_outlined, size: 16, color: Color(0xFFBA1A1A)),
                            label: Text(
                              "Cancel Booking",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: const Color(0xFFBA1A1A),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFFAD2D2)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.headset_mic_outlined, size: 16, color: Color(0xFF031624)),
                            label: Text(
                              "Contact Support",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: const Color(0xFF031624),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF031624), size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          "My Tickets",
          style: GoogleFonts.outfit(
            color: const Color(0xFF031624),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Color(0xFF031624), size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Horizontal Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabItem(0, "All Tickets (3)", Icons.local_activity_outlined),
                  const SizedBox(width: 8),
                  _buildTabItem(1, "Upcoming (2)", Icons.calendar_today_outlined),
                  const SizedBox(width: 8),
                  _buildTabItem(2, "Completed (1)", Icons.check_circle_outline_outlined),
                  const SizedBox(width: 8),
                  _buildTabItem(3, "Cancelled (0)", Icons.cancel_outlined),
                ],
              ),
            ),
          ),
          // 2. Subheader and Tickets List
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Events Subheading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Events",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF031624),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "View and manage all your event tickets",
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Sort by: ",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(
                              "Recent",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFBA1A1A),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFFBA1A1A)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tickets list items
                    if (_filteredTickets.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            "No tickets found",
                            style: GoogleFonts.outfit(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredTickets.length,
                        itemBuilder: (context, index) {
                          final ticket = _filteredTickets[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final cardWidth = constraints.maxWidth;
                                final cutX = cardWidth - 100;
                                return GestureDetector(
                                  onTap: () => _showTicketDetails(ticket),
                                  child: ClipPath(
                                    clipper: HorizontalTicketClipper(cutX: cutX, cutRadius: 10),
                                    child: Container(
                                      width: cardWidth,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFDFBF7),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.015),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          // Event Image Poster
                                          Positioned(
                                            left: 12,
                                            top: 12,
                                            bottom: 12,
                                            width: 85,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                ticket.imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(color: Colors.grey[300]);
                                                },
                                              ),
                                            ),
                                          ),
                                          // Center details
                                          Positioned(
                                            left: 110,
                                            top: 12,
                                            right: 110,
                                            bottom: 12,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: ticket.status == "In Progress"
                                                            ? const Color(0xFFFFEBEE)
                                                            : ticket.status == "Upcoming"
                                                                ? const Color(0xFFE3F2FD)
                                                                : const Color(0xFFE8F5E9),
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(
                                                        ticket.status,
                                                        style: GoogleFonts.outfit(
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                          color: ticket.status == "In Progress"
                                                              ? const Color(0xFFC62828)
                                                              : ticket.status == "Upcoming"
                                                                  ? const Color(0xFF1565C0)
                                                                  : const Color(0xFF2E7D32),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      ticket.title,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFF031624),
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.calendar_today_outlined, size: 11, color: Colors.grey),
                                                        const SizedBox(width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            "Sat, 24 May 2024 | 09:00 AM",
                                                            style: GoogleFonts.outfit(
                                                              fontSize: 9,
                                                              color: Colors.grey[600],
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.location_on_outlined, size: 11, color: Colors.grey),
                                                        const SizedBox(width: 4),
                                                        Expanded(
                                                          child: Text(
                                                            ticket.location,
                                                            style: GoogleFonts.outfit(
                                                              fontSize: 9,
                                                              color: Colors.grey[600],
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "Order ID: ${ticket.orderId}",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 9,
                                                    color: Colors.grey[400],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Dotted Separator
                                          Positioned(
                                            left: cutX,
                                            top: 10,
                                            bottom: 10,
                                            child: CustomPaint(
                                              size: const Size(1, double.infinity),
                                              painter: VerticalDashLinePainter(),
                                            ),
                                          ),
                                          // Right View Ticket Stub
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            width: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.confirmation_number_outlined, color: Color(0xFFBA1A1A), size: 22),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "View Ticket",
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFFBA1A1A),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 16),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                    // Security Shield Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBF7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.015),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: Color(0xFFBA1A1A), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Show your QR code at the event entry.",
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF031624),
                                  ),
                                ),
                                Text(
                                  "Tickets are non-transferable.",
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download_outlined, size: 14, color: Color(0xFFBA1A1A)),
                            label: Text(
                              "Download All",
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFBA1A1A),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFAD2D2)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFFBA1A1A) : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? const Color(0xFFBA1A1A) : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFFBA1A1A) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vertical Dashed Divider Line Painter
class VerticalDashLinePainter extends CustomPainter {
  final Color color;
  VerticalDashLinePainter({this.color = const Color(0xFFE0E0E0)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const double dashHeight = 5;
    const double dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Horizontal Ticket shape clipper with top and bottom circular cutouts
class HorizontalTicketClipper extends CustomClipper<Path> {
  final double cutX;
  final double cutRadius;
  HorizontalTicketClipper({required this.cutX, this.cutRadius = 10.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    // Top Cutout
    path.lineTo(cutX - cutRadius, 0);
    path.arcToPoint(
      Offset(cutX + cutRadius, 0),
      radius: Radius.circular(cutRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    // Bottom Cutout
    path.lineTo(cutX + cutRadius, size.height);
    path.arcToPoint(
      Offset(cutX - cutRadius, size.height),
      radius: Radius.circular(cutRadius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant HorizontalTicketClipper oldClipper) =>
      oldClipper.cutX != cutX || oldClipper.cutRadius != cutRadius;
}

// Mock QR Code Painter
class QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final int gridSize = 21;
    final double moduleWidth = size.width / gridSize;
    final double moduleHeight = size.height / gridSize;

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_isModuleBlack(r, c)) {
          canvas.drawRect(
            Rect.fromLTWH(
              c * moduleWidth,
              r * moduleHeight,
              moduleWidth,
              moduleHeight,
            ),
            paint,
          );
        }
      }
    }
  }

  bool _isModuleBlack(int r, int c) {
    if (r < 7 && c < 7) {
      return (r == 0 || r == 6 || c == 0 || c == 6) || (r >= 2 && r <= 4 && c >= 2 && c <= 4);
    }
    if (r < 7 && c >= 14) {
      int nc = c - 14;
      return (r == 0 || r == 6 || nc == 0 || nc == 6) || (r >= 2 && r <= 4 && nc >= 2 && nc <= 4);
    }
    if (r >= 14 && c < 7) {
      int nr = r - 14;
      return (nr == 0 || nr == 6 || c == 0 || c == 6) || (nr >= 2 && nr <= 4 && c >= 2 && c <= 4);
    }

    if (r == 7 && c < 8) return false;
    if (c == 7 && r < 8) return false;
    if (r == 7 && c >= 13) return false;
    if (c == 13 && r < 8) return false;
    if (r == 13 && c < 8) return false;
    if (c == 7 && r >= 13) return false;

    if (r == 6) return c % 2 == 0;
    if (c == 6) return r % 2 == 0;

    if (r >= 14 && r <= 18 && c >= 14 && c <= 18) {
      int nr = r - 14;
      int nc = c - 14;
      return (nr == 0 || nr == 4 || nc == 0 || nc == 4) || (nr == 2 && nc == 2);
    }

    final int hash = (r * 19 + c * 37) % 10;
    return hash == 1 || hash == 3 || hash == 5 || hash == 8;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
