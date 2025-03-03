class Vet {
  final String id;
  final String name;
  final String specialization;
  final String clinicName;
  final String address;
  final String phone;
  final String email;
  final String? imageUrl;
  final double rating;
  final List<String> services;
  final String? about;

  Vet({
    required this.id,
    required this.name,
    required this.specialization,
    required this.clinicName,
    required this.address,
    required this.phone,
    required this.email,
    this.imageUrl,
    required this.rating,
    required this.services,
    this.about,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'clinicName': clinicName,
      'address': address,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'rating': rating,
      'services': services,
      'about': about,
    };
  }

  factory Vet.fromMap(Map<String, dynamic> map) {
    return Vet(
      id: map['id'],
      name: map['name'],
      specialization: map['specialization'],
      clinicName: map['clinicName'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      rating: map['rating'].toDouble(),
      services: List<String>.from(map['services']),
      about: map['about'],
    );
  }
}
