import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.noteYellow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textAndOutlines, width: 1),
            ),
            child: Text('Gil Miranda', textAlign: TextAlign.center, style: textTheme.bodyMedium?.copyWith(fontSize: 22)),
          ),
          const SizedBox(height: AppSpacing.gapBetweenSections),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alertButton,
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.textAndOutlines, width: 1),
            ),
            child: Text('Logout', style: textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
