import 'package:flutter/material.dart';
import 'package:flippra/screens/home_screen.dart'; // Import your HomeScreen
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../backend/update/update.dart'; // <--- Import your UpdateUser controller

class SignUpScreen extends StatefulWidget {
  final String? gender;
  const SignUpScreen({super.key, this.gender});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedCity; // To store the selected city

  // List of cities for the dropdown, you can expand this
  final List<String> _cities = ['Delhi', 'Mumbai', 'Bangalore', 'Chennai', 'Kolkata'];

  // GetX controller instance
  final UpdateUser _userController = Get.put(UpdateUser());

  // Focus nodes for the input fields
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  // State variable to control the floating animation
  bool _isKeyboardVisible = false;

  // Method to check if all fields are valid for enabling the button
  bool get _isFormValid =>
      _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _selectedCity != null;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller
    _videoController = VideoPlayerController.asset('assets/videos/Login_final.mp4')
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on SignUpScreen: $error");
      });

    // Add listeners to focus nodes to update keyboard visibility state
    _firstNameFocus.addListener(_onFocusChange);
    _lastNameFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);

    // Add listeners to update state for button enable/disable
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _firstNameFocus.hasFocus || _lastNameFocus.hasFocus || _emailFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // Basic validation
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Please fill all fields and select a city.')),
      );
      return;
    }

    print('First Name: ${_firstNameController.text}');
    print('Last Name: ${_lastNameController.text}');
    print('Email ID: ${_emailController.text}');
    print('City: $_selectedCity');

    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registering...')),
    );

    // Call the registerUser method from the controller
    await _userController.updateuser(
      token: "wvnwivnoweifnqinqfinefnq",
      // Replace with your actual token
      firstname: _firstNameController.text,
      lastname: _lastNameController.text,
      Gender: "", // Assuming gender is handled elsewhere
      Email: _emailController.text,
      City: _selectedCity!,
      // Non-nullable after validation
      phone: "7700818003", // Pass the phone number from the controller
    );

    // Hide loading indicator
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // Navigate to the HomeScreen after successful sign-up
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  // Helper widget for text input fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required FocusNode focusNode, // Added FocusNode parameter
    TextInputType keyboardType = TextInputType.text,
    int? maxLength, // Added maxLength parameter
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
            focusNode: focusNode, // Apply FocusNode
            keyboardType: keyboardType,
            maxLength: maxLength, // Apply maxLength
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              counterText: "", // Hide the default maxLength counter
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Adjusted the top position calculation
    final formContentHeight = 450.0; // Approximate height of the form section
    final animatedTop = keyboardHeight > 0
        ? screenHeight - keyboardHeight - formContentHeight
        : screenHeight * 0.3;

    return Scaffold(
      backgroundColor: Colors.transparent, // Set Scaffold background to transparent
      resizeToAvoidBottomInset: false, // Prevents the screen from resizing
      body: Stack(
        children: [
          // Video background section for the top part
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.52, // Video covers top 52%
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

          // Teal background container for the form, with floating animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: animatedTop, // Dynamic top position
            left: 0,
            right: 0,
            bottom: _isKeyboardVisible ? 0 : -20,
            child: Container(
              height: formContentHeight,
              decoration: const BoxDecoration(
                color: Colors.teal, // Teal color as per screenshot
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0), // Rounded top-left corner
                  topRight: Radius.circular(50.0), // Rounded top-right corner
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: SingleChildScrollView(
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
                      const SizedBox(height: 20), // Space below title

                      // First Name and Last Name
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _firstNameController,
                              labelText: 'First Name',
                              hintText: 'First Name',
                              focusNode: _firstNameFocus,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildTextField(
                              controller: _lastNameController,
                              labelText: 'Last Name',
                              hintText: 'Last Name',
                              focusNode: _lastNameFocus,
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
                        focusNode: _emailFocus,
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
                            style: const TextStyle(color: Colors.black, fontSize: 16),
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
                          onPressed: _isFormValid ? _signUp : null, // Disable if any field is empty
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            disabledBackgroundColor: Colors.orange.shade200,
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
            ),
          ),
        ],
      ),
    );
  }
}
