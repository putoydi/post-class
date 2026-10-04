import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/sticky_banner.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/primary_button.dart';
import 'postboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginView = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _authenticate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter your email and password.');
      return;
    }

    if (!isLoginView && (firstName.isEmpty || lastName.isEmpty)) {
      _showMessage('Please enter your first and last name.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLoginView) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        final response =
            await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: {
            'first_name': firstName,
            'last_name': lastName,
            'display_name': '$firstName $lastName',
          },
        );

        if (response.session == null) {
          if (!mounted) return;

          _showMessage(
            'Account created! Please check your email to confirm your account.',
          );

          setState(() {
            isLoginView = true;
          });

          return;
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PostboardScreen(),
        ),
      );
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (error) {
      _showMessage('Something went wrong. Please try again.');
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
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const StickyBanner(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Post-Class',
                style: textTheme.headlineSmall?.copyWith(fontSize: 48),
              ),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenEdgePadding,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.authContainer,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: AppColors.textAndOutlines,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          isLoginView ? 'Welcome!' : 'Sign Up',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.gapBetweenSections,
                      ),

                      if (!isLoginView) ...[
                        CustomInputField(
                          hintText: 'First Name',
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        CustomInputField(
                          hintText: 'Last Name',
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      CustomInputField(
                        hintText: 'Email Address',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      CustomInputField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isObscure: true,
                        prefixIcon: Icons.lock_outline,
                      ),

                      const SizedBox(
                        height: AppSpacing.gapBetweenSections,
                      ),

                      Center(
                        child: PrimaryButton(
                          label: _isLoading
                              ? 'Please wait...'
                              : isLoginView
                                  ? 'Login'
                                  : 'Sign Up',
                          onPressed:
                              _isLoading ? null : _authenticate,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              isLoginView
                                  ? "Don't have an account?"
                                  : 'Already have an account?',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textAndOutlines,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginView = !isLoginView;
                                });
                              },
                              child: Text(
                                isLoginView
                                    ? 'Sign up!'
                                    : 'Log in!',
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.hyperlinkedText,
                                  decoration:
                                      TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}