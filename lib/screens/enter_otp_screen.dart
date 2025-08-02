import 'package:flutter/material.dart';
import 'package:flippra/screens/gender_confirm_screen.dart';
import 'package:video_player/video_player.dart';

class EnterOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const EnterOtpScreen({super.key, required this.phoneNumber});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  late VideoPlayerController _videoController;

  final TextEditingController _otpDigit1Controller = TextEditingController();
  final TextEditingController _otpDigit2Controller = TextEditingController();
  final TextEditingController _otpDigit3Controller = TextEditingController();
  final TextEditingController _otpDigit4Controller = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  // State variable to control the floating animation
  bool _isKeyboardVisible = false;

  bool get _isOtpValid =>
      _otpDigit1Controller.text.length == 1 &&
          _otpDigit2Controller.text.length == 1 &&
          _otpDigit3Controller.text.length == 1 &&
          _otpDigit4Controller.text.length == 1;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/otp.mp4')
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on EnterOtpScreen: $error");
      });

    // Add listeners to update state on OTP changes
    _otpDigit1Controller.addListener(_onOtpChanged);
    _otpDigit2Controller.addListener(_onOtpChanged);
    _otpDigit3Controller.addListener(_onOtpChanged);
    _otpDigit4Controller.addListener(_onOtpChanged);

    // Listen to focus changes on the first OTP field to trigger the animation
    _focusNode1.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode1.hasFocus;
      });
    });
  }

  void _onOtpChanged() {
    setState(() {}); // Refresh button enable state
  }

  @override
  void dispose() {
    _otpDigit1Controller.dispose();
    _otpDigit2Controller.dispose();
    _otpDigit3Controller.dispose();
    _otpDigit4Controller.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    final String enteredOtp = _otpDigit1Controller.text +
        _otpDigit2Controller.text +
        _otpDigit3Controller.text +
        _otpDigit4Controller.text;

    print('OTP entered: $enteredOtp for ${widget.phoneNumber}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP accepted. Navigating...')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GenderConfirmScreen()),
    );
  }

  Widget _otpDigitField(TextEditingController controller, FocusNode currentFocusNode, FocusNode? nextFocusNode) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          } else if (value.isEmpty && currentFocusNode != _focusNode1) {
            currentFocusNode.previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Adjusted the top position calculation
    final containerHeight = 250.0; // Approximate height of the teal container
    final animatedTop = keyboardHeight > 0
        ? screenHeight - keyboardHeight - containerHeight
        : screenHeight * 0.55;

    return Scaffold(
      // Prevents the screen from resizing when the keyboard appears
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: screenHeight * 0.64,
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
            // Adjust top based on whether the keyboard is visible
            top: animatedTop,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enter OTP',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _otpDigitField(_otpDigit1Controller, _focusNode1, _focusNode2),
                        _otpDigitField(_otpDigit2Controller, _focusNode2, _focusNode3),
                        _otpDigitField(_otpDigit3Controller, _focusNode3, _focusNode4),
                        _otpDigitField(_otpDigit4Controller, _focusNode4, null),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          print('Resending OTP to: ${widget.phoneNumber}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resending OTP...')),
                          );
                        },
                        child: Text(
                          'Resend OTP',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isOtpValid ? _verifyOtp : null, // ✅ Disabled when incomplete
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          disabledBackgroundColor: Colors.orange.shade200, // ✅ Light orange when disabled
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Verify',
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
