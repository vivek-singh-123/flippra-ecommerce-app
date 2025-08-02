import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller with your asset path
    _controller = VideoPlayerController.asset('assets/videos/world_map.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown and the video is playing
        setState(() {});
        _controller.play();
        _controller.setLooping(true); // Loop the video
      });
  }

  @override
  void dispose() {
    // Dispose of the controller when the state is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Video background
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(color: Colors.black),

          // Dark overlay to make text more readable
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Content on top of the video
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or image (replace with your own logo asset)
                // Assuming you have an image asset in assets/images/logo.png
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.handshake, // Placeholder icon
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Door shope',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 150),

                // Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the get_otp_screen
                      Navigator.of(context).pushNamed('/get_otp');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.green, width: 2),
                    ),
                    child: Text(
                      'Login | App',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                // Create Account Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the gender_confirm_screen
                      Navigator.of(context).pushNamed('/gender_confirm');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Create | account',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Welcome Text
                Text(
                  'Welcome | App',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
