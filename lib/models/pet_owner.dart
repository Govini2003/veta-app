// veta-app/lib/models/pet_owner.dart
import 'package:flutter/material.dart';

class PetOwner {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? imagePath;
  final String? bio;
  final List<String>? interests;
  final double? rating;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  final List<String> friendIds; // List of friend email IDs
  final List<String> pendingFriendRequests; // List of pending friend request email IDs
  final List<String> sentFriendRequests; // List of sent friend request email IDs
  final String? securityCode;
  final List<Pet> pets;
  final List<ServiceBooking> serviceBookings;
  final List<Reminder> reminders;
  final DateTime lastUpdated;
  final String preferredContactMethod;

  PetOwner({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.imagePath,
    this.bio,
    this.interests,
    this.rating,
    this.gender,
    this.dateOfBirth,
    this.securityCode,
    DateTime? createdAt,
    List<String>? friendIds,
    List<String>? pendingFriendRequests,
    List<String>? sentFriendRequests,
    List<Pet>? pets,
    List<ServiceBooking>? serviceBookings,
    List<Reminder>? reminders,
    DateTime? lastUpdated,
    String? preferredContactMethod,
  }) : this.createdAt = createdAt ?? DateTime.now(),
       this.friendIds = friendIds ?? [],
       this.pendingFriendRequests = pendingFriendRequests ?? [],
       this.sentFriendRequests = sentFriendRequests ?? [],
       this.pets = pets ?? [],
       this.serviceBookings = serviceBookings ?? [],
       this.reminders = reminders ?? [],
       this.lastUpdated = lastUpdated ?? DateTime.now(),
       this.preferredContactMethod = preferredContactMethod ?? '';

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'imagePath': imagePath,
      'bio': bio,
      'interests': interests,
      'rating': rating,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'friendIds': friendIds,
      'pendingFriendRequests': pendingFriendRequests,
      'sentFriendRequests': sentFriendRequests,
      'securityCode': securityCode,
      'pets': pets.map((p) => p.toJson()).toList(),
      'serviceBookings': serviceBookings.map((b) => b.toJson()).toList(),
      'reminders': reminders.map((r) => r.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'preferredContactMethod': preferredContactMethod,
    };
  }

  // Create from Map
  factory PetOwner.fromMap(Map<String, dynamic> map) {
    return PetOwner(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      imagePath: map['imagePath'],
      bio: map['bio'],
      interests: map['interests'] != null ? List<String>.from(map['interests']) : null,
      rating: map['rating']?.toDouble(),
      gender: map['gender'],
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      securityCode: map['securityCode'],
      friendIds: map['friendIds'] != null ? List<String>.from(map['friendIds']) : [],
      pendingFriendRequests: map['pendingFriendRequests'] != null ? List<String>.from(map['pendingFriendRequests']) : [],
      sentFriendRequests: map['sentFriendRequests'] != null ? List<String>.from(map['sentFriendRequests']) : [],
      pets: map['pets'] != null ? List<Pet>.from(map['pets'].map((x) => Pet.fromJson(x))) : [],
      serviceBookings: map['serviceBookings'] != null ? List<ServiceBooking>.from(map['serviceBookings'].map((x) => ServiceBooking.fromJson(x))) : [],
      reminders: map['reminders'] != null ? List<Reminder>.from(map['reminders'].map((x) => Reminder.fromJson(x))) : [],
      lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
      preferredContactMethod: map['preferredContactMethod'] ?? '',
    );
  }

  // Add copyWith method
  PetOwner copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? imagePath,
    String? bio,
    DateTime? createdAt,
    List<String>? sentFriendRequests,
    List<String>? friendIds,
    List<String>? pendingFriendRequests,
    List<Pet>? pets,
    List<ServiceBooking>? serviceBookings,
    List<Reminder>? reminders,
    DateTime? lastUpdated,
    String? preferredContactMethod,
  }) {
    return PetOwner(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      imagePath: imagePath ?? this.imagePath,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
      friendIds: friendIds ?? this.friendIds,
      pendingFriendRequests: pendingFriendRequests ?? this.pendingFriendRequests,
      pets: pets ?? this.pets,
      serviceBookings: serviceBookings ?? this.serviceBookings,
      reminders: reminders ?? this.reminders,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      preferredContactMethod: preferredContactMethod ?? this.preferredContactMethod,
    );
  }

  // Sample data generator
  static List<PetOwner> getSampleOwners() {
    return [
      PetOwner(
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+94 77 123 4567',
        address: 'No 123, Sample Street, Colombo',
        bio: 'Loving pet owner with 2 dogs and a cat',
        interests: ['Dog Walking', 'Pet Sitting'],
        rating: 4.5,
        pets: [
          Pet(
            id: '1',
            name: 'Buddy',
            species: 'Dog',
            breed: 'Golden Retriever',
            gender: 'Male',
            birthday: DateTime(2015, 1, 1),
            weight: 20.0,
            height: 20.0,
            healthInfo: ['Allergic to chicken'],
            imagePaths: ['https://example.com/buddy.jpg'],
            vaccinations: [
              VaccinationRecord(
                name: 'Rabies',
                date: DateTime(2016, 1, 1),
                nextDueDate: DateTime(2017, 1, 1),
                veterinarian: 'Dr. Jane Smith',
              ),
            ],
            vetVisits: [
              VetVisit(
                date: DateTime(2016, 1, 1),
                reason: 'Check-up',
                diagnosis: 'Healthy',
                prescription: 'None',
                veterinarian: 'Dr. Jane Smith',
                clinic: 'Pet Care Clinic',
              ),
            ],
            feedingSchedule: FeedingSchedule(
              meals: [
                Meal(
                  hour: 8,
                  minute: 0,
                  food: 'Kibble',
                  quantity: 1.0,
                ),
              ],
              dietPreferences: 'None',
              allergies: ['Chicken'],
            ),
          ),
        ],
        serviceBookings: [
          ServiceBooking(
            id: '1',
            serviceType: 'Grooming',
            providerName: 'Pet Grooming Salon',
            providerAddress: 'No 456, Grooming Street, Colombo',
            appointmentTime: DateTime(2022, 1, 1, 10, 0),
            status: 'Booked',
            notes: 'Buddy needs a bath',
          ),
        ],
        reminders: [
          Reminder(
            id: '1',
            title: 'Buddy\'s vaccination due',
            description: 'Rabies vaccination due on January 1, 2023',
            dueDate: DateTime(2023, 1, 1),
            isRecurring: false,
            recurrencePattern: null,
            isCompleted: false,
          ),
        ],
        preferredContactMethod: 'Phone',
      ),
      PetOwner(
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+94 76 234 5678',
        address: 'No 456, Test Avenue, Kandy',
        bio: 'Professional pet trainer',
        interests: ['Pet Training', 'Grooming'],
        rating: 5.0,
        pets: [
          Pet(
            id: '2',
            name: 'Whiskers',
            species: 'Cat',
            breed: 'Siamese',
            gender: 'Female',
            birthday: DateTime(2010, 1, 1),
            weight: 10.0,
            height: 10.0,
            healthInfo: ['Allergic to dust'],
            imagePaths: ['https://example.com/whiskers.jpg'],
            vaccinations: [
              VaccinationRecord(
                name: 'Rabies',
                date: DateTime(2011, 1, 1),
                nextDueDate: DateTime(2012, 1, 1),
                veterinarian: 'Dr. John Doe',
              ),
            ],
            vetVisits: [
              VetVisit(
                date: DateTime(2011, 1, 1),
                reason: 'Check-up',
                diagnosis: 'Healthy',
                prescription: 'None',
                veterinarian: 'Dr. John Doe',
                clinic: 'Pet Care Clinic',
              ),
            ],
            feedingSchedule: FeedingSchedule(
              meals: [
                Meal(
                  hour: 12,
                  minute: 0,
                  food: 'Wet food',
                  quantity: 0.5,
                ),
              ],
              dietPreferences: 'None',
              allergies: ['Dust'],
            ),
          ),
        ],
        serviceBookings: [
          ServiceBooking(
            id: '2',
            serviceType: 'Training',
            providerName: 'Pet Training School',
            providerAddress: 'No 789, Training Street, Kandy',
            appointmentTime: DateTime(2022, 1, 1, 14, 0),
            status: 'Booked',
            notes: 'Whiskers needs training',
          ),
        ],
        reminders: [
          Reminder(
            id: '2',
            title: 'Whiskers\' vaccination due',
            description: 'Rabies vaccination due on January 1, 2023',
            dueDate: DateTime(2023, 1, 1),
            isRecurring: false,
            recurrencePattern: null,
            isCompleted: false,
          ),
        ],
        preferredContactMethod: 'Email',
      ),
    ];
  }
}

class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String gender;
  final DateTime birthday;
  final double weight;
  final double height;
  final List<String> healthInfo;
  final List<String> imagePaths;
  final List<VaccinationRecord> vaccinations;
  final List<VetVisit> vetVisits;
  final FeedingSchedule feedingSchedule;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthday,
    required this.weight,
    required this.height,
    required this.healthInfo,
    required this.imagePaths,
    required this.vaccinations,
    required this.vetVisits,
    required this.feedingSchedule,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'gender': gender,
        'birthday': birthday.toIso8601String(),
        'weight': weight,
        'height': height,
        'healthInfo': healthInfo,
        'imagePaths': imagePaths,
        'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
        'vetVisits': vetVisits.map((v) => v.toJson()).toList(),
        'feedingSchedule': feedingSchedule.toJson(),
      };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'],
        name: json['name'],
        species: json['species'],
        breed: json['breed'],
        gender: json['gender'],
        birthday: DateTime.parse(json['birthday']),
        weight: json['weight'].toDouble(),
        height: json['height'].toDouble(),
        healthInfo: List<String>.from(json['healthInfo']),
        imagePaths: List<String>.from(json['imagePaths']),
        vaccinations: List<VaccinationRecord>.from(
            json['vaccinations'].map((x) => VaccinationRecord.fromJson(x))),
        vetVisits:
            List<VetVisit>.from(json['vetVisits'].map((x) => VetVisit.fromJson(x))),
        feedingSchedule: FeedingSchedule.fromJson(json['feedingSchedule']),
      );
}

class VaccinationRecord {
  final String name;
  final DateTime date;
  final DateTime nextDueDate;
  final String veterinarian;

  VaccinationRecord({
    required this.name,
    required this.date,
    required this.nextDueDate,
    required this.veterinarian,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'nextDueDate': nextDueDate.toIso8601String(),
        'veterinarian': veterinarian,
      };

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) => VaccinationRecord(
        name: json['name'],
        date: DateTime.parse(json['date']),
        nextDueDate: DateTime.parse(json['nextDueDate']),
        veterinarian: json['veterinarian'],
      );
}

class VetVisit {
  final DateTime date;
  final String reason;
  final String diagnosis;
  final String prescription;
  final String veterinarian;
  final String clinic;

  VetVisit({
    required this.date,
    required this.reason,
    required this.diagnosis,
    required this.prescription,
    required this.veterinarian,
    required this.clinic,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'reason': reason,
        'diagnosis': diagnosis,
        'prescription': prescription,
        'veterinarian': veterinarian,
        'clinic': clinic,
      };

  factory VetVisit.fromJson(Map<String, dynamic> json) => VetVisit(
        date: DateTime.parse(json['date']),
        reason: json['reason'],
        diagnosis: json['diagnosis'],
        prescription: json['prescription'],
        veterinarian: json['veterinarian'],
        clinic: json['clinic'],
      );
}

class FeedingSchedule {
  final List<Meal> meals;
  final String dietPreferences;
  final List<String> allergies;

  FeedingSchedule({
    required this.meals,
    required this.dietPreferences,
    required this.allergies,
  });

  Map<String, dynamic> toJson() => {
        'meals': meals.map((m) => m.toJson()).toList(),
        'dietPreferences': dietPreferences,
        'allergies': allergies,
      };

  factory FeedingSchedule.fromJson(Map<String, dynamic> json) => FeedingSchedule(
        meals: List<Meal>.from(json['meals'].map((x) => Meal.fromJson(x))),
        dietPreferences: json['dietPreferences'],
        allergies: List<String>.from(json['allergies']),
      );
}

class Meal {
  final int hour;
  final int minute;
  final String food;
  final double quantity;

  Meal({
    required this.hour,
    required this.minute,
    required this.food,
    required this.quantity,
  });

  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  Map<String, dynamic> toJson() => {
        'hour': hour,
        'minute': minute,
        'food': food,
        'quantity': quantity,
      };

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        hour: json['hour'] as int,
        minute: json['minute'] as int,
        food: json['food'] as String,
        quantity: (json['quantity'] as num).toDouble(),
      );
}

class ServiceBooking {
  final String id;
  final String serviceType;
  final String providerName;
  final String providerAddress;
  final DateTime appointmentTime;
  final String status;
  final String notes;

  ServiceBooking({
    required this.id,
    required this.serviceType,
    required this.providerName,
    required this.providerAddress,
    required this.appointmentTime,
    required this.status,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceType': serviceType,
        'providerName': providerName,
        'providerAddress': providerAddress,
        'appointmentTime': appointmentTime.toIso8601String(),
        'status': status,
        'notes': notes,
      };

  factory ServiceBooking.fromJson(Map<String, dynamic> json) => ServiceBooking(
        id: json['id'],
        serviceType: json['serviceType'],
        providerName: json['providerName'],
        providerAddress: json['providerAddress'],
        appointmentTime: DateTime.parse(json['appointmentTime']),
        status: json['status'],
        notes: json['notes'],
      );
}

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isRecurring;
  final String? recurrencePattern;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isRecurring,
    this.recurrencePattern,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'isRecurring': isRecurring,
        'recurrencePattern': recurrencePattern,
        'isCompleted': isCompleted,
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        isRecurring: json['isRecurring'],
        recurrencePattern: json['recurrencePattern'],
        isCompleted: json['isCompleted'],
      );
}
