import 'package:elavo/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:elavo/services/supabase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before using Supabase
  await dotenv.load(fileName: ".env");

  try {
    await SupabaseAuth.initialize();
    runApp(const MyApp());
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

// Show friendly error if Supabase fails
class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Initialization Error")),
        body: Center(
          child: Text(
            "App failed to start:\n$error",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
