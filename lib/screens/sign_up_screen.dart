import 'package:flutter/material.dart';
import 'package:flippra/screens/home_screen.dart'; // Import your HomeScreen
import 'package:video_player/video_player.dart'; // <--- Import video_player package

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late VideoPlayerController _videoController; // <--- Declare video controller
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCity; // To store the selected city

  // List of cities for the dropdown, you can expand this
  final List<String> _cities = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai', 'Kolkata'];

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with world_map.mp4
    _videoController = VideoPlayerController.asset('assets/videos/Login_final.mp4') // Corrected to world_map.mp4
      ..initialize().then((_) {
        // Ensure the first frame is shown and then play the video
        _videoController.play();
        _videoController.setLooping(true); // Loop the video continuously
        setState(() {}); // Update the UI once the video is initialized
      }).catchError((error) {
        // Log any errors during video initialization
        print("Error initializing video on SignUpScreen: $error"); // Added screen name for clarity
      });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _videoController.dispose(); // <--- CRITICAL: Dispose the video controller
    super.dispose();
  }

  void _signUp() {
    // Basic validation
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a city.')),
      );
      return;
    }

    // You can add more complex validation here (e.g., email format)

    print('First Name: ${_firstNameController.text}');
    print('Last Name: ${_lastNameController.text}');
    print('Email ID: ${_emailController.text}');
    print('City: $_selectedCity');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign Up Successful!')),
    );

    // Navigate to the HomeScreen after successful sign-up
    Navigator.pushReplacement( // Using pushReplacement to prevent going back to SignUpScreen
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()), // HomeScreen can be const if it doesn't have mutable state directly in its constructor
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set Scaffold background to transparent
      body: Stack(
        children: [
          // Video background section for the top part
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.52, // Video covers top 52%
            child: Container(
              color: Colors.black, // Fallback color if video not ready, or a placeholder
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
                  : const SizedBox.expand( // Expand to fill if video not initialized
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white), // Show loading indicator
                ),
              ),
            ),
          ),

          // Teal background container for the form, starting to overlap the video
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Starts 30% from top, overlaps video
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

          // Content (Sign Up title and form fields)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32, // Adjust to overlay the video and teal background
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensures title is visible on video/teal
                    ),
                  ),
                  const SizedBox(height: 30), // Space below title

                  // First Name and Last Name
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          labelText: 'First Name',
                          hintText: 'First Name',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          labelText: 'Last Name',
                          hintText: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email ID
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email ID',
                    hintText: 'Email ID',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // City Dropdown
                  Text(
                    'City',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCity,
                        hint: const Text('Select City'),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                        style: const TextStyle(color: Colors.black, fontSize: 16), // Dropdown text color
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue;
                          });
                        },
                        items: _cities.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: (_firstNameController.text.isNotEmpty &&
                          _lastNameController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _selectedCity != null)
                          ? _signUp
                          : null, // Disable if any field is empty
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        disabledBackgroundColor: Colors.orange.shade200, // 👈 Light orange when disabled
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
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

  // Helper widget for text input fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.black), // <--- This sets the entered text color to black
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]), // <--- Recommended: Make hint text a slightly lighter black/dark grey
              border: InputBorder.none, // Remove default border
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}