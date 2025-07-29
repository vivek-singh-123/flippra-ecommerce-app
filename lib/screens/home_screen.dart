import 'package:flutter/material.dart';
import 'package:flippra/screens/home_screen_category.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'Hindi'; // State to manage selected language, default Hindi
  bool _isMuted = false; // Moved _isMuted into the state class

  final String _mainBackgroundImage = 'assets/icons/home_bg.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Background Image (using home_bg.jpg)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_mainBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Language Selection Icon at Top Right (now triggers a PopupMenuButton)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20, // Adjust top padding
            right: 20,
            child: PopupMenuButton<String>(
              initialValue: _selectedLanguage,
              onSelected: (String result) {
                setState(() {
                  _selectedLanguage = result;
                  print('Selected language: $result');
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Hindi',
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/hindi.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.language, size: 24, color: Colors.black);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text('Hindi'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'English',
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/english.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.language, size: 24, color: Colors.black);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text('English'),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00B3A7), // Teal color from your image
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    _selectedLanguage == 'Hindi' ? 'अ' : 'EN', // Display 'अ' for Hindi, 'EN' for English
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Speaker/Volume Icon - Repositioned just above the Next button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2 + 70,
            right: 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMuted = !_isMuted;
                  print(_isMuted ? 'Muted' : 'Unmuted');
                });
              },
              child: Image.asset(
                _isMuted
                    ? 'assets/icons/mute.png' // 👈 Add a mute icon in your assets folder
                    : 'assets/icons/volume.png',
                color: Colors.white,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    size: 40,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),

          // Next Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2, // Adjust position above bottom nav
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to HomeScreenCategoryScreen when Next button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreenCategoryScreen()),
                );
                print('Next button tapped, navigating to HomeScreenCategoryScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3), // Changed to semi-transparent black
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Increased border radius
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjusted padding
                elevation: 0, // Removed shadow
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjusted font size
              ),
            ),
          ),
        ],
      ),
    );
  }
}
