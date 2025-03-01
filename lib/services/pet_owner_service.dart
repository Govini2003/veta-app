import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pet_owner.dart';
import 'database_helper.dart';

class PetOwnerService extends ChangeNotifier {
  static final PetOwnerService _instance = PetOwnerService._internal();
  factory PetOwnerService() => _instance;
  
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<PetOwner> _petOwners = [];
  bool _initialized = false;
  PetOwner? _currentOwner;

  // Global key for accessing scaffold messenger
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  // Stream controller for friend request notifications
  final _friendRequestController = StreamController<PetOwner>.broadcast();
  Stream<PetOwner> get friendRequestStream => _friendRequestController.stream;

  PetOwnerService._internal();

  void showNotification(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to friends page
            Navigator.pushNamed(messengerKey.currentContext!, '/friends');
          },
        ),
      ),
    );
  }

  Future<void> _loadPetOwners() async {
    if (_initialized) return;
    
    try {
      _petOwners = await _db.getPetOwners();
      
      // Add sample data if empty
      if (_petOwners.isEmpty) {
        await _initializeSampleData();
      }
      
      _initialized = true;
      print('Loaded ${_petOwners.length} owners from database');
    } catch (e) {
      print('Error loading pet owners: $e');
      // If database fails, keep sample data in memory
      if (_petOwners.isEmpty) {
        _initializeSampleData();
      }
    }
  }

  Future<void> _initializeSampleData() async {
    final sampleOwner = PetOwner(
      name: 'Senuji',
      email: 'sss@gmail.com',
      phone: '074 3074162',
      address: '',
      bio: 'Loving pet parent ',
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    );
    
    _petOwners = [sampleOwner];
    await _db.savePetOwner(sampleOwner);
    print('Initialized with sample data');
  }

  Future<List<PetOwner>> getAllPetOwners() async {
    await _loadPetOwners();
    return _petOwners;
  }

  Future<void> addPetOwner(PetOwner owner) async {
    await _loadPetOwners();
    _petOwners.add(owner);
    await _db.savePetOwner(owner);
    print('Added new pet owner: ${owner.name}');
  }

  Future<void> updatePetOwner(PetOwner updatedOwner) async {
    await _loadPetOwners();
    final index = _petOwners.indexWhere((owner) => owner.email == updatedOwner.email);
    if (index != -1) {
      _petOwners[index] = updatedOwner;
      await _db.updatePetOwner(updatedOwner);
      print('Updated pet owner: ${updatedOwner.name}');
    }
  }

  List<PetOwner> get petOwners {
    final sortedOwners = List<PetOwner>.from(_petOwners);
    sortedOwners.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(sortedOwners);
  }
  
  List<PetOwner> get petOwnersOldestFirst {
    final sortedOwners = List<PetOwner>.from(_petOwners);
    sortedOwners.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(sortedOwners);
  }

  Future<void> deletePetOwner(String email) async {
    try {
      await _db.deletePetOwner(email);
      _petOwners.removeWhere((owner) => owner.email == email);
      print('Deleted owner with email $email from database');
    } catch (e) {
      print('Error deleting pet owner from database: $e');
      rethrow;
    }
  }

  Future<void> updateSecurityCode(String? securityCode) async {
    await _loadPetOwners();
    if (_petOwners.isEmpty) return;

    // Update the first pet owner's security code
    final currentOwner = _petOwners[0];
    final updatedOwner = PetOwner(
      name: currentOwner.name,
      email: currentOwner.email,
      phone: currentOwner.phone,
      address: currentOwner.address,
      imagePath: currentOwner.imagePath,
      bio: currentOwner.bio,
      interests: currentOwner.interests,
      rating: currentOwner.rating,
      gender: currentOwner.gender,
      dateOfBirth: currentOwner.dateOfBirth,
      securityCode: securityCode,
      createdAt: currentOwner.createdAt,
    );

    await _db.updatePetOwner(updatedOwner);
    _petOwners[0] = updatedOwner;
  }

  Future<bool> verifySecurityCode(String securityCode) async {
    await _loadPetOwners();
    if (_petOwners.isEmpty) return false;

    final currentOwner = _petOwners[0];
    return currentOwner.securityCode == securityCode;
  }

  Future<PetOwner?> getCurrentOwner() async {
    await _loadPetOwners();
    return _currentOwner ?? (_petOwners.isNotEmpty ? _petOwners[0] : null);
  }

  Future<List<PetOwner>> getFriends(String email) async {
    await _loadPetOwners();
    final owner = _petOwners.firstWhere((owner) => owner.email == email);
    return _petOwners.where((o) => owner.friendIds.contains(o.email)).toList();
  }

  Future<List<PetOwner>> getPendingFriendRequests(String email) async {
    await _loadPetOwners();
    final owner = _petOwners.firstWhere((owner) => owner.email == email);
    return _petOwners.where((o) => owner.pendingFriendRequests.contains(o.email)).toList();
  }

  Future<List<PetOwner>> searchPetOwners(String query) async {
    await _loadPetOwners();
    final currentOwner = await getCurrentOwner();
    if (currentOwner == null) return [];

    query = query.toLowerCase();
    return _petOwners.where((owner) =>
      owner.email != currentOwner.email &&
      !currentOwner.friendIds.contains(owner.email) &&
      !currentOwner.pendingFriendRequests.contains(owner.email) &&
      !currentOwner.sentFriendRequests.contains(owner.email) &&
      (owner.name.toLowerCase().contains(query) ||
       owner.email.toLowerCase().contains(query))
    ).toList();
  }

  Future<void> sendFriendRequest(String fromEmail, String toEmail) async {
    await _loadPetOwners();
    
    var sender = _petOwners.firstWhere((owner) => owner.email == fromEmail);
    var receiver = _petOwners.firstWhere((owner) => owner.email == toEmail);

    if (!sender.sentFriendRequests.contains(toEmail) && 
        !receiver.pendingFriendRequests.contains(fromEmail)) {
      
      // Update sender's sent requests
      final updatedSender = PetOwner(
        name: sender.name,
        email: sender.email,
        phone: sender.phone,
        address: sender.address,
        imagePath: sender.imagePath,
        bio: sender.bio,
        interests: sender.interests,
        rating: sender.rating,
        gender: sender.gender,
        dateOfBirth: sender.dateOfBirth,
        securityCode: sender.securityCode,
        createdAt: sender.createdAt,
        sentFriendRequests: [...sender.sentFriendRequests, toEmail],
        friendIds: sender.friendIds,
        pendingFriendRequests: sender.pendingFriendRequests,
      );

      // Update receiver's pending requests
      final updatedReceiver = PetOwner(
        name: receiver.name,
        email: receiver.email,
        phone: receiver.phone,
        address: receiver.address,
        imagePath: receiver.imagePath,
        bio: receiver.bio,
        interests: receiver.interests,
        rating: receiver.rating,
        gender: receiver.gender,
        dateOfBirth: receiver.dateOfBirth,
        securityCode: receiver.securityCode,
        createdAt: receiver.createdAt,
        sentFriendRequests: receiver.sentFriendRequests,
        friendIds: receiver.friendIds,
        pendingFriendRequests: [...receiver.pendingFriendRequests, fromEmail],
      );

      // Update database
      await _db.updatePetOwner(updatedSender);
      await _db.updatePetOwner(updatedReceiver);

      // Update local list
      _petOwners = _petOwners.map((owner) {
        if (owner.email == fromEmail) return updatedSender;
        if (owner.email == toEmail) return updatedReceiver;
        return owner;
      }).toList();

      // Notify listeners about the changes
      notifyListeners();

      // Send notification to the receiver
      _friendRequestController.add(updatedReceiver);
    }
  }

  Future<void> acceptFriendRequest(String acceptorEmail, String requesterEmail) async {
    await _loadPetOwners();
    
    var acceptor = _petOwners.firstWhere((owner) => owner.email == acceptorEmail);
    var requester = _petOwners.firstWhere((owner) => owner.email == requesterEmail);

    // Update acceptor's friends and pending requests
    final updatedAcceptor = PetOwner(
      name: acceptor.name,
      email: acceptor.email,
      phone: acceptor.phone,
      address: acceptor.address,
      imagePath: acceptor.imagePath,
      bio: acceptor.bio,
      interests: acceptor.interests,
      rating: acceptor.rating,
      gender: acceptor.gender,
      dateOfBirth: acceptor.dateOfBirth,
      securityCode: acceptor.securityCode,
      createdAt: acceptor.createdAt,
      friendIds: [...acceptor.friendIds, requesterEmail],
      pendingFriendRequests: acceptor.pendingFriendRequests
          .where((email) => email != requesterEmail)
          .toList(),
      sentFriendRequests: acceptor.sentFriendRequests,
    );

    // Update requester's friends and sent requests
    final updatedRequester = PetOwner(
      name: requester.name,
      email: requester.email,
      phone: requester.phone,
      address: requester.address,
      imagePath: requester.imagePath,
      bio: requester.bio,
      interests: requester.interests,
      rating: requester.rating,
      gender: requester.gender,
      dateOfBirth: requester.dateOfBirth,
      securityCode: requester.securityCode,
      createdAt: requester.createdAt,
      friendIds: [...requester.friendIds, acceptorEmail],
      pendingFriendRequests: requester.pendingFriendRequests,
      sentFriendRequests: requester.sentFriendRequests
          .where((email) => email != acceptorEmail)
          .toList(),
    );

    // Update database
    await _db.updatePetOwner(updatedAcceptor);
    await _db.updatePetOwner(updatedRequester);

    // Update local list
    _petOwners = _petOwners.map((owner) {
      if (owner.email == acceptorEmail) return updatedAcceptor;
      if (owner.email == requesterEmail) return updatedRequester;
      return owner;
    }).toList();

    notifyListeners();
  }

  Future<void> rejectFriendRequest(String rejectorEmail, String requesterEmail) async {
    await _loadPetOwners();
    
    var rejector = _petOwners.firstWhere((owner) => owner.email == rejectorEmail);
    var requester = _petOwners.firstWhere((owner) => owner.email == requesterEmail);

    // Update rejector's pending requests
    final updatedRejector = PetOwner(
      name: rejector.name,
      email: rejector.email,
      phone: rejector.phone,
      address: rejector.address,
      imagePath: rejector.imagePath,
      bio: rejector.bio,
      interests: rejector.interests,
      rating: rejector.rating,
      gender: rejector.gender,
      dateOfBirth: rejector.dateOfBirth,
      securityCode: rejector.securityCode,
      createdAt: rejector.createdAt,
      friendIds: rejector.friendIds,
      pendingFriendRequests: rejector.pendingFriendRequests
          .where((email) => email != requesterEmail)
          .toList(),
      sentFriendRequests: rejector.sentFriendRequests,
    );

    // Update requester's sent requests
    final updatedRequester = PetOwner(
      name: requester.name,
      email: requester.email,
      phone: requester.phone,
      address: requester.address,
      imagePath: requester.imagePath,
      bio: requester.bio,
      interests: requester.interests,
      rating: requester.rating,
      gender: requester.gender,
      dateOfBirth: requester.dateOfBirth,
      securityCode: requester.securityCode,
      createdAt: requester.createdAt,
      friendIds: requester.friendIds,
      pendingFriendRequests: requester.pendingFriendRequests,
      sentFriendRequests: requester.sentFriendRequests
          .where((email) => email != rejectorEmail)
          .toList(),
    );

    // Update database
    await _db.updatePetOwner(updatedRejector);
    await _db.updatePetOwner(updatedRequester);

    // Update local list
    _petOwners = _petOwners.map((owner) {
      if (owner.email == rejectorEmail) return updatedRejector;
      if (owner.email == requesterEmail) return updatedRequester;
      return owner;
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    _friendRequestController.close();
    super.dispose();
  }
}
