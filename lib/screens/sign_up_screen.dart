import 'package:flutter/material.dart';
import 'package:flippra/screens/home_screen.dart'; // Import your HomeScreen
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../backend/update/update.dart';
import '../utils/shared_prefs_helper.dart';

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
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // Basic validation
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedCity == null
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
            'Please fill all fields and select a city/phone number.')),
      );
      return;
    }

    print('First Name: ${_firstNameController.text}');
    print('Last Name: ${_lastNameController.text}');
    print('Email ID: ${_emailController.text}');
    print('City: $_selectedCity');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registering...')),
    );
    final Phone = await SharedPrefsHelper.getPhoneNumber() ?? '';
    await _userController.updateuser(
      token: "wvnwivnoweifnqinqfinefnq",
      firstname: _firstNameController.text,
      lastname: _lastNameController.text,
      Gender: "",
      Email: _emailController.text,
      City: _selectedCity!,
      phone: Phone,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView( // Wrap the entire Stack with SingleChildScrollView
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Set the height of the scrollable content
          child: Stack(
            children: [
              // Video background section
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.52,
                child: Container(
                  color: Colors.black,
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
                      : const SizedBox.expand(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // Teal background container for the form
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                ),
              ),

              // Content (Sign Up title and form fields)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.32,
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
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

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
                          onPressed: (_firstNameController.text.isNotEmpty &&
                              _lastNameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _selectedCity != null)
                              ? _signUp
                              : null,
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
                      // Add some extra space at the bottom to ensure the last text field is not covered
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for text input fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
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
            maxLength: maxLength,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}