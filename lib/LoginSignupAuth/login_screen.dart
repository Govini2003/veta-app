import 'dart:developer';

import 'package:auth_firebase/LoginSignupAuth/auth_service.dart';
import 'package:auth_firebase/LoginSignupAuth/signup_screen.dart';
import 'package:auth_firebase/Entrance/role_selection_screen.dart';
import 'package:auth_firebase/Entrance/EntranceWidgets/button.dart';
import 'package:auth_firebase/Entrance/EntranceWidgets/textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              const Text("Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(height: 50),
              CustomTextField(
                hint: "Enter Email",
                label: "Email",
                controller: _email,
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
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Password",
                label: "Password",
                controller: _password,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: "Login",
                onPressed: _login,
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      label: "Signin with Google",
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await _auth.loginWithGoogle();
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? "),
                InkWell(
                  onTap: () => goToSignup(context),
                  child:
                      const Text("Signup", style: TextStyle(color: Colors.red)),
                )
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);
        // Navigate to home or next screen after successful login
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
