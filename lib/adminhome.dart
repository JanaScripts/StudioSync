import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account.dart';
import 'package:intl/intl.dart';

class Booking {
  final String studioName;
  final String date;
  final String time;
  final String name;
  final String contact;

  Booking({
    required this.studioName,
    required this.date,
    required this.time,
    required this.name,
    required this.contact,
  });

  Map<String, dynamic> toJson() => {
    'studioName': studioName,
    'date': date,
    'time': time,
    'name': name,
    'contact': contact,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    studioName: json['studioName'],
    date: json['date'],
    time: json['time'],
    name: json['name'] ?? '',
    contact: json['contact'] ?? '',
  );
}

Future<List<Booking>> loadBookingHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> jsonList = prefs.getStringList('booking_history') ?? [];
  return jsonList.map((jsonStr) => Booking.fromJson(jsonDecode(jsonStr))).toList();
}

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Booking> allBookings = [];

  String adminUsername = 'admin';

  @override
  void initState() {
    super.initState();
    _loadBookingHistory();
  }

  Future<void> _loadBookingHistory() async {
    final bookings = await loadBookingHistory();
    setState(() {
      allBookings = bookings;
    });
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(' ');
    final hourMin = parts[0].split(':');
    int hour = int.parse(hourMin[0]);
    final minute = int.parse(hourMin[1]);
    final isPM = parts[1].toLowerCase() == 'pm';
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void openSideMenu() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Widget _buildGroupedBookingList(List<Booking> bookings) {
    final dateFormat = DateFormat('MMMM d, yyyy');

    // Group bookings by date
    Map<String, List<Booking>> grouped = {};
    for (var booking in bookings) {
      grouped.putIfAbsent(booking.date, () => []).add(booking);
    }

    // Sort dates in ascending order
    var sortedDates = grouped.keys.toList()
      ..sort((a, b) => dateFormat.parse(a).compareTo(dateFormat.parse(b)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedDates.map((date) {
        // Sort bookings for this date by time
        List<Booking> dailyBookings = grouped[date]!;
        dailyBookings.sort((a, b) {
          final timeA = _parseTime(a.time);
          final timeB = _parseTime(b.time);
          return timeA.hour.compareTo(timeB.hour) != 0
              ? timeA.hour.compareTo(timeB.hour)
              : timeA.minute.compareTo(timeB.minute);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Date: $date',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...dailyBookings.map((booking) => ListTile(
              title: Text(
                booking.studioName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${booking.time}', style: const TextStyle(color: Colors.white70)),
                  Text('Name: ${booking.name}', style: const TextStyle(color: Colors.white70)),
                  Text('Contact: ${booking.contact}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            )),
            const Divider(color: Colors.grey),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(color: Colors.grey[850]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminUsername,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Role: Admin', style: TextStyle(color: Colors.grey[400])),
                  SizedBox(height: 8),
                  Text('bio', style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            ),
            ListTile(
              title: Text('Account', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage(username: adminUsername)),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: openSideMenu,
        ),
        title: Text('Admin Panel', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: allBookings.isEmpty
          ? const Center(child: Text('No bookings yet.', style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupedBookingList(allBookings),
          ],
        ),
      ),
    );
  }
}
