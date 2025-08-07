import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import '../backend/getvideo/getvideo.dart';
import '../backend/getaudio/getaudio.dart';
import 'home_screen_category.dart';
import 'get_otp_screen.dart';
import '../utils/shared_prefs_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GetVideo _getVideoController = Get.put(GetVideo());
  final GetAudio _getAudioController = Get.put(GetAudio());

  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _selectedLanguage = 'Hindi';
  bool _isMuted = false;
  bool _isLoading = true;
  bool _isToggleRight = false; // For toggle animation

  String? _videoUrl;
  String? _audioUrlHindi;
  String? _audioUrlEnglish;

  final String _mainBackgroundImage = 'assets/icons/home_bg.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isToggleRight = _selectedLanguage == 'English';
    _fetchData();
  }

  /// Fetch video and audio URLs from API
  Future<void> _fetchData() async {
    const String token = "wvnwivnoweifnqinqfinefnq";

    try {
      // ✅ Fetch video (only once, does not change on toggle)
      final videoData = await _getVideoController.getvideo(token: token);
      if (videoData.isNotEmpty) {
        String videoFileName = videoData[0]['Intro'];
        _videoUrl = "https://flippraa.anklegaming.live/Videos/$videoFileName";
      }

      // ✅ Fetch Hindi audio
      final audioDataHindi =
      await _getAudioController.getaudio(token: token, langauge: 'hindi');
      if (audioDataHindi.isNotEmpty) {
        _audioUrlHindi =
        "https://flippraa.anklegaming.live/audios/${audioDataHindi[0]['audio']}";
      }

      // ✅ Fetch English audio
      final audioDataEnglish =
      await _getAudioController.getaudio(token: token, langauge: 'english');
      if (audioDataEnglish.isNotEmpty) {
        _audioUrlEnglish =
        "https://flippraa.anklegaming.live/audios/${audioDataEnglish[0]['audio']}";
      }

      if (_videoUrl != null) {
        _videoController = VideoPlayerController.network(_videoUrl!)
          ..initialize().then((_) {
            // ⭐ FIX: We've added a check here
            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });

            _videoController.setLooping(true);
            _videoController.setVolume(0.0); // mute video audio
            _videoController.play().then((_) {
              // ⭐ FIX: Play audio ONLY AFTER video starts playing
              _playAudio();
            });
          }).catchError((error) {
            print("Error initializing video: $error");
            if (!mounted) return;
            setState(() {
              _isLoading = false;
            });
          });
      } else {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Play audio based on current selected language
  Future<void> _playAudio() async {
    // ⭐ FIX: We'll stop and release the player to avoid resource leaks
    await _audioPlayer.stop();
    await _audioPlayer.release();

    String? audioUrlToPlay =
    _selectedLanguage == 'Hindi' ? _audioUrlHindi : _audioUrlEnglish;

    if (audioUrlToPlay != null) {
      await _audioPlayer.play(UrlSource(audioUrlToPlay));
    } else {
      print("⚠ No audio URL found for $_selectedLanguage");
    }
  }

  /// Toggle Language using the Switch
  void _onVideoToggleTapped() {
    setState(() {
      _isToggleRight = !_isToggleRight;
      _selectedLanguage = _isToggleRight ? 'English' : 'Hindi';
      _isMuted = false; // unmute when language changes
    });
    _audioPlayer.setVolume(1.0);
    _playAudio(); // Play the selected language audio
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // ⭐ FIX: Add a check for isInitialized before disposing
    if (mounted && _videoController.value.isInitialized) {
      _videoController.dispose();
    }
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _pauseMedia() {
    // ⭐ FIX: Add checks to ensure the controllers are initialized before pausing
    if (mounted && _videoController.value.isInitialized) {
      _videoController.pause();
    }
    _audioPlayer.pause();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // ⭐ FIX: Add checks
      if (mounted && _videoController.value.isInitialized) {
        _videoController.pause();
      }
      _audioPlayer.pause();
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    await SharedPrefsHelper.clearUserData();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const GetOtpScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background: Video if available, else static image
          // ⭐ FIX: Check if the video controller is initialized before using it
          if (_isLoading)
          // ⭐ FIX: Show a loading indicator while loading
            Positioned.fill(
              child: Container(
                color: Colors.black, // A dark background for the loading indicator
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            _videoController.value.isInitialized
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
          // Your other UI widgets here...
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                _pauseMedia();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreenCategoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              child: const Text('Skip',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            bottom: 200,
            right: 30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
                });
              },
              child: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
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
                  GestureDetector(
                    onTap: _onVideoToggleTapped,
                    child: Container(
                      width: 100,
                      height: 50,
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
                            top: 5,
                            child: Container(
                              width: 45,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/video_icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

  /// Additional helper for Hindi/English direct tap (optional)
  void _toggleLanguage(String language) {
    if (_selectedLanguage == language) return;
    setState(() {
      _selectedLanguage = language;
      _isToggleRight = language == 'English';
      _isMuted = false;
    });
    _audioPlayer.setVolume(1.0);
    _playAudio();
  }
}