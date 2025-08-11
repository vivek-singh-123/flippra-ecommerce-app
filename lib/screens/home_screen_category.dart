import 'package:flippra/backend/getcategory/getcategory.dart' hide Getcategory;
import 'package:flippra/backend/getslider/getslider.dart';
import 'package:flippra/backend/getslider/slidermodel.dart';
import 'package:flippra/backend/getlocation/getlocation.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../backend/getcategory/ShowProductCategory.dart';
import '../backend/getcategory/categoryModel.dart';
import '../backend/getlocation/locationmodel.dart';
import '../utils/shared_prefs_helper.dart';
import 'get_otp_screen.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreenCategoryScreen extends StatefulWidget {
  const HomeScreenCategoryScreen({super.key});

  @override
  State<HomeScreenCategoryScreen> createState() =>
      _HomeScreenCategoryScreenState();
}

class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedLanguage = 'English';
  bool _isToggleRight = true;
  bool _isSettingsActive = true;
  bool _isSearching = false;
  late Future<List<ProductCategoryModel>> _category;
  late Future<List<SliderModel>> _slider;
  LocationModel? location;

  final GlobalKey _languageIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey();

  // Microphone functionality ke liye naye variables
  final TextEditingController _searchController = TextEditingController();
  late SpeechRecognition _speech;
  bool _isListening = false;

  // Naya aur behtar animation effect
  late AnimationController _animationController;
  late Animation<double> _animation;

  void _initSpeechRecognizer() {
    _speech = SpeechRecognition();

    _speech.setAvailabilityHandler((bool result) {
      if (!result) {
        print("Speech recognition not available.");
      }
    });

    _speech.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
      });
      _animationController.repeat(reverse: true);
      print('✅ Listening started. _isListening is now: $_isListening');
    });

    _speech.setRecognitionResultHandler((String recognizedText) {
      _searchController.text = recognizedText;
    });

    // Jab mic sunna band kare
    _speech.setRecognitionCompleteHandler((String recognizedText) {
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
      print('❌ Listening complete. _isListening is now: $_isListening');
    });

    // Yeh naya handler add kiya hai
    _speech.setErrorHandler(() {
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
      print(
          '⚠️ Speech recognition error occurred. _isListening is now: $_isListening');
    });
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.microphone.request();
      return result.isGranted;
    }
  }

  void _startListening() async {
    bool hasPermission = await _requestPermission();
    if (hasPermission) {
      _speech.activate('en_US').then((_) {
        _speech.listen();
      });
    } else {
      print("Microphone permission denied.");
    }
  }

  void _stopListening() {
    _speech.stop();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected bottom nav item: $index');
    if (index == 0) {
      _showSettingsDialog(context);
    }
  }

  void _showLanguageSelection(BuildContext context) {
    print('Attempting to show language selection dialog...');

    final RenderBox? renderBox =
    _languageIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      print('ERROR: Language icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double dialogContentWidth = 150.0;
    const double dialogContentHeight = 56.0;

    double dialogLeft = offset.dx + size.width - dialogContentWidth;

    const double horizontalPadding = 8.0;

    if (dialogLeft < horizontalPadding) {
      dialogLeft = horizontalPadding;
    }
    if (dialogLeft + dialogContentWidth > screenWidth - horizontalPadding) {
      dialogLeft = screenWidth - dialogContentWidth - horizontalPadding;
    }

    double dialogTop = offset.dy + size.height + 8.0;

    const double bottomNavHeight = 100.0;
    if (dialogTop + dialogContentHeight > screenHeight - bottomNavHeight) {
      dialogTop = offset.dy - dialogContentHeight - 8.0;
      if (dialogTop < MediaQuery.of(context).padding.top + 8.0) {
        dialogTop = MediaQuery.of(context).padding.top + 8.0;
      }
    }

    String optionLanguage;
    Widget optionDisplayWidget;

    if (_selectedLanguage == 'English') {
      optionLanguage = 'Hindi';
      optionDisplayWidget = const Text(
        'अ',
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      optionLanguage = 'English';
      optionDisplayWidget = Image.asset(
        'assets/icons/english.png',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          print('ERROR: Dialog Image.asset failed to load english.png: $error');
          return const Icon(Icons.error, color: Colors.red, size: 24);
        },
      );
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: Offset(dialogLeft, dialogTop),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: dialogContentWidth,
                height: dialogContentHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: optionDisplayWidget,
                      title: Text(optionLanguage),
                      onTap: () {
                        setState(() {
                          _selectedLanguage = optionLanguage;
                        });
                        Navigator.pop(context);
                        print('Language set to $_selectedLanguage');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final RenderBox? renderBox =
    _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print('ERROR: Product icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    const double dialogContentWidth = 60.0;
    const double dialogContentHeight = 60.0;
    const double padding = 8.0;

    double dialogTop = offset.dy - dialogContentHeight;
    if (dialogTop < MediaQuery.of(context).padding.top + padding) {
      dialogTop = MediaQuery.of(context).padding.top + padding;
    }

    double dialogLeft = offset.dx + (size.width / 2) - (dialogContentWidth / 2);
    if (dialogLeft < padding) {
      dialogLeft = padding;
    } else if (dialogLeft + dialogContentWidth > screenWidth - padding) {
      dialogLeft = screenWidth - dialogContentWidth - padding;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.1),
              body: Stack(
                children: [
                  Positioned(
                    top: dialogTop,
                    left: dialogLeft,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                          parent: animation, curve: Curves.easeOutBack),
                      child: Material(
                        color: Colors.white,
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          onTap: () {
                            // This setState is crucial for updating the main widget
                            setState(() {
                              _isSettingsActive =
                              !_isSettingsActive; // Toggle the state
                              _category = Getcategory.getcategorydetails(
                                  _isSettingsActive ? 'Service' : 'Product');
                            });
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: dialogContentWidth,
                            height: dialogContentHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _isSettingsActive
                                      ? 'assets/icons/service.png'
                                      : 'assets/icons/product.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isSettingsActive ? 'Service' : 'Product',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildDialogOption(
      BuildContext context, String iconPath, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 40,
        height: 40,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error, size: 40, color: Colors.red),
      ),
      onTap: onTap,
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    await SharedPrefsHelper.clearUserData();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const GetOtpScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _toggleVideoIconPosition() {
    setState(() {
      _isToggleRight = !_isToggleRight;
    });
    print('Video icon toggled to: ${_isToggleRight ? "Right" : "Left"}');
  }

  @override
  void initState() {
    super.initState();
    _category = Getcategory.getcategorydetails(
        _isSettingsActive ? 'Service' : 'Product');
    _slider = GetSlider.getslider();
    fetchLocation();
    _initSpeechRecognizer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchLocation() async {
    LocationModel loc = await LocationFetchApi.getAddressFromLatLng();
    setState(() {
      location = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductCategoryModel>>(
        future: _category,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No categories available"));
          }

          final category = snapshot.data!;

          return Stack(
            children: [
              Column(
                children: [
                  Header(location ??
                      LocationModel(main: "Loading...", detail: "", landmark: "")),

                  // Search Bar Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/man.png',
                              width: 34,
                              height: 34,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: [
                                if (!_isSearching)
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.search, color: Colors.grey),
                                  ),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (text) {
                                      setState(() {
                                        _isSearching = text.isNotEmpty;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _isListening ? _stopListening() : _startListening();
                                  },
                                  child: ScaleTransition(
                                    scale: _animation,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.mic,
                                        color: _isListening ? Colors.blue : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.filter_list,
                                          color: Colors.grey, size: 18),
                                      SizedBox(width: 4),
                                      Text('Filters',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12)),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: Colors.grey, size: 18),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          key: _languageIconKey,
                          onTap: () {
                            _showLanguageSelection(context);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF00B3A7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: _selectedLanguage == 'English'
                                  ? Image.asset('assets/icons/english.png',
                                  width: 24, height: 24)
                                  : const Text(
                                'अ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slider
                  FutureBuilder<List<SliderModel>>(
                    future: _slider,
                    builder: (context, sliderSnapshot) {
                      if (sliderSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (sliderSnapshot.hasError) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: Text("Failed to load banners")),
                        );
                      } else if (!sliderSnapshot.hasData ||
                          sliderSnapshot.data!.isEmpty) {
                        return const SizedBox(
                          height: 160,
                          child: Center(child: Text("No banners available")),
                        );
                      }

                      final sliderItems = sliderSnapshot.data!;
                      return _buildSliderCard(context, sliderItems);
                    },
                  ),

                  // Category Grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          final item = category[index];
                          return _buildCategoryCard(context, item);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),

              // Bottom Category Navigation
              Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        _buildBottomNavIcon(
                          iconPath: 'assets/icons/shopping.png',
                          label: 'Dell',
                          index: 0,
                          onTap: () => _loadCategory("1"),
                        ),
                        const SizedBox(width: 20),
                        _buildBottomNavIcon(
                          iconPath: 'assets/icons/shopping.png',
                          label: 'HP',
                          index: 1,
                          onTap: () => _loadCategory("2"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Fixed Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00B3A7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset('assets/icons/profile_placeholder.png',
                          width: 50, height: 50),
                      GestureDetector(
                        onTap: _toggleVideoIconPosition,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset('assets/icons/toggle.png',
                                width: 90, height: 60),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              top: 0,
                              left: _isToggleRight ? null : 0,
                              right: _isToggleRight ? 0 : null,
                              child: Image.asset('assets/icons/video_icon.png',
                                  width: 50, height: 63),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Box icon tapped');
                        },
                        child: Image.asset('assets/icons/box.png',
                            width: 50, height: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget Header(LocationModel location) {
    Future<void> openWhatsApp() async {
      // This will just open WhatsApp app (no specific chat)
      final Uri whatsappUrl = Uri.parse("https://wa.me/");

      if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not open WhatsApp');
      }
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B3A7),
            Color(0xFF008D80),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            location.main,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.detail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // WhatsApp Icon
              GestureDetector(
                onTap: openWhatsApp,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/icons/whatsapp.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard(BuildContext context, List<SliderModel> sliderItems) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: sliderItems.length,
        itemBuilder: (context, index) {
          final item = sliderItems[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(item.images),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, ProductCategoryModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF00B3A7), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  item.categoryImg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.categoryName,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavIcon({
    Key? key, // Added Key parameter
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final Color borderColor = (_selectedIndex == index && index == 0)
        ? Colors.green // Green border for selected Settings icon
        : const Color(
        0xFF00B3A7); // Original teal for others or unselected Settings

    return GestureDetector(
      key: key, // Assign the key here
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor, // Use the dynamic border color
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 30,
                height: 30,
                // No 'color' property here, as per your original code and the desire for no other changes,
                // assuming your 'settings.png' is already black.
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
