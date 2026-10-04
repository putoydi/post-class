import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  bool _isLoading = false;

  Future<void> _createClass() async {
    final className = _nameController.text.trim();

    if (className.isEmpty) {
      _showMessage('Please enter a class name.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await Supabase.instance.client.rpc(
        'create_class',
        params: {
          'p_class_name': className,
        },
      );

      if (!mounted) return;

      final classCode = result['class_code'];

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Class created! Class code: $classCode',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } on PostgrestException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage('Could not create class. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

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
          Text(
            'Create a class here',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(
            height: AppSpacing.gapBetweenSections,
          ),
          CustomInputField(
            hintText: 'Class Name',
            controller: _nameController,
          ),
          const SizedBox(
            height: AppSpacing.gapBetweenSections,
          ),
          PrimaryButton(
            label: _isLoading ? 'Creating...' : 'Create class',
            onPressed: _isLoading ? null : _createClass,
          ),
        ],
      ),
    );
  }
}