import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_input_field.dart';

class JoinClassModal extends StatefulWidget {
  const JoinClassModal({super.key});

  @override
  State<JoinClassModal> createState() => _JoinClassModalState();
}

class _JoinClassModalState extends State<JoinClassModal> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter a code to join a class', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.gapBetweenSections),
          CustomInputField(hintText: 'Class Code', controller: _codeController),
          const SizedBox(height: AppSpacing.gapBetweenSections),
          PrimaryButton(
            label: 'Join class',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
