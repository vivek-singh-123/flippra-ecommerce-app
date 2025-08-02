import 'package:flutter/material.dart';
import 'package:flippra/screens/home_screen_category.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'Hindi'; // State to manage selected language, default Hindi
  late VideoPlayerController _videoController;
  bool _isMuted = false;
  bool _isVideoPlaying = true; // State to toggle video playing
  bool _isToggleRight = false; // State to track the position of the toggle switch

  // Main background image
  final String _mainBackgroundImage = 'assets/icons/home_bg.jpg';
  // Video path
  final String _homeVideoPath = 'assets/videos/home_screen_video.mp4';


  @override
  void initState() {
    super.initState();
    // Initially set the toggle position based on the default language
    _isToggleRight = _selectedLanguage == 'English';

    _videoController = VideoPlayerController.asset(_homeVideoPath)
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on HomeScreen: $error");
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _toggleLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      _isToggleRight = language == 'English';
      _isMuted = false; // Unmute when language is toggled
      if (_isVideoPlaying) {
        _videoController.play();
      }
    });
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
      if (_isVideoPlaying) {
        _videoController.play();
      } else {
        _videoController.pause();
      }
    });
  }

  void _onVideoToggleTapped() {
    setState(() {
      _isToggleRight = !_isToggleRight;
      _selectedLanguage = _isToggleRight ? 'English' : 'Hindi';
      _toggleVideoPlayback();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background - either video or static image
          _isVideoPlaying && _videoController.value.isInitialized
              ? Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
              : Positioned.fill(
            child: Image.asset(
              _mainBackgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          // Mute/Unmute Speaker Button
          Positioned(
            bottom: 200, // Adjusted position to be above the new bottom bar
            right: 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _videoController.setVolume(_isMuted ? 0.0 : 1.0);
                  print(_isMuted ? 'Muted' : 'Unmuted');
                });
              },
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),


          // Next Button at Bottom Right
          Positioned(
            top: 50,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreenCategoryScreen()),
                );
                print('Next button tapped, navigating to HomeScreenCategoryScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Skip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Custom Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF00B3A7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hindi Language Button
                  GestureDetector(
                    onTap: () => _toggleLanguage('Hindi'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: _selectedLanguage == 'Hindi'
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        'assets/icons/hindi.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),

                  // Video Toggle Button
                  GestureDetector(
                    onTap: _onVideoToggleTapped,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/toggle.png',
                          width: 100,
                          height: 50,
                          fit: BoxFit.fill,
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          left: _isToggleRight ? 55 : 5,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                              ],
                            ),
                            child: Image.asset(
                              'assets/icons/video_icon.png',
                              width: 40,
                              height:40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // English Language Button
                  GestureDetector(
                    onTap: () => _toggleLanguage('English'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: _selectedLanguage == 'English'
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        'assets/icons/english.png',
                        width: 40,
                        height: 40,
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
