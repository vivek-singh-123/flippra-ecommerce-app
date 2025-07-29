// --- lib/main.dart ---
import 'package:flutter/material.dart';
// Corrected import path to match your pubspec.yaml project name 'flippra'
import 'package:flippra/screens/get_otp_screen.dart';
import 'package:flippra/screens/gender_confirm_screen.dart';
import 'package:flippra/screens/sign_up_screen.dart';
import 'package:flippra/screens/home_screen.dart'; // Updated import to HindiHomeScreen
import 'package:flippra/screens/shop_screen.dart';
import 'package:flippra/screens/shop2_screen.dart'; // New: Import shop2_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flippra E-commerce',
      // Set this to false to remove the red debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the primary color for the app.
        primarySwatch: Colors.deepPurple,
        // Apply rounded corners to all card-like elements.
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
        ),
        // Apply rounded corners to buttons.
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        // Define text styles for the app's typography.
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.0,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0,
            color: Colors.black54,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        // Define the app bar theme with a gradient background.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple, // Fallback color
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Define the floating action button theme.
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        // Define the input decoration theme for text fields.
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          hintStyle: TextStyle(color: Colors.deepPurple.withOpacity(0.6)),
        ),
      ),
      // Define named routes for all your screens
      initialRoute: '/get_otp', // Set the initial route for the app
      routes: {
        '/get_otp': (context) => GetOtpScreen(), // Removed const
        '/gender_confirm': (context) => GenderConfirmScreen(), // Removed const
        '/sign_up': (context) => SignUpScreen(), // Removed const
        '/home': (context) => HomeScreen(), // Updated route to HindiHomeScreen
        '/shop_screen': (context) => const ShopScreen(),
        '/shop2_screen': (context) => const Shop2Screen(), // New: Added route for Shop2Screen
      },
    );
  }
}
