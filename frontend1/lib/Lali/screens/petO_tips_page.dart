import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetOTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Care Tips',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipSection(
              'Diet & Nutrition',
              Icons.restaurant,
              [
                'Balanced Diet – Feed high-quality pet food suited to your pet\'s age, breed, and size.',
                'Hydration – Ensure fresh water is always available. Dehydration can cause serious health issues.',
                'Portion Control – Overfeeding leads to obesity, which can cause diabetes and joint problems.',
              ],
            ),
            SizedBox(height: 24),
            _buildTipSection(
              'Exercise & Mental Stimulation',
              Icons.fitness_center,
              [
                'Daily Walks & Playtime – Keeps pets fit and mentally engaged.',
                'Interactive Toys – Puzzle feeders and treat-dispensing toys prevent boredom.',
                'Training & Commands – Teach simple tricks to keep their mind sharp.',
              ],
            ),
            SizedBox(height: 24),
            _buildTipSection(
              'Grooming & Hygiene',
              Icons.content_cut,
              [
                'Regular Brushing – Helps reduce shedding and prevents matting.',
                'Ear Cleaning – Prevents infections, especially for floppy-eared breeds.',
                'Nail Trimming – Overgrown nails can cause pain and mobility issues.',
              ],
            ),
            SizedBox(height: 24),
            _buildTipSection(
              'Preventive Healthcare',
              Icons.medical_services,
              [
                'Vaccinations & Deworming – Protect against common diseases.',
                'Flea & Tick Prevention – Use vet-approved treatments to avoid infestations.',
                'Routine Vet Checkups – Early detection of health issues is key.',
              ],
            ),
            SizedBox(height: 24),
            _buildTipSection(
              'Home Remedies & First Aid',
              Icons.healing,
              [
                'Coconut Oil – Helps with dry skin and promotes a shiny coat.',
                'Pumpkin for Digestion – A small amount helps with diarrhea or constipation.',
                'Honey for Coughs – Can soothe minor throat irritation (but avoid for diabetic pets).',
                'Aloe Vera (Pet-Safe) – Helps with minor skin irritations (ensure it\'s safe for pets).',
              ],
            ),
            SizedBox(height: 24),
            _buildTipSection(
              'Stress & Anxiety Relief',
              Icons.psychology,
              [
                'Calming Music – Helps anxious pets during thunderstorms or fireworks.',
                'Safe Spaces – Provide a quiet area for pets to retreat when overwhelmed.',
                'Chew Toys – Helps reduce stress and prevents destructive chewing.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection(String title, IconData icon, List<String> tips) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF357376), size: 28),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF357376),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...tips.map((tip) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF357376), size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontFamily: 'Questrial',
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
} 