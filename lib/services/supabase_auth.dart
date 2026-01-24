import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  static late final SupabaseClient supabase;

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: ".env");

      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (url == null || anonKey == null) {
        throw Exception(
            "SUPABASE_URL or SUPABASE_ANON_KEY not found in .env file");
      }

      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );

      supabase = Supabase.instance.client;
     debugPrint("Supabase initialized successfully!");
    } catch (e) {
     debugPrint("Supabase initialization failed: $e");
      rethrow; 
    }
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signUp(email: email, password: password);
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
        email: email, password: password);
  }

  // ✅ Logout function
  static Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      debugPrint("User signed out successfully!");
    } catch (e) {
      debugPrint("Sign out failed: $e");
      rethrow;
    }
  }
}
