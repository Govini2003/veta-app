// veta-app/lib/models/vet.dart

class Vet {
  final String name;
  final String specialization;
  final double rating;
  final String distance;
  final List<String> availableSlots;

  Vet({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.distance,
    required this.availableSlots,
  });
}
