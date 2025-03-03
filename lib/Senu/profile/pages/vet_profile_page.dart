import 'package:flutter/material.dart';
import '../models/vet.dart';

class VetProfilePage extends StatelessWidget {
  final Vet vet;

  const VetProfilePage({Key? key, required this.vet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vet.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: vet.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(vet.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: vet.imageUrl == null
                  ? const Icon(Icons.person, size: 80, color: Colors.grey)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vet.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${vet.rating}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vet.specialization,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    context,
                    'Clinic',
                    [
                      vet.clinicName,
                      vet.address,
                    ],
                    Icons.local_hospital,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    context,
                    'Contact',
                    [
                      'Phone: ${vet.phone}',
                      'Email: ${vet.email}',
                    ],
                    Icons.contact_phone,
                  ),
                  if (vet.about != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoSection(
                      context,
                      'About',
                      [vet.about!],
                      Icons.info,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    context,
                    'Services',
                    vet.services,
                    Icons.medical_services,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement booking functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking feature coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Appointment'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<String> items,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
