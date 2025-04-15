import 'package:book_ease/screens/admin/reservation/reservation_table.dart';
import 'package:flutter/material.dart';
import 'package:book_ease/screens/admin/components/search_admin.dart';
import 'package:book_ease/screens/admin/dashboard/dashboard_screen.dart';
import 'package:book_ease/screens/admin/admin_theme.dart';
// Replace with your actual reservation table widget

class ReservationMain extends StatefulWidget {
  const ReservationMain({super.key});

  @override
  State<ReservationMain> createState() => _ReservationMainState();
}

class _ReservationMainState extends State<ReservationMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DashboardTheme.pageBackground,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Search Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reservations",
                    style: TextStyle(
                      fontSize: AdminFontSize.subHeading,
                      fontWeight: FontWeight.bold,
                      color: DashboardTheme.primaryTextColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SearchAdmin(hintText: 'Search reservations...'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Reservation Table Section
              Expanded(
                child: ReservationScreen(), // You should define this widget
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}