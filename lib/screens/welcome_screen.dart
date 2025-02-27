import 'package:flutter/material.dart';
import 'package:veta_1/screens/signin_screen.dart';
import 'package:veta_1/screens/signup_screen.dart';
import 'package:veta_1/screens/forgetpassword_screen.dart';
import 'package:veta_1/widgets/custom_scaffold.dart';
import 'package:veta_1/widgets/welcome_button.dart';
import 'package:veta_1/themes/theme.dart';

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
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
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
                            )),
                        TextSpan(
                            text: '\n No more struggle for Pet Owners and Vets',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: Colors.white,
                      textColor: Theme.of(context)
                          .colorScheme
                          .primary, // Fix theme usage
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
