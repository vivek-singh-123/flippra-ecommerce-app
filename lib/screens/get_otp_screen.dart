import 'package:flutter/material.dart';
import 'package:flippra/screens/enter_otp_screen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../backend/register/register.dart';

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({super.key});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController _whatsappNoController = TextEditingController();
  bool _isWhatsappNumberValid = false;

  // Controller to handle the animation for the bottom section
  final FocusNode _phoneFocusNode = FocusNode();

  // Variable to track if the keyboard is open
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with Login_final.mp4 for GetOtpScreen
    _videoController = VideoPlayerController.asset('assets/videos/Login_final.mp4')
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on GetOtpScreen: $error");
      });

    // Listen to focus changes on the text field
    _phoneFocusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _phoneFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _whatsappNoController.dispose();
    _videoController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context, String number) async {
    final Register controller = Get.put(Register());

    try {
      await controller.Regiter(
        token: "wvnwivnoweifnqinqfinefnq",
        firstname: "",
        lastname: "",
        Gender: "",
        Email: "",
        City: "",
        phone: number,
      );
      print("Successfully Register");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterOtpScreen(phoneNumber: _whatsappNoController.text),
        ),
      );
      controller.isLoading.value = false;
    } catch (e) {
      print('❌ Registeration Failed: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents screen from resizing with keyboard
      body: Stack(
        children: [
          // Video background
          Positioned(
            top: 0,
            left: 0,
            right: 0, // Changed from 20 to 0 to fill the width
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

          // Animated bottom section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300), // Adjust animation speed
            curve: Curves.easeOut,
              top: _isKeyboardVisible ? screenHeight * 0.35 : screenHeight * 0.55,
            left: 0,
            right: 0,
            bottom: _isKeyboardVisible ? 0 : -20, // Adjust bottom to hide on animation start
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // WhatsApp Number Field
                    TextField(
                      controller: _whatsappNoController,
                      focusNode: _phoneFocusNode, // Assign the focus node
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: 'Whatsapp No.',
                        hintStyle: const TextStyle(color: Colors.black),
                        counterText: "",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icons/whatsapp.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        suffixIcon: _isWhatsappNumberValid
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isWhatsappNumberValid = value.length == 10;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // Get OTP Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isWhatsappNumberValid // Only enable if number is valid
                            ? () => _register(context, _whatsappNoController.text) // Pass the text from the controller
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
                          'Get OTP',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
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
}
