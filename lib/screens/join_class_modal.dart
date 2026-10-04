import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  bool _isLoading = false;

  Future<void> _joinClass() async {
    final classCode = _codeController.text.trim();

    if (classCode.isEmpty) {
      _showMessage('Please enter a class code.');
      return;
    }

    if (classCode.length != 6) {
      _showMessage('Class code must be 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await Supabase.instance.client.rpc(
        'join_class_by_code',
        params: {
          'p_code': classCode,
        },
      );

      if (!mounted) return;

      final className = result['class_name'];

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joined $className!'),
        ),
      );
    } on PostgrestException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage('Could not join class. Please try again.');
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
          Text(
            'Enter a code to join a class',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSpacing.gapBetweenSections,
          ),
          CustomInputField(
            hintText: 'Class Code',
            controller: _codeController,
          ),
          const SizedBox(
            height: AppSpacing.gapBetweenSections,
          ),
          PrimaryButton(
            label: _isLoading ? 'Joining...' : 'Join class',
            onPressed: _isLoading ? null : _joinClass,
          ),
        ],
      ),
    );
  }
}