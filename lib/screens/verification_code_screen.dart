// veta-app/lib/screens/verification_code_screen.dart
// final verification code screen
import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({super.key, required this.email});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification Successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the verification code sent to ${widget.email}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  } else if (value.length != 6) {
                    return 'Code must be 6 digits';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  child: const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
