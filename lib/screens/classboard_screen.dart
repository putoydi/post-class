import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ClassboardScreen extends StatelessWidget {
  final String className;
  final Color colorAccent;
  final String professorName;

  const ClassboardScreen({
    super.key,
    required this.className,
    required this.colorAccent,
    required this.professorName,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = professorName.isEmpty;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Custom Classboard Dynamic Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdgePadding,
                vertical: AppSpacing.md,
              ),
              decoration: const BoxDecoration(
                color: AppColors.noteYellow, // Matches yellow style from your mockup sheet headers
                border: Border(bottom: BorderSide(color: AppColors.textAndOutlines, width: 1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textAndOutlines),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Classboard', 
                    style: textTheme.headlineSmall?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Sub-Banner Course Meta Segment Block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
              decoration: BoxDecoration(
                color: colorAccent,
                border: const Border(bottom: BorderSide(color: AppColors.textAndOutlines, width: 1)),
              ),
              child: Text(className, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            
            // Screen Feed Body
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bedtime_outlined, size: 80, color: AppColors.textAndOutlines),
                          const SizedBox(height: AppSpacing.md),
                          Text('No posts yet...', style: textTheme.bodyMedium?.copyWith(color: AppColors.placeholderText)),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenEdgePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(professorName, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.authContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.textAndOutlines, width: 1),
                            ),
                            child: Text('Hello, if you are reading this, I do not know yet.', style: textTheme.bodyMedium),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
