// --- lib/screens/welcome_screen.dart ---
import 'package:flutter/material.dart';
import 'package:flippra/screens/get_otp_screen.dart'; // Import the GetOtpScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar to ignore the top notch area.
      body: Container(
        // Set a background color for the entire screen.
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            // Spacer for the top padding, effectively pushing content down
            // and ignoring the status bar area.
            const Spacer(flex: 3), // Increased flex from 2 to 3 for more top space
            // Logo Placeholder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text( // Changed to simple Text widget for "LOGO"
                'LOGO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700], // Keeping blue color from the image
                  letterSpacing: 2,
                ),
              ),
            ),
            // Background Video Placeholder
            Expanded(
              flex: 1, // Adjusted flex from 3 to 1 to make it take less vertical space
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                // Removed decoration (color and borderRadius) as requested
                child: const Center(
                  child: Text(
                    'Background Video',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            // Spacers around buttons adjusted to help with centering
            const Spacer(flex: 1), // Spacer before buttons
            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: SizedBox(
                width: double.infinity, // Make button full width.
                height: 55, // Fixed height for the button.
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the GetOtpScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GetOtpScreen()),
                    );
                    print('Login button pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange background color.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners.
                    ),
                    elevation: 5, // Add a subtle shadow.
                  ),
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
                  ),
                ),
              ),
            ),
            // Register | New Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: SizedBox(
                width: double.infinity, // Make button full width.
                height: 55, // Fixed height for the button.
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement navigation to Register Screen
                    print('Register | New button pressed!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Light grey background color.
                    foregroundColor: Colors.black87, // Dark text color.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners.
                    ),
                    elevation: 5, // Add a subtle shadow.
                  ),
                  child: Text(
                    'Register | New',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1), // Spacer at the bottom.
          ],
        ),
      ),
    );
  }
}