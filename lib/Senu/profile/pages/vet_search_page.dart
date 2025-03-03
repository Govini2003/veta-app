import 'package:flutter/material.dart';
import '../models/vet.dart';
import '../services/vet_service.dart';

class VetSearchPage extends StatefulWidget {
  const VetSearchPage({Key? key}) : super(key: key);

  @override
  _VetSearchPageState createState() => _VetSearchPageState();
}

class _VetSearchPageState extends State<VetSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Vet> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchVets(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await VetService.searchVets(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching vets: $e')),
      );
    }
  }

  void _navigateToVetProfile(Vet vet) {
    Navigator.pushNamed(context, '/vet-profile', arguments: vet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Vet'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vets by name, specialization, or location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _searchVets,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isEmpty
                              ? 'Start typing to search for vets'
                              : 'No vets found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final vet = _searchResults[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: vet.imageUrl != null
                                    ? NetworkImage(vet.imageUrl!)
                                    : null,
                                child: vet.imageUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(vet.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vet.specialization),
                                  Text(vet.clinicName),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 16, color: Colors.amber),
                                      Text(' ${vet.rating}'),
                                    ],
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              onTap: () => _navigateToVetProfile(vet),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
