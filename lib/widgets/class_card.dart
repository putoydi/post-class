import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ClassCard extends StatelessWidget {
  final String className;
  final String code;
  final String latestPost;
  final Color backgroundColor;
  final Color headerColor;
  final VoidCallback onTap;

  const ClassCard({
    super.key,
    required this.className,
    required this.code,
    required this.latestPost,
    required this.backgroundColor,
    required this.headerColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    bool hasPostContent = latestPost.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.gapBetweenItems),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textAndOutlines, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: hasPostContent 
                      ? const BorderRadius.vertical(top: Radius.circular(11))
                      : BorderRadius.circular(11),
                  border: hasPostContent 
                      ? const Border(bottom: BorderSide(color: AppColors.textAndOutlines, width: 1))
                      : null,
                ),
                child: Text(
                  className,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (hasPostContent)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    latestPost,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
