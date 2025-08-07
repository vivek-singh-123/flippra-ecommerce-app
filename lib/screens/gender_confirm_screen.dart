import 'package:flippra/backend/update/update.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/sign_up_screen.dart'; // Import your SignUpScreen
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import '../utils/shared_prefs_helper.dart';

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

  Future<void> _updateuser(BuildContext context, String gender) async {
    final UpdateUser controller = Get.put(UpdateUser());
    final Phone = await SharedPrefsHelper.getPhoneNumber() ?? '';

    try {
      await controller.updateuser(
        token: "wvnwivnoweifnqinqfinefnq",
        firstname:"",
        lastname: "",
        Gender: gender,
        Email:"",
        City: "",
        phone: Phone,
      );
      print("Successfully Register");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
      controller.isLoading.value = false;
    } catch (e) {
      print('❌ Registeration Failed: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  // New method to handle gender selection and direct navigation
  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    _updateuser(context, gender);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final _isKeyboardVisible = viewInsets > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ✅ Full-screen video background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.8,
            child: Container(
              color: Colors.white,
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
                  : const SizedBox(),
            ),
          ),

          // ✅ Animated Gender container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: _isKeyboardVisible ? screenHeight * 0.3 : screenHeight * 0.45,
            left: 0,
            right: 0,
            bottom: _isKeyboardVisible ? 0 : -20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Gender',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _genderSelectionCard(
                          context,
                          'Male',
                          'assets/icons/man.png',
                          _selectedGender == 'Male',
                        ),
                        _genderSelectionCard(
                          context,
                          'Female',
                          'assets/icons/woman.png',
                          _selectedGender == 'Female',
                        ),
                      ],
                    ),
                  ],
                ),
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