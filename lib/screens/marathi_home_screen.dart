import 'package:flutter/material.dart';
// सभी भाषा स्क्रीन को यहाँ इम्पोर्ट करें
import 'package:flippra/screens/hindi_home_screen.dart';
import 'package:flippra/screens/bengali_home_screen.dart';
import 'package:flippra/screens/telugu_home_screen.dart';
import 'package:flippra/screens/tamil_home_screen.dart';
import 'package:flippra/screens/punjabi_home_screen.dart';
// import 'package:flippra/screens/marathi_home_screen.dart'; // यह वर्तमान स्क्रीन है
// Assuming you might navigate to SignUpScreen from here later
// import 'package:flippra/screens/sign_up_screen.dart';

class MarathiHomeScreen extends StatefulWidget { // क्लास का नाम बदला गया
  const MarathiHomeScreen({super.key});

  @override
  State<MarathiHomeScreen> createState() => _MarathiHomeScreenState(); // स्टेट क्लास का नाम बदला गया
}

class _MarathiHomeScreenState extends State<MarathiHomeScreen> { // स्टेट क्लास का नाम बदला गया
  int _selectedIndex = 5; // मराठी के लिए इंडेक्स 5 है

  final String _mainBackgroundImage = 'assets/icons/home_bg.jpg';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected bottom nav item: $index (Language: ${getLanguageName(index)})');

    // नेविगेशन लॉजिक
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HindiHomeScreen()),
        );
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
      // पहले से ही मराठी स्क्रीन पर हैं, कोई नेविगेशन नहीं
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
                print('Speaker icon tapped');
              },
              child: Image.asset(
                'assets/icons/volume.png',
                color: Colors.white,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.volume_up, size: 40, color: Colors.white);
                },
              ),
            ),
          ),

          // Next Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                print('Next button tapped');
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Bottom Navigation Bar (Custom implementation)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF00B3A7),
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
      child: Transform.translate(
        offset: const Offset(0.0, -11.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedIndex == index ? Colors.white : Colors.white.withOpacity(0.3),
                  border: Border.all(
                    color: _selectedIndex == index ? Colors.white : Colors.transparent,
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
                  child: Image.asset(
                    iconPath,
                    width: 25,
                    height: 25,
                    color: _selectedIndex == index ? Colors.black : Colors.black,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 25, color: Colors.red);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: _selectedIndex == index ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
