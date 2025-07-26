import 'package:flutter/material.dart';
import 'package:flippra/screens/gender_confirm_screen.dart'; // Import the GenderConfirmScreen

class EnterOtpScreen extends StatefulWidget {
  final String phoneNumber; // To display the number OTP was sent to

  const EnterOtpScreen({super.key, required this.phoneNumber});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  // Controllers for each OTP digit input
  final TextEditingController _otpDigit1Controller = TextEditingController();
  final TextEditingController _otpDigit2Controller = TextEditingController();
  final TextEditingController _otpDigit3Controller = TextEditingController();
  final TextEditingController _otpDigit4Controller = TextEditingController();

  // Focus nodes to move focus between OTP input fields
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

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
    super.dispose();
  }

  void _verifyOtp() {
    // Combine OTP digits (optional, but good for logging)
    final String enteredOtp = _otpDigit1Controller.text +
        _otpDigit2Controller.text +
        _otpDigit3Controller.text +
        _otpDigit4Controller.text;

    print('OTP entered: $enteredOtp for ${widget.phoneNumber}');
    // Removed OTP authentication. Any input will now navigate.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP accepted. Navigating...')),
    );
    // Navigate to the GenderConfirmScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GenderConfirmScreen()),
    );
  }

  // Helper function to create an OTP digit input field
  Widget _otpDigitField(TextEditingController controller, FocusNode currentFocusNode, FocusNode? nextFocusNode) {
    return SizedBox(
      width: 60, // Width for each digit box
      height: 60, // Height for each digit box
      child: TextField(
        controller: controller,
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        maxLength: 1, // Only one digit per field
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        decoration: InputDecoration(
          counterText: "", // Hide the character counter
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero, // Remove default padding
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            nextFocusNode.requestFocus(); // Move focus to next field
          } else if (value.isEmpty && currentFocusNode != _focusNode1) {
            // If deleting and not the first field, move focus back
            currentFocusNode.previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main white background (implied by the phone frame)
          Container(color: Colors.white),

          // Teal background section
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
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

          // Content (OTP input fields and buttons)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Adjust position
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
                children: [
                  Text(
                    'Enter OTP',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space evenly
                    children: [
                      _otpDigitField(_otpDigit1Controller, _focusNode1, _focusNode2),
                      _otpDigitField(_otpDigit2Controller, _focusNode2, _focusNode3),
                      _otpDigitField(_otpDigit3Controller, _focusNode3, _focusNode4),
                      _otpDigitField(_otpDigit4Controller, _focusNode4, null), // Last field has no next focus
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft, // Align "Resend OTP" to the left
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
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent, // Light blue color for button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        'Verify',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18, color: Colors.white),
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
