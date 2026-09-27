import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_input_field.dart';

class CreateClassModal extends StatefulWidget {
  const CreateClassModal({super.key});

  @override
  State<CreateClassModal> createState() => _CreateClassModalState();
}

class _CreateClassModalState extends State<CreateClassModal> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
          Text('Create a class here', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.gapBetweenSections),
          CustomInputField(hintText: 'Class Name', controller: _nameController),
          const SizedBox(height: AppSpacing.gapBetweenSections),
          PrimaryButton(
            label: 'Create class',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
