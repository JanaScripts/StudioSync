import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime selectedDate = DateTime.now();
  List<int> selectedHours = [];

  List<int> hours = List.generate(16, (index) => index + 8);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
    final firstWeekday = DateTime(selectedDate.year, selectedDate.month, 1).weekday;
    final dates = List.generate(daysInMonth, (i) => i + 1);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Pops the current screen from the stack
          },
        ),
        title: Text('Select Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF3ECFF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Month display and navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
                      });
                    },
                  ),
                  Text(
                    "${_monthName(selectedDate.month)} ${selectedDate.year}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),

              Container(
                height: 280,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: firstWeekday - 1 + dates.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    if (index < firstWeekday - 1) {
                      return SizedBox.shrink();
                    }

                    final day = dates[index - (firstWeekday - 1)];
                    final dayDate = DateTime(selectedDate.year, selectedDate.month, day);

                    final isPastDay = dayDate.isBefore(DateTime.now().subtract(Duration(days: 1)));

                    final isSelected = selectedDate.day == day;

                    return GestureDetector(
                      onTap: isPastDay
                          ? null // Disable tap if it's a past day
                          : () {
                        setState(() {
                          selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurpleAccent
                              : (isPastDay ? Colors.grey : Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isPastDay ? Colors.black26 : Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),

              // Hour selection
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: hours.map((hour) {
                  final isSelected = selectedHours.contains(hour);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedHours.remove(hour);
                        } else {
                          selectedHours.add(hour);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurpleAccent : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        _formatHour(hour),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    'date': selectedDate,
                    'hours': selectedHours,
                  });
                },
                child: Text('Select', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
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
}
