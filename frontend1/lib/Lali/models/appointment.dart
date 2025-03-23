// veta-app/frontend1/lib/Lali/models/appointment.dart
class Appointment {
  final String vetName;
  final String vetSpecialty;
  final String clinicName;
  final DateTime dateTime;
  final String vetImage;

  Appointment({
    required this.vetName,
    required this.vetSpecialty,
    required this.clinicName,
    required this.dateTime,
    required this.vetImage,
  });

  // Convert appointment to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'vetName': vetName,
      'vetSpecialty': vetSpecialty,
      'clinicName': clinicName,
      'dateTime': dateTime.toIso8601String(),
      'vetImage': vetImage,
    };
  }

  // Create appointment from a map
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      vetName: map['vetName'],
      vetSpecialty: map['vetSpecialty'],
      clinicName: map['clinicName'],
      dateTime: DateTime.parse(map['dateTime']),
      vetImage: map['vetImage'],
    );
  }
} 
