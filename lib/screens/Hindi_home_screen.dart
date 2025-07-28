import 'package:flutter/material.dart';
// सभी भाषा स्क्रीन को यहाँ इम्पोर्ट करें
import 'package:flippra/screens/bengali_home_screen.dart';
import 'package:flippra/screens/telugu_home_screen.dart';
import 'package:flippra/screens/tamil_home_screen.dart';
import 'package:flippra/screens/punjabi_home_screen.dart';
import 'package:flippra/screens/marathi_home_screen.dart';
import 'package:flippra/screens/home_screen_category.dart'; // Import HomeScreenCategoryScreen
// Assuming you might navigate to SignUpScreen from here later
// import 'package:flippra/screens/sign_up_screen.dart';

bool _isMuted = false; // Default is speaker on


class HindiHomeScreen extends StatefulWidget { // Class name changed
  const HindiHomeScreen({super.key}); // Constructor name changed

  @override
  State<HindiHomeScreen> createState() => _HindiHomeScreenState(); // State class name changed
}

class _HindiHomeScreenState extends State<HindiHomeScreen> { // State class name changed
  // Removed _isHindiSelected as it's no longer a toggle but a selection among many
  int _selectedIndex = 0; // For the bottom navigation bar

  // This is the path for the main background image of the screen.
  // It uses 'assets/icons/home_bg.jpg' as declared in your pubspec.yaml.
  final String _mainBackgroundImage = 'assets/icons/home_bg.jpg';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected bottom nav item: $index (Language: ${getLanguageName(index)})');

    // नेविगेशन लॉजिक
    switch (index) {
      case 0:
      // पहले से ही हिंदी स्क्रीन पर हैं, कोई नेविगेशन नहीं
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BengaliHomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeluguHomeScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TamilHomeScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PunjabiHomeScreen()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MarathiHomeScreen()),
        );
        break;
      default:
        break;
    }
  }

  String getLanguageName(int index) {
    switch (index) {
      case 0: return 'Hindi';
      case 1: return 'Bengali';
      case 2: return 'Telugu';
      case 3: return 'Tamil';
      case 4: return 'Punjabi';
      case 5: return 'Marathi';
      default: return '';
    }
  }

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

          // Bottom Navigation Bar (Custom implementation)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom, // Adjusted to account for safe area
            left: 0,
            right: 0,
            child: Container(
              height: 90, // Increased height of the navbar to provide more space for icons
              decoration: BoxDecoration(
                color: const Color(0xFF00B3A7), // Custom teal color from the image
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/hindi.png',
                      label: 'Hindi',
                      index: 0,
                      onTap: () => _onItemTapped(0),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/bengali.png',
                      label: 'Bengali',
                      index: 1,
                      onTap: () => _onItemTapped(1),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/telugu.png',
                      label: 'Telugu',
                      index: 2,
                      onTap: () => _onItemTapped(2),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/tamil.png',
                      label: 'Tamil',
                      index: 3,
                      onTap: () => _onItemTapped(3),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/punjabi.png',
                      label: 'Punjabi',
                      index: 4,
                      onTap: () => _onItemTapped(4),
                    ),
                  ),
                  Expanded(
                    child: _buildBottomNavItem(
                      iconPath: 'assets/icons/marathi.png',
                      label: 'Marathi',
                      index: 5,
                      onTap: () => _onItemTapped(5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate( // THIS IS THE NEW WIDGET WRAPPER
        offset: const Offset(0.0, -11.0), // Adjusted to move icons slightly less upwards to fix overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Aligns children to the top of the column to create overlap effect
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0), // Adjust horizontal padding as needed
              child: Container( // Added a Container to create the circular background for the icon
                width: 40, // Increased size of the circular background
                height: 40, // Increased size of the circular background
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Changed color based on selection: white if selected,
                  // a very light grey/transparent white if not selected for subtle tint.
                  color: _selectedIndex == index ? Colors.white : Colors.white.withOpacity(0.3), // Adjusted opacity for a subtle white tint
                  border: Border.all(
                    color: _selectedIndex == index ? Colors.white : Colors.transparent, // Highlight border is white if selected
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset( // Re-inserted Image.asset
                    iconPath,
                    width: 25, // Increased icon size
                    height: 25, // Increased icon size
                    // Changed icon color based on selection for better contrast
                    color: _selectedIndex == index ? Colors.black : Colors.black, // Selected and unselected icon color set to black
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 25, color: Colors.red);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 0), // Reduced space between icon and text
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                // Changed text color based on selection for better contrast
                color: _selectedIndex == index ? Colors.white : Colors.white70, // Selected text color is white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
