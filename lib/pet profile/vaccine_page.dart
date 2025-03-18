// veta-app/lib/pet profile/vaccine_page.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VaccinePage extends StatefulWidget {
  final bool isEditing;
  final String? initialVaccineType;
  final String? initialVaccinationDate;
  final String? initialRenewalDate;
  final String? initialVeterinarianName;
  final String? initialVetRegNo; // pet register number page
  final String? initialDescription;

  const VaccinePage({
    Key? key,
    this.isEditing = false,
    this.initialVaccineType,
    this.initialVaccinationDate,
    this.initialRenewalDate,
    this.initialVeterinarianName,
    this.initialVetRegNo,
    this.initialDescription,
  }) : super(key: key);

  @override
  State<VaccinePage> createState() => _VaccinePageState();
}

class _VaccinePageState extends State<VaccinePage> {
  late TextEditingController _veterinarianNameController;
  late TextEditingController _vetRegNoController;
  late TextEditingController _otherVaccineController;
  late TextEditingController _descriptionController;
  String? _selectedVaccineType;
  String? _selectedDate;
  String? _selectedRenewalDate;
  File? vaccineLabel;

  final List<String> _vaccineTypes = [
    'Rabies',
    'Parvovirus',
    'Distemper',
    'Bordetella',
    'Leptospirosis',
    'FVRCP',
    'FeLV',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _veterinarianNameController = TextEditingController(text: widget.initialVeterinarianName ?? '');
    _vetRegNoController = TextEditingController(text: widget.initialVetRegNo ?? '');
    _otherVaccineController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _selectedVaccineType = widget.initialVaccineType;
    _selectedDate = widget.initialVaccinationDate;
    _selectedRenewalDate = widget.initialRenewalDate;

    // If editing an "Other" type vaccine, set the other vaccine controller
    if (widget.isEditing && !_vaccineTypes.contains(widget.initialVaccineType)) {
      _selectedVaccineType = 'Other';
      _otherVaccineController.text = widget.initialVaccineType ?? '';
    }

    // Debug print for initial values
    print('Initial Veterinarian Name: ${widget.initialVeterinarianName}');
    print('Initial Renewal Date: ${widget.initialRenewalDate}');
  }

  @override
  void dispose() {
    _veterinarianNameController.dispose();
    _vetRegNoController.dispose();
    _otherVaccineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _uploadVaccineLabel() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        vaccineLabel = File(image.path);
      });
    }
  }

  void _submitVaccination() {
    if (_selectedVaccineType != null && _selectedDate != null && _veterinarianNameController.text.isNotEmpty) {
      // Get the final vaccine type (either selected or custom)
      final vaccineType = _selectedVaccineType == 'Other' 
          ? _otherVaccineController.text.trim() 
          : _selectedVaccineType!;
          
      if (_selectedVaccineType == 'Other' && _otherVaccineController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the vaccine type')),
        );
        return;
      }
      
      // Always include description and vaccine label, with null checks
      Navigator.pop(context, {
        'vaccineType': vaccineType,
        'vaccinationDate': _selectedDate,
        'renewalDate': _selectedRenewalDate,
        'veterinarianName': _veterinarianNameController.text,
        'vetRegNo': _vetRegNoController.text.isNotEmpty ? _vetRegNoController.text : null,
        'vaccineLabel': _selectedVaccineType == 'Other' ? null : vaccineLabel,
        'description': _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Vaccination' : 'Add Vaccination',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: const Color(0xFF1D4D4F),
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Vaccination Details',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4D4F),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildVaccineTypeDropdown(),
                const SizedBox(height: 16),
                
                if (_selectedVaccineType == 'Other') ...[
                  _buildOtherVaccineTextField(),
                  const SizedBox(height: 16),
                  _buildDescriptionTextField(),
                  const SizedBox(height: 16),
                ],
                
                _buildDateSelectionSection(),
                const SizedBox(height: 16),
                
                if (_selectedVaccineType != 'Other')
                  _buildRenewalDateSelectionSection(),
                const SizedBox(height: 16),
                
                _buildVetNameSection(),
                const SizedBox(height: 16),
                
                if (_selectedVaccineType != 'Other')
                  _buildVaccineLabelSection(),
                const SizedBox(height: 24),
                
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVaccineTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vaccine Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedVaccineType,
              isExpanded: true,
              hint: Text(
                'Select Vaccine Type',
                style: TextStyle(color: Colors.grey[600]),
              ),
              items: _vaccineTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1D4D4F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedVaccineType = newValue;
                });
              },
              style: const TextStyle(
                color: Color(0xFF1D4D4F),
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Color(0xFF1D4D4F)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherVaccineTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: _otherVaccineController,
        decoration: InputDecoration(
          hintText: 'Enter vaccine Name',
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF357376), width: 2),
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF1D4D4F),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Enter reason for vaccination',
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF357376), width: 2),
          ),
        ),
        style: const TextStyle(
          color: Color(0xFF1D4D4F),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vaccination Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF357376),
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked.toString().split(' ')[0];
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate ?? 'Select Date',
                        style: TextStyle(
                          color: _selectedDate != null ? Color(0xFF1D4D4F) : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: Color(0xFF357376)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRenewalDateSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Renewal Date',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xFF357376),
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedRenewalDate = picked.toString().split(' ')[0];
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedRenewalDate ?? 'Select Renewal Date',
                        style: TextStyle(
                          color: _selectedRenewalDate != null ? Color(0xFF1D4D4F) : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: Color(0xFF357376)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVetNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Veterinarian Name',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: TextFormField(
            controller: _veterinarianNameController,
            decoration: InputDecoration(
              hintText: 'Enter veterinarian name',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              color: Color(0xFF1D4D4F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Veterinarian Registration Number',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: TextFormField(
            controller: _vetRegNoController,
            decoration: InputDecoration(
              hintText: 'Enter registration number',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              color: Color(0xFF1D4D4F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineLabelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vaccine Label',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D4D4F),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _uploadVaccineLabel,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: vaccineLabel == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 50,
                          color: Color(0xFF357376),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Upload Vaccine Label',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      vaccineLabel!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitVaccination,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF357376),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
      ),
      child: Text(
        widget.isEditing ? 'Update Vaccination' : 'Add Vaccination',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
