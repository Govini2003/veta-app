import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PetList extends StatelessWidget {
  const PetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add Pet',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
