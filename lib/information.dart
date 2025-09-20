import 'package:flutter/material.dart';
import 'schedule_page.dart';
import 'add_ons_page.dart';
import 'reservation_summary_page.dart';
import 'studio_detail.dart';

class InformationPage extends StatefulWidget {
  final Studio studio;
  final String username;

  InformationPage({required this.studio, required this.username});

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<int> selectedHours = [];
  List<String> selectedAddOns = [];

  void _selectSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SchedulePage()),
    );

    if (result != null && result is Map) {
      setState(() {
        selectedDate = result['date'] ?? DateTime.now();
        selectedHours = List<int>.from(result['hours'] ?? []);
      });
    }
  }

  void _showAddInstrumentsDialog() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedHours.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a schedule first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Instruments'),
        content: Text('Would you like to add studio equipment to your session?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToAddInstrumentsPage();
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToSummaryPage();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }


  void _navigateToAddInstrumentsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddInstrumentsPage(studio: widget.studio)),
    );

    if (result != null && result is List<String>) {
      setState(() {
        selectedAddOns = result;
      });
    }

    _navigateToSummaryPage();
  }

  void _navigateToSummaryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(
          name: _nameController.text,
          contact: _contactController.text,
          email: _emailController.text,
          selectedDate: selectedDate,
          selectedHours: selectedHours,
          addOns: selectedAddOns,
          studio: widget.studio,
          username: widget.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('StudioSync', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.studio.imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                    SizedBox(height: 20),
                    _buildTextField("Name", _nameController),
                    SizedBox(height: 12),
                    _buildTextField("Contact Number", _contactController, keyboardType: TextInputType.phone),
                    SizedBox(height: 12),
                    _buildTextField("Email Address", _emailController, keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _selectSchedule,
                        child: Text('Select Schedule', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Selected Schedule',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    if (selectedHours.isEmpty)
                      Text("No schedule selected", style: TextStyle(fontSize: 16))
                    else
                      ...selectedHours.map((hour) {
                        final end = hour + 1;
                        return Text(
                          '${_formatHour(hour)} - ${_formatHour(end)} on ${_monthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
                          style: TextStyle(fontSize: 16),
                        );
                      }).toList(),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _showAddInstrumentsDialog,
                        child: Text('Next', style: TextStyle(color: Colors.white)),
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

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  String _formatHour(int hour) {
    final isPM = hour >= 12;
    final displayHour = hour == 0
        ? 12
        : (hour == 24 ? 12 : hour > 12 ? hour - 12 : hour);

    final period = (hour == 24 || hour == 0) ? 'AM' : (isPM ? 'PM' : 'AM');

    return '$displayHour:00 $period';
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
