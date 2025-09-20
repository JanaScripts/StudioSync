import 'studio_detail.dart';

class Reservation {
  final String name;
  final String contact;
  final String email;
  final DateTime selectedDate;
  final List<int> selectedHours;
  final List<String> addOns;
  final Studio studio;
  final double total;

  Reservation({
    required this.name,
    required this.contact,
    required this.email,
    required this.selectedDate,
    required this.selectedHours,
    required this.addOns,
    required this.studio,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'email': email,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedHours': selectedHours,
      'addOns': addOns,
      'studio': {
        'name': studio.name,
        'description': studio.description,
        'equipment': studio.equipment,
        'price': studio.price,
        'imagePath': studio.imagePath,
        'maxHead': studio.maxHead,
      },
      'total': total,
    };
  }
}
