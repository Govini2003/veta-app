// veta-app/lib/pet profile/vaccine_details_page.dart
// to show vaccine details
import 'package:flutter/material.dart';
import 'dart:io';
import 'vaccine_page.dart';
import 'dart:developer' as developer;

class VaccineDetailsPage extends StatefulWidget {
  final String vaccineType;
  final String vaccinationDate;
  final String? renewalDate;
  final File? vaccineLabel;
  final String veterinarianName;
  final String? vetRegNo;
  final int vaccineIndex;
  final String? description; // for other vaccines

  const VaccineDetailsPage({
    Key? key,
    required this.vaccineType,
    required this.vaccinationDate,
    this.renewalDate,
    required this.veterinarianName,
    this.vetRegNo,
    this.vaccineLabel,
    required this.vaccineIndex,
    this.description,
  }) : super(key: key);

  @override
  _VaccineDetailsPageState createState() => _VaccineDetailsPageState();
}

class _VaccineDetailsPageState extends State<VaccineDetailsPage> {
  @override
  void initState() {
    super.initState();
    developer.log('VaccineDetailsPage initialized', 
      name: 'VaccineDetailsPage',
      error: {
        'vaccineType': widget.vaccineType,
        'vaccinationDate': widget.vaccinationDate,
        'veterinarianName': widget.veterinarianName,
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D4D4F),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Veta.lk'),
          titleSpacing: 0,
        ),
        body: Container(
          color: Color(0xFFE9EFEC),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Vaccine Details',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4D4F),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF1D4D4F).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 25,
                                  color: Color(0xFF1D4D4F),
                                ),
                                tooltip: 'Edit',
                                onPressed: _onEditPressed,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 25,
                                  color: Colors.red,
                                ),
                                tooltip: 'Delete',
                                onPressed: _showDeleteConfirmation,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Vaccine Type', widget.vaccineType),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildDetailRow('Vaccination Date', widget.vaccinationDate),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          if (widget.renewalDate != null) ...[
                            _buildDetailRow('Renewal Date', widget.renewalDate!),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                          ],
                          _buildDetailRow('Veterinarian Name', widget.veterinarianName),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          if (widget.vetRegNo != null && widget.vetRegNo!.isNotEmpty) ...[
                            _buildDetailRow('Registration Num', widget.vetRegNo!),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                          ],
                          if (widget.description != null && widget.description!.isNotEmpty) ...[
                            _buildDetailRow('Reason for Vaccination', widget.description!),
                            const Divider(height: 1, indent: 16, endIndent: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (widget.vaccineLabel != null) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vaccine Label',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D4D4F),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                widget.vaccineLabel!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      developer.log('Error in build method', 
        name: 'VaccineDetailsPage', 
        error: e, 
        stackTrace: stackTrace
      );
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text('An error occurred: $e'),
        ),
      );
    }
  }

  void _onEditPressed() async {
    try {
      developer.log('Edit button pressed', name: 'VaccineDetailsPage');
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VaccinePage(
            isEditing: true,
            initialVaccineType: widget.vaccineType,
            initialVaccinationDate: widget.vaccinationDate,
            initialRenewalDate: widget.renewalDate,
            initialVeterinarianName: widget.veterinarianName,
            initialVetRegNo: widget.vetRegNo,
            initialDescription: widget.description,
          ),
        ),
      );
      
      if (result != null && mounted) {
        developer.log('Edit result received', 
          name: 'VaccineDetailsPage', 
          error: result
        );
        Navigator.pop(context, {
          'action': 'update',
          'index': widget.vaccineIndex,
          'data': result,
        });
      }
    } catch (e, stackTrace) {
      developer.log('Error in edit process', 
        name: 'VaccineDetailsPage', 
        error: e, 
        stackTrace: stackTrace
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Detailed error editing vaccine: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation() {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Vaccination'),
            content: const Text('Are you sure you want to delete this vaccination record?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  developer.log('Vaccine record deleted', 
                    name: 'VaccineDetailsPage',
                    error: {
                      'index': widget.vaccineIndex,
                      'vaccineType': widget.vaccineType
                    }
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop({
                    'action': 'delete', 
                    'index': widget.vaccineIndex
                  });
                },
              ),
            ],
          );
        },
      );
    } catch (e, stackTrace) {
      developer.log('Error in delete confirmation', 
        name: 'VaccineDetailsPage', 
        error: e, 
        stackTrace: stackTrace
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1D4D4F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
