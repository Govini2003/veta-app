//frontend1/lib/LoginSignupAuth/verification_screen.dart
import 'package:auth_firebase/Entrance/EntranceWidgets/button.dart';
import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/LoginSignupAuth/reset_password_screen.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String verificationCode; // For demo purposes, we pass the code directly

  const VerificationScreen({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Verify Your Email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'We have sent a verification code to ${widget.email}. Please enter the code below.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Code input field
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  hintText: "Enter verification code",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  label: const Text("Verification Code"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  if (value.length < 6) {
                    return 'Please enter the complete 6-digit code';
                  }
                  return null;
                },
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      label: "Verify Code",
                      onPressed: _verifyCode,
                    ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: _resendCode,
                child: const Text("Resend Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        // For demo purposes, we're directly comparing the code
        // In a real app, this would be verified on the server
        final isValid = _auth.verifyResetCode(_codeController.text);

        if (isValid) {
          if (!mounted) return;

          // Navigate to reset password screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: widget.email,
              ),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'Invalid verification code. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Verification failed: ${e.toString()}';
        });
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // In a real app, this would send a new code via email
      await _auth.sendPasswordResetEmail(widget.email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('A new verification code has been sent to your email')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to resend code: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
