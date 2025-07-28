import 'package:flutter/material.dart';
import 'package:flippra/screens/sign_up_screen.dart'; // Import your SignUpScreen
import 'package:video_player/video_player.dart'; // <--- Import video_player package

class GenderConfirmScreen extends StatefulWidget {
  const GenderConfirmScreen({super.key});

  @override
  State<GenderConfirmScreen> createState() => _GenderConfirmScreenState();
}

class _GenderConfirmScreenState extends State<GenderConfirmScreen> {
  late VideoPlayerController _videoController; // <--- Declare video controller
  String? _selectedGender; // To store the selected gender: 'Male' or 'Female'

  // Removed _confirmGender method as navigation will happen on tap

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with Login_final.mp4 for GenderConfirmScreen
    _videoController = VideoPlayerController.asset('assets/videos/Login_final.mp4') // <--- Use Login_final.mp4
      ..initialize().then((_) {
        // Ensure the first frame is shown and then play the video
        _videoController.play();
        _videoController.setLooping(true); // Loop the video continuously
        setState(() {}); // Update the UI once the video is initialized
      }).catchError((error) {
        // Log any errors during video initialization
        print("Error initializing video on GenderConfirmScreen: $error"); // Added screen name for clarity
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // <--- CRITICAL: Dispose the video controller
    super.dispose();
  }

  // New method to handle gender selection and direct navigation
  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    print('Selected Gender: $gender. Navigating to Sign Up Screen...');
    // Navigate to the SignUpScreen immediately after gender is selected
    // Using pushReplacement to prevent going back to GenderConfirmScreen from SignUpScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video background section (replaces the main white background)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.8, // <--- Increased height for video
            child: Container(
              color: Colors.white, // Fallback color if video not ready
              child: _videoController.value.isInitialized
                  ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              )
                  : const SizedBox(), // Show nothing if video not initialized yet
            ),
          ),

          // Teal background section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4, // <--- Starts 40% from the top
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

          // Content (Gender selection)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45, // <--- Adjust position to be on top of teal background
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Gender', // Added a title for clarity
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 30), // Space below title
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
                  // The Confirm Button is removed from here
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
      // Changed onTap to call the new _onGenderSelected method
      onTap: () => _onGenderSelected(gender),
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