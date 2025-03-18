import 'package:auth_firebase/Entrance/EntranceWidgets/button.dart';
import 'package:auth_firebase/Entrance/EntranceWidgets/textfield.dart';
import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
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
                'Reset Your Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                emailSent
                    ? 'Password reset email has been sent. Please check your inbox and follow the instructions to reset your password.'
                    : 'Enter your email address and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              if (!emailSent) ...[
                const SizedBox(height: 30),
                CustomTextField(
                  hint: "Enter your email",
                  label: "Email",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        label: "Send Reset Link",
                        onPressed: _sendResetEmail,
                      ),
              ],
              if (emailSent) ...[
                const SizedBox(height: 30),
                CustomButton(
                  label: "Back to Login",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Use Firebase's built-in password reset functionality
        await _auth.sendFirebasePasswordResetEmail(_emailController.text);

        if (!mounted) return;

        setState(() {
          emailSent = true;
          isLoading = false;
        });
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to send password reset email: ${e.toString()}')),
        );

        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
