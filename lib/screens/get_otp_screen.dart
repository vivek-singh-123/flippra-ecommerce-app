import 'package:flutter/material.dart';
import 'package:flippra/screens/enter_otp_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  bool _isWhatsappNumberValid = false; // To simulate validation checkmark

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
  }

  @override
  void dispose() {
    _whatsappNoController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  // void _sendOtp() {
  //   if (_isWhatsappNumberValid) {
  //     print('Sending OTP to: ${_whatsappNoController.text}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('OTP sent! Navigating to OTP entry screen...')),
  //     );
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EnterOtpScreen(phoneNumber: _whatsappNoController.text),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter a valid 10-digit WhatsApp number.')),
  //     );
  //   }
  // }

  Future<void> _register(BuildContext context, String number) async {
    final Register controller = Get.put(Register());

    try {
      await controller.Regiter(
        token: "wvnwivnoweifnqinqfinefnq",
          firstname:"",
          lastname: "",
          Gender:"",
          Email:"",
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
    return Scaffold(
      body: Stack(
        children: [
          // Video background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
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

          // Bottom teal section
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // WhatsApp Number Field
                    TextField(
                      controller: _whatsappNoController,
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
                    // Get OTP Button (updated line here!)
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
