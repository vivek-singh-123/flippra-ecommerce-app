// main.dart
import 'package:flippra/screens/home_screen_category.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // No longer needed here

// Screens
import 'package:flippra/screens/splashscreen.dart';
import 'package:flippra/screens/get_otp_screen.dart';
import 'package:flippra/screens/gender_confirm_screen.dart';
import 'package:flippra/screens/sign_up_screen.dart';
import 'package:flippra/screens/home_screen.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:flippra/screens/shop2_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flippra E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const SplashScreen(), // ⭐ FIX: Directly use SplashScreen as home
      routes: {
        // '/splash': (context) => const SplashScreen(), // No longer needed as home is SplashScreen
        '/get_otp': (context) => const GetOtpScreen(),
        '/gender_confirm': (context) => const GenderConfirmScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/shop_screen': (context) => const ShopScreen(),
        '/shop2_screen': (context) => const Shop2Screen(),
        '/homecategory': (context) => const HomeScreenCategoryScreen(),
      },
    );
  }
}

