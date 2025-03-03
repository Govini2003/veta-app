import '../models/vet.dart';

class VetService {
  static Future<List<Vet>> searchVets(String query) async {
    // TODO: Replace with actual API call to get vets from backend
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  static Future<Vet?> getVetById(String id) async {
    // TODO: Replace with actual API call to get vet details from backend
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }
}
