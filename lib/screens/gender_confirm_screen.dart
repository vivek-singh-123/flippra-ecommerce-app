import 'package:flutter/material.dart';
import 'package:flippra/screens/sign_up_screen.dart'; // Import your SignUpScreen

class GenderConfirmScreen extends StatefulWidget {
  const GenderConfirmScreen({super.key});

  @override
  State<GenderConfirmScreen> createState() => _GenderConfirmScreenState();
}

class _GenderConfirmScreenState extends State<GenderConfirmScreen> {
  String? _selectedGender; // To store the selected gender: 'Male' or 'Female'

  void _confirmGender() {
    if (_selectedGender != null) {
      print('Selected Gender: $_selectedGender');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gender selected: $_selectedGender')),
      );
      // Navigate to the SignUpScreen after gender is confirmed
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()), // Removed 'const' here
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main white background (implied by the phone frame)
          Container(color: Colors.white),

          // Teal background section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4, // Adjust position as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.teal, // Teal color as per screenshot
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0), // Rounded top-left corner
                  topRight: Radius.circular(50.0), // Rounded top-right corner
                ),
              ),
            ),
          ),

          // Content (Gender selection and Confirm button)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, // Adjust position to be on top of teal background
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gender Selection Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _genderSelectionCard(
                        context,
                        'Male',
                        'assets/icons/man.png', // Custom icon for male
                        _selectedGender == 'Male',
                      ),
                      _genderSelectionCard(
                        context,
                        'Female',
                        'assets/icons/woman.png', // Custom icon for female
                        _selectedGender == 'Female',
                      ),
                    ],
                  ),
                  const SizedBox(height: 50), // Space between cards and button
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _confirmGender,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Orange color for button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Confirm',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18, color: Colors.white),
                      ),
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

  // Helper widget for gender selection cards
  Widget _genderSelectionCard(
      BuildContext context,
      String gender,
      String imagePath, // Changed from IconData to String for image path
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Column(
        children: [
          Container(
            width: 120, // Size of the circular avatar
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.6), // Background color
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.transparent, // Highlight border if selected
                width: 3,
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
              child: Image.asset( // Changed from Icon to Image.asset
                imagePath,
                fit: BoxFit.contain, // Ensures the image scales within the bounds without cropping
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            gender,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white, // Text color for gender
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
