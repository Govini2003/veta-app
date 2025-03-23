import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/appointment.dart';

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  static const String _storageKey = 'appointments';

  List<Appointment> get appointments => _appointments;

  List<Appointment> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => appointment.dateTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  AppointmentsProvider() {
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? appointmentsJson = prefs.getString(_storageKey);
    
    if (appointmentsJson != null) {
      final List<dynamic> decodedList = json.decode(appointmentsJson);
      _appointments = decodedList
          .map((item) => Appointment.fromMap(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList =
        json.encode(_appointments.map((a) => a.toMap()).toList());
    await prefs.setString(_storageKey, encodedList);
  }

  Future<void> addAppointment(Appointment appointment) async {
    _appointments.add(appointment);
    await _saveAppointments();
    notifyListeners();
  }

  Future<void> removeAppointment(Appointment appointment) async {
    _appointments.removeWhere((a) =>
        a.vetName == appointment.vetName &&
        a.dateTime == appointment.dateTime);
    await _saveAppointments();
    notifyListeners();
  }

  Future<void> clearAllAppointments() async {
    _appointments.clear();
    await _saveAppointments();
    notifyListeners();
  }
} 