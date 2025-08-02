import 'package:flippra/backend/update/update.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/sign_up_screen.dart'; // Import your SignUpScreen
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart'; // <--- Import video_player package

class GenderConfirmScreen extends StatefulWidget {
  const GenderConfirmScreen({super.key});

  @override
  State<GenderConfirmScreen> createState() => _GenderConfirmScreenState();
}

class _GenderConfirmScreenState extends State<GenderConfirmScreen> {
  late VideoPlayerController _videoController; // <--- Declare video controller
  String? _selectedGender; // To store the selected gender: 'Male' or 'Female'

  // Focus node to detect when any gender card is selected
  final FocusNode _genderFocusNode = FocusNode();
  // State variable to control the floating animation
  bool _isFloating = false;

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

    // Add a listener to the focus node to trigger the floating animation
    _genderFocusNode.addListener(() {
      setState(() {
        _isFloating = _genderFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose(); // <--- CRITICAL: Dispose the video controller
    _genderFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updateuser(BuildContext context, String gender) async {
    final UpdateUser controller = Get.put(UpdateUser());

    try {
      await controller.updateuser(
        token: "wvnwivnoweifnqinqfinefnq",
        firstname:"",
        lastname: "",
        Gender: gender,
        Email:"",
        City: "",
        phone: "7700818003",
      );
      print("Successfully Registered Gender");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
      controller.isLoading.value = false;
    } catch (e) {
      print('❌ Gender registration failed: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  // New method to handle gender selection and direct navigation
  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    // This part will not actually animate as it navigates immediately,
    // but the state and logic are in place for more complex scenarios.
    _updateuser(context, gender);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Video background section
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

          // Animated bottom teal section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            // The top value will be constant since there's no keyboard to push it up
            top: _isFloating ? screenHeight * 0.3 : screenHeight * 0.55,
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

          // Content (Gender selection) with an animated position
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: _isFloating ? screenHeight * 0.45 : screenHeight * 0.6,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Gender',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
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
        ],
      ),
    );
  }

  // Helper widget for gender selection cards
  Widget _genderSelectionCard(
      BuildContext context,
      String gender,
      String imagePath,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        // When a gender is tapped, set the focus to trigger the animation
        FocusScope.of(context).requestFocus(_genderFocusNode);
        _onGenderSelected(gender);
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.6),
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.transparent,
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
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            gender,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
