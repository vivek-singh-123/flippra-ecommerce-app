import 'package:flutter/material.dart';
import 'package:flippra/screens/enter_otp_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        print("Error initializing video on GetOtpScreen: $error");
      });
  }

  @override
  void dispose() {
    _whatsappNoController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  _register(BuildContext context, String number) async {
    final Register controller = Get.put(Register());

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userPhone', number);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnterOtpScreen(phoneNumber: number),
        ),
      );
      controller.isLoading.value = false;
    } catch (e) {
      print('❌ Registration Failed: $e');
    }
    finally {
      controller.isLoading.value = false;
    }
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
          // Video background inside Stack
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

          // Animated bottom container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: _isKeyboardVisible ? screenHeight * 0.31 : screenHeight * 0.55,
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isWhatsappNumberValid
                          ? () => _register(context, _whatsappNoController.text)
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
        ],
      ),
    );
  }
}