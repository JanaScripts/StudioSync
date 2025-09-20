import 'package:flutter/material.dart';
import 'studio_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'reservation.dart';
import 'package:intl/intl.dart';
import 'booking_history.dart';

class SummaryPage extends StatelessWidget {
  final String name;
  final String contact;
  final String email;
  final DateTime selectedDate;
  final List<int> selectedHours;
  final List<String> addOns;
  final Studio studio;
  final String username;

  SummaryPage({
    required this.name,
    required this.contact,
    required this.email,
    required this.selectedDate,
    required this.selectedHours,
    required this.addOns,
    required this.studio,
    required this.username,
  });

  double calculateTotalAmount() {
    String priceString = studio.price.replaceAll(RegExp(r'[₱,/hr\s]'), '');
    double studioRate = double.tryParse(priceString) ?? 0.0;

    double total = selectedHours.length * studioRate;

    for (var addon in addOns) {
      if (addon.contains('Guitar Cables')) {
        int quantity = int.parse(addon.split('x').last.trim());
        total += quantity * 30;
      } else if (addon.contains('Microphones')) {
        int quantity = int.parse(addon.split('x').last.trim());
        total += quantity * 50;
      }
    }

    return total;
  }

  String _formatHour(int hour) {
    final isPM = hour >= 12;
    final displayHour = hour == 0 ? 12 : hour > 12 ? hour - 12 : hour;
    return '$displayHour:00 ${isPM ? 'PM' : 'AM'}';
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'StudioSync',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              studio.imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 220,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Your Reservation Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      studio.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${studio.description} The room includes:',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 6),
                    Text(
                      studio.equipment,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Add Ons',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    ...addOns.map((addon) => Text('• $addon')).toList(),
                    SizedBox(height: 10),
                    Text(
                      'Selected Schedule',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (selectedHours.isEmpty)
                      Text("No schedule selected", style: TextStyle(fontSize: 14))
                    else
                      ...selectedHours.map((hour) {
                        final end = hour + 1;
                        return Text(
                          '${_formatHour(hour)} - ${_formatHour(end)} on ${_monthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                          style: TextStyle(fontSize: 14),
                        );
                      }).toList(),
                    SizedBox(height: 20),
                    Text(
                      'Total Amount',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₱${calculateTotalAmount().toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          studio.maxHead,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          Reservation reservation = Reservation(
                            name: name,
                            contact: contact,
                            email: email,
                            selectedDate: selectedDate,
                            selectedHours: selectedHours,
                            addOns: addOns,
                            studio: studio,
                            total: calculateTotalAmount(),
                          );

                          // Get all reservations globally for conflict check
                          List<String> globalReservations = prefs.getStringList('reservations') ?? [];

                          bool hasConflict = false;

                          for (String res in globalReservations) {
                            final decoded = jsonDecode(res);
                            final existingDate = DateTime.parse(decoded['selectedDate']);
                            final existingHours = List<int>.from(decoded['selectedHours']);
                            final existingStudioName = decoded['studio']['name'];

                            if (existingDate.year == selectedDate.year &&
                                existingDate.month == selectedDate.month &&
                                existingDate.day == selectedDate.day &&
                                existingStudioName == studio.name) {
                              for (int hour in selectedHours) {
                                if (existingHours.contains(hour)) {
                                  hasConflict = true;
                                  break;
                                }
                              }
                            }

                            if (hasConflict) break;
                          }

                          if (hasConflict) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected time is already booked in this studio. Please choose a different time.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // Cancel submission
                          }

                          // Save reservation globally for conflict prevention
                          globalReservations.add(jsonEncode(reservation.toJson()));
                          await prefs.setStringList('reservations', globalReservations);

                          // Also save reservation to user's personal reservation list for user history page
                          List<String> userReservations = prefs.getStringList('reservations_$username') ?? [];
                          userReservations.add(jsonEncode(reservation.toJson()));
                          await prefs.setStringList('reservations_$username', userReservations);

                          // (Optional) Save admin booking history
                          final adminBooking = {
                            'studioName': studio.name,
                            'date': DateFormat('MMMM d, y').format(selectedDate),
                            'time': selectedHours
                                .map((hour) => '${_formatHour(hour)} - ${_formatHour(hour + 1)}')
                                .join(', '),
                            'name': name,
                            'contact': contact,
                          };

                          List<String> bookingHistory = prefs.getStringList('booking_history') ?? [];
                          bookingHistory.add(jsonEncode(adminBooking));
                          await prefs.setStringList('booking_history', bookingHistory);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Reservation saved successfully!')),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingHistoryPage(
                                username: username,
                                showGlobal: false,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
