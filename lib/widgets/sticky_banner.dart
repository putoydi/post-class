import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StickyBanner extends StatelessWidget {
  const StickyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 35, color: AppColors.notePink)),
        Expanded(child: Container(height: 35, color: AppColors.noteYellow)),
        Expanded(child: Container(height: 35, color: AppColors.noteGreen)),
        Expanded(child: Container(height: 35, color: AppColors.noteCyan)),
        Expanded(child: Container(height: 35, color: AppColors.noteWhite)),
      ],
    );
  }
}
