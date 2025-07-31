import 'package:flutter/material.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreenCategoryScreen extends StatefulWidget {
  const HomeScreenCategoryScreen({super.key});

  @override
  State<HomeScreenCategoryScreen> createState() => _HomeScreenCategoryScreenState();
}

class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen> {
  // Geolocation variables
  String _currentAddress = "Fetching location...";
  Position? _currentPosition;

  // UI and state variables
  int _selectedIndex = 0; // For the bottom navigation bar
  String _selectedLanguage = 'English'; // To keep track of the selected language
  bool _isToggleRight = true; // Added for the video icon toggle position

  // GlobalKeys for UI elements
  final GlobalKey _languageIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Start fetching location on init
  }

  // --- Geolocation Methods ---
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      setState(() => _currentAddress = "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentAddress = "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() => _currentAddress = "Location permission permanently denied.");
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Request high accuracy
      );
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    } catch (e) {
      setState(() => _currentAddress = "Failed to get location: $e");
      print("Error getting current position: $e");
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (_currentPosition != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        Placemark place = placemarks[0];
        setState(() {
          // Construct a more detailed address string
          _currentAddress =
          "${place.name ?? ''}, ${place.thoroughfare ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}";
          // Clean up multiple commas if some parts are null
          _currentAddress = _currentAddress.replaceAll(RegExp(r', , '), ', ').replaceAll(RegExp(r'^, '), '');
        });
      } else {
        setState(() => _currentAddress = "Location data not available.");
      }
    } catch (e) {
      setState(() => _currentAddress = "Failed to get address: $e");
      print("Error getting address from coordinates: $e");
    }
  }
  // --- End Geolocation Methods ---


  // --- UI Interaction Methods ---
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected bottom nav item: $index');

    if (index == 0) { // If Settings icon is tapped
      _showSettingsDialog(context); // Call the settings dialog
    }
  }

  // Function to show language selection dialog (now positioned near the icon)
  void _showLanguageSelection(BuildContext context) {
    print('Attempting to show language selection dialog...');

    // Get the position and size of the language icon
    final RenderBox? renderBox = _languageIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      print('ERROR: Language icon RenderBox not found.');
      return; // Cannot show dialog without render box
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero); // Global position of the top-left corner of the icon
    final Size size = renderBox.size; // Size of the icon

    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Approximate width and height for the dialog content (single List Tile)
    const double dialogContentWidth = 150.0; // This should be enough for "Hindi" / "English" + icon
    const double dialogContentHeight = 56.0; // Approx default ListTile height

    // Calculate desired left position: Align the right edge of the dialog with the right edge of the icon.
    // So, dialog's left = icon's global right edge - dialog's width
    double dialogLeft = offset.dx + size.width - dialogContentWidth;

    // Add a small horizontal padding to keep it off the screen edge
    const double horizontalPadding = 8.0;

    // Adjust if it goes off the left edge
    if (dialogLeft < horizontalPadding) {
      dialogLeft = horizontalPadding;
    }
    // Adjust if it goes off the right edge (this logic is crucial for right-aligned items)
    // The dialog should not extend beyond screenWidth - horizontalPadding
    if (dialogLeft + dialogContentWidth > screenWidth - horizontalPadding) {
      dialogLeft = screenWidth - dialogContentWidth - horizontalPadding;
    }

    // Calculate desired top position: Slightly below the icon
    double dialogTop = offset.dy + size.height + 8.0; // 8.0 is a small margin below the icon

    // Adjust if it goes off the bottom edge (considering the bottom navigation bar)
    const double bottomNavHeight = 100.0; // Estimate space occupied by bottom nav bar
    if (dialogTop + dialogContentHeight > screenHeight - bottomNavHeight) {
      // If it overflows at the bottom, try to place it above the icon
      dialogTop = offset.dy - dialogContentHeight - 8.0; // 8.0 is a small margin above the icon
      // Fallback: if placing above still overflows (e.g., at top of screen),
      // just ensure it doesn't go off the very top.
      if (dialogTop < MediaQuery.of(context).padding.top + 8.0) {
        dialogTop = MediaQuery.of(context).padding.top + 8.0;
      }
    }

    // Determine the language option to show in the dialog (the opposite of current)
    String optionLanguage;
    Widget optionDisplayWidget; // Can be Text or Image

    if (_selectedLanguage == 'English') {
      optionLanguage = 'Hindi';
      optionDisplayWidget = const Text(
        'अ',
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else { // Current language is Hindi
      optionLanguage = 'English';
      optionDisplayWidget = Image.asset(
        'assets/icons/english.png', // Assuming you have an English icon
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
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: Offset(dialogLeft, dialogTop), // Use dialogLeft and dialogTop directly
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox( // Use SizedBox with explicit dimensions for predictable layout
                width: dialogContentWidth,
                height: dialogContentHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: optionDisplayWidget, // Dynamically show 'अ' or English icon
                      title: Text(optionLanguage), // Display the name of the language to switch to
                      onTap: () {
                        setState(() {
                          _selectedLanguage = optionLanguage; // Toggle language
                        });
                        Navigator.pop(context); // Close the dialog
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
            alignment: Alignment.topRight, // Scale from the top-right for better visual
            child: child,
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    print('Attempting to show settings dialog...');

    final RenderBox? renderBox = _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print('ERROR: Settings icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double dialogContentWidth = 90.0;
    const double singleOptionHeight = 60.0;
    const int numberOfOptions = 3;
    final double dialogContentHeight = singleOptionHeight * numberOfOptions;

    double dialogTop = offset.dy - dialogContentHeight;
    const double padding = 8.0;

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
                      scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                      child: Material(
                        color: Colors.white,
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(12.0),
                        child: SizedBox(
                          width: dialogContentWidth,
                          height: dialogContentHeight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildDialogOption(context, 'assets/icons/settings.png', () {
                                Navigator.pop(context);
                              }),
                              _buildDialogOption(context, 'assets/icons/settings.png', () {
                                print('Theme tapped');
                                Navigator.pop(context);
                              }),
                              _buildDialogOption(context, 'assets/icons/settings.png', () {
                                print('About tapped');
                                Navigator.pop(context);
                              }),
                            ],
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

  Widget _buildDialogOption(BuildContext context, String iconPath, VoidCallback onTap) {
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


  // Function to toggle the video icon position
  void _toggleVideoIconPosition() {
    setState(() {
      _isToggleRight = !_isToggleRight; // Toggle the boolean value
    });
    print('Video icon toggled to: ${_isToggleRight ? "Right" : "Left"}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top Bar (Location, WhatsApp) - Now with custom drawn background
              Container(
                height: 105.0,
                decoration: const BoxDecoration(
                  // We'll use a LinearGradient to simulate the top_frame.png
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // You might need to adjust these colors to match your top_frame.png
                    colors: [
                      Color(0xFF00B3A7), // Start color (e.g., a teal/greenish color)
                      Color(0xFF008D80), // End color (a slightly darker shade of the start color)
                    ],
                  ),
                  // Optional: if your top_frame had specific rounded corners or borders, add them here
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35), // Adjust if your image had curves
                    bottomRight: Radius.circular(35), // Adjust if your image had curves
                  ),
                ),
                child: SafeArea( // Ensuring content respects safe area
                  child: Padding(
                    // Adjusted top padding for safe area and general alignment
                    padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start of the cross axis
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Go back
                          },
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Ensure text content is aligned nicely within the available height
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                                    Expanded(
                                      child: Text(
                                        _currentAddress, // Display fetched address here
                                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // === WhatsApp Icon Added Here ===
                        GestureDetector(
                          onTap: () {
                            print('WhatsApp icon tapped!');
                            // TODO: Add logic to open WhatsApp or related action
                          },
                          child: Image.asset(
                            'assets/icons/whatsapp.png', // WhatsApp icon path
                            width: 30, // Adjust size as needed
                            height: 30, // Adjust size as needed
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red, size: 30);
                            },
                          ),
                        ),
                        // ================================
                      ],
                    ),
                  ),
                ),
              ),

              // Search Bar Row (Includes the language toggle icon)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    // New: Toggle and Man Images
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/toggle.png',
                          width: 75,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.purple, size: 60);
                          },
                        ),
                        Positioned(
                          top: 11,
                          left: 42,
                          child: Image.asset(
                            'assets/icons/man.png',
                            width: 34,
                            height: 34,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.purple, size: 34);
                            },
                          ),
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
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.mic, color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.filter_list, color: Colors.grey, size: 18),
                                  SizedBox(width: 4),
                                  Text('Filters', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // === THIS IS THE LANGUAGE TOGGLE ICON ===
                    GestureDetector(
                      key: _languageIconKey, // Assign the GlobalKey here
                      onTap: () {
                        print('Language toggle icon tapped! Attempting to show language selection dialog.');
                        _showLanguageSelection(context); // Call the language selection dialog on tap
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00B3A7), // Teal color
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
                              ? Image.asset( // Show English icon if current language is English
                            'assets/icons/english.png', // Make sure this path is correct
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red, size: 24);
                            },
                          )
                              : const Text( // Show 'अ' if current language is Hindi
                            'अ',
                            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Banner Image
              Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(0),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/banner_placeholder.png'), // Replace with your banner image
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'TECHNOLOGIES',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Grid of Cards
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return _buildDoctorCard(context);
                    }
                    return _buildPlaceholderCard(context);
                  },
                ),
              ),

              const SizedBox(height: 150),
            ],
          ),

          // Upper Bottom Navigation Bar
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavIcon(
                    key: _settingsIconKey, // Assign GlobalKey to Settings icon
                    iconPath: 'assets/icons/settings.png',
                    label: 'Settings',
                    index: 0,
                    onTap: () => _onItemTapped(0),
                  ),
                  _buildBottomNavIcon(
                    iconPath: 'assets/icons/person.png',
                    label: 'Person',
                    index: 1,
                    onTap: () => _onItemTapped(1),
                  ),
                  _buildBottomNavIcon(
                    iconPath: 'assets/icons/shopping.png',
                    label: 'Shopping',
                    index: 2,
                    onTap: () => _onItemTapped(2),
                  ),
                  _buildBottomNavIcon(
                    iconPath: 'assets/icons/cart.png',
                    label: 'Cart',
                    index: 3,
                    onTap: () => _onItemTapped(3),
                  ),
                  _buildBottomNavIcon(
                    iconPath: 'assets/icons/gallery.png',
                    label: 'Gallery',
                    index: 4,
                    onTap: () => _onItemTapped(4),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Play Button and User Icon (Overlaying the bottom nav bar)
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // User Icon
                  Image.asset(
                    'assets/icons/profile_placeholder.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red, size: 50);
                    },
                  ),
                  // Toggle Icon with Video Icon - NOW CLICKABLE AND ANIMATED
                  GestureDetector(
                    onTap: _toggleVideoIconPosition, // Call the new toggle function
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/toggle.png',
                          width: 90,
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red, size: 60);
                          },
                        ),
                        AnimatedPositioned( // Use AnimatedPositioned for smooth transition
                          duration: const Duration(milliseconds: 300), // Animation duration
                          curve: Curves.easeInOut, // Smooth animation curve
                          top: 0,
                          // Adjust left/right based on _isToggleRight
                          left: _isToggleRight ? null : 0, // When false, stick to left
                          right: _isToggleRight ? 0 : null, // When true, stick to right
                          child: Image.asset(
                            'assets/icons/video_icon.png',
                            width: 50,
                            height: 63,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.videocam, color: Colors.red, size: 20);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Box Icon (New addition)
                  GestureDetector(
                    onTap: () {
                      print('Box icon tapped');
                      // TODO: Implement box functionality
                    },
                    child: Image.asset(
                      'assets/icons/box.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red, size: 50);
                      },
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

  // Helper widget for placeholder cards
  Widget _buildPlaceholderCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Placeholder card tapped, navigating to ShopScreen');
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
      ),
    );
  }

  // Helper widget for the Doctor card
  Widget _buildDoctorCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Doctor card tapped, navigating to ShopScreen');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 2),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/doctor_placeholder.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            const Text(
              'Doctor | 20',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for bottom navigation icons
  Widget _buildBottomNavIcon({
    Key? key, // Added Key parameter
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final Color borderColor = (_selectedIndex == index && index == 0)
        ? Colors.green // Green border for selected Settings icon
        : const Color(0xFF00B3A7); // Original teal for others or unselected Settings

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
                // No 'color' property here, as pe  r your original code and the desire for no other changes,
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
