import 'package:flutter/material.dart';
import 'package:flippra/screens/enter_otp_screen.dart';
import 'package:video_player/video_player.dart';

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({super.key});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController _whatsappNoController = TextEditingController();
  bool _isWhatsappNumberValid = false; // To simulate validation checkmark

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with otp.mp4 for GetOtpScreen
    _videoController = VideoPlayerController.asset('assets/videos/Login_final.mp4') // <--- Using otp.mp4
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on GetOtpScreen: $error"); // Added screen name for clarity
      });
  }

  @override
  void dispose() {
    _whatsappNoController.dispose();
    _videoController.dispose(); // <--- CRITICAL: Dispose the video controller
    super.dispose();
  }

  void _sendOtp() {
    // Only proceed if the WhatsApp number is valid (10 digits)
    if (_isWhatsappNumberValid) {
      print('Sending OTP to: ${_whatsappNoController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent! Navigating to OTP entry screen...')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterOtpScreen(phoneNumber: _whatsappNoController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit WhatsApp number.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main white background (for video) - Increased height
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6, // Increased to 60% of screen
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
                  : const SizedBox(), // Show nothing if video not initialized yet
            ),
          ),

          // Teal background section (moved to the bottom)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Starts 30% from the top
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0), // Added vertical padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Whatsapp No. Input Field
                    TextField(
                      controller: _whatsappNoController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10, // <--- Limit input to 10 characters
                      decoration: InputDecoration(
                        hintText: 'Whatsapp No.',
                        counterText: "", // <--- Hides the default character counter
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icons/whatsapp.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        suffixIcon: _isWhatsappNumberValid // Show checkmark if valid
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Validate if the number is exactly 10 digits
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
                        onPressed: _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Get OTP',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18, color: Colors.white),
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