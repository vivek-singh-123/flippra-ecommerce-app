import 'package:flutter/material.dart';
import 'package:flippra/screens/enter_otp_screen.dart'; // Import the new OTP entry screen

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({super.key});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> {
  final TextEditingController _whatsappNoController = TextEditingController();
  bool _isWhatsappNumberValid = false; // To simulate validation checkmark

  @override
  void dispose() {
    _whatsappNoController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    // Implement OTP sending logic here.
    // This would typically involve an API call to your backend
    // to send an OTP to the provided phone number.
    print('Sending OTP to: ${_whatsappNoController.text}');
    setState(() {
      _isWhatsappNumberValid = true; // Assume valid after sending OTP attempt
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent! Navigating to OTP entry screen...')),
    );

    // Navigate to the new EnterOtpScreen after OTP is "sent"
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterOtpScreen(phoneNumber: _whatsappNoController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar to match the new design screenshot
      body: Stack( // Use Stack to layer the background and content
        children: [
          // Main white background (implied by the phone frame)
          Container(color: Colors.white),

          // Teal background section (the large curved rectangle)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Adjust position as needed
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal, // Teal color as per screenshot
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0), // Rounded top-left corner
                  topRight: Radius.circular(50.0), // Rounded top-right corner
                ),
              ),
            ),
          ),

          // Content (Whatsapp No. input and Get OTP button)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Adjust position to be on top of teal background
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0), // Horizontal padding for content
              child: Column(
                mainAxisSize: MainAxisSize.min, // Take minimum space vertically
                children: [
                  // Whatsapp No. Input Field
                  TextField(
                    controller: _whatsappNoController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Whatsapp No.',
                      // Using Image.asset to load your custom WhatsApp icon
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0), // Add some padding around the image
                        child: Image.asset(
                          'assets/icons/whatsapp.png',
                          width: 24, // Adjust size as needed
                          height: 24, // Adjust size as needed
                          // Removed color: Colors.green to display original image colors
                        ),
                      ),
                      suffixIcon: _isWhatsappNumberValid // Show checkmark if valid
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      filled: true,
                      fillColor: Colors.white, // White background for input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide.none, // No border line
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Simple validation for demonstration: check if number is not empty
                        _isWhatsappNumberValid = value.isNotEmpty;
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
                        backgroundColor: Colors.lightBlueAccent, // Light blue color for button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
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
        ],
      ),
    );
  }
}
