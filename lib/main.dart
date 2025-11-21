import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'bootstrap/boot.dart';

/// Main entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  String envContent = await rootBundle.loadString('.env');
  Map<String, String> envVars = {};

  for (String line in envContent.split('\n')) {
    line = line.trim();
    // Skip comments and empty lines
    if (line.isEmpty || line.startsWith('#')) continue;

    // Parse KEY=VALUE
    int separatorIndex = line.indexOf('=');
    if (separatorIndex != -1) {
      String key = line.substring(0, separatorIndex).trim();
      String value = line.substring(separatorIndex + 1).trim();
      envVars[key] = value;
    }
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: envVars['SUPABASE_URL'] ?? '',
      anonKey: envVars['SUPABASE_ANON_KEY'] ?? '',
    );
    print('✅ Supabase initialized successfully');
  } catch (e) {
    print('⚠️ Supabase initialization error: $e');
    print('⚠️ Please configure .env file with your Supabase credentials');
  }

  // Initialize Nylo
  await Nylo.init(
    setup: Boot.nylo,
    setupFinished: Boot.finished,
  );
}
