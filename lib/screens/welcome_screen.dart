// veta-app/lib/screens/welcome_screen.dart


// final welcome page
import 'signin_screen.dart'; 
import 'signup_screen.dart'; 
import 'forgetpassword_screen.dart'; 
import '../widgets/custom_scaffold.dart'; 
import '../widgets/welcome_button.dart'; 
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Veta.LK\n',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: '\n No more struggle for Pet Owners and Vets',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: const SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
