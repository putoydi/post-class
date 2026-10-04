import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/auth_screen.dart';
import 'screens/postboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mmyhdmrizlfozhcnjpee.supabase.co',
    publishableKey: 'sb_publishable_Xf5oPpZjAjjt5UUWPFPgUQ_60e0H46i',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post-Class',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Supabase.instance.client.auth.currentSession == null
          ? const AuthScreen()
          : const PostboardScreen(),
    );
  }
}
