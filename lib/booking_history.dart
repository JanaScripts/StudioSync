import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Booking {
  final String studioName;
  final String date;
  final String time;

  Booking({
    required this.studioName,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'studioName': studioName,
    'date': date,
    'time': time,
  };

  factory Booking.fromJson(Map<String, dynamic> json) {
    String time = json['time'] ?? '';
    if (json['selectedHours'] != null && json['selectedHours'].isNotEmpty) {
      List<int> hours = List<int>.from(json['selectedHours']);
      time = _formatTime(hours);
    }

    return Booking(
      studioName: json['studioName'] ?? json['studio']['name'] ?? 'Unknown Studio',
      date: json['date'] ?? json['selectedDate'] ?? 'Unknown Date',
      time: time,
    );
  }

  static String _formatTime(List<int> hours) {
    if (hours.isEmpty) return 'Unknown Time';

    String start = _formatHour(hours[0]);
    String end = _formatHour(hours[0] + 1);

    return '$start - $end';
  }

  static String _formatHour(int hour) {
    final isPM = hour >= 12;
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String amPm = isPM ? 'PM' : 'AM';
    return '$displayHour:00 $amPm';
  }

  String get formattedDisplay {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final String formattedDate = DateFormat('MMMM d, y').format(parsedDate);
      return '$formattedDate | $time';
    } catch (e) {
      return '$date | $time'; // fallback if parsing fails
    }
  }
}

Future<List<Booking>> loadBookingHistory(String username, {bool showGlobal = false}) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> jsonList = showGlobal
      ? prefs.getStringList('booking_history') ?? []
      : prefs.getStringList('reservations_$username') ?? [];

  return jsonList.map((jsonStr) {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    return Booking.fromJson(json);
  }).toList();
}

class BookingHistoryPage extends StatefulWidget {
  final String username;
  final bool showGlobal;

  const BookingHistoryPage({
    super.key,
    required this.username,
    this.showGlobal = false,
  });

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  List<Booking> allBookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookingHistory();
  }

  Future<void> _loadBookingHistory() async {
    final bookings = await loadBookingHistory(widget.username, showGlobal: widget.showGlobal);
    setState(() {
      allBookings = bookings;
    });
  }

  Widget _buildBookingList(String title, List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No $title bookings.', style: const TextStyle(color: Colors.white))),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '$title Bookings',
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...bookings.map((booking) => ListTile(
          title: Text(
            booking.studioName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            booking.formattedDisplay,
            style: const TextStyle(color: Colors.white70),
          ),
        )),
        const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Booking History', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: allBookings.isEmpty
          ? const Center(child: Text('No bookings yet.', style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingList('All', allBookings),
          ],
        ),
      ),
    );
  }
}
