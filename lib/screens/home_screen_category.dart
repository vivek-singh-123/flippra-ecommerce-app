import 'package:flippra/backend/getcategory/getcategory.dart';
import 'package:flippra/backend/getslider/getslider.dart';
import 'package:flippra/backend/getslider/slidermodel.dart';
import 'package:flippra/backend/getlocation/getlocation.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../backend/getcategory/categoryModel.dart';
import '../backend/getlocation/locationmodel.dart';
import '../utils/shared_prefs_helper.dart';
import 'get_otp_screen.dart';


class HomeScreenCategoryScreen extends StatefulWidget {
  const HomeScreenCategoryScreen({super.key});

  @override
  State<HomeScreenCategoryScreen> createState() => _HomeScreenCategoryScreenState();
}

class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen> {
  int _selectedIndex = 0; // For the bottom navigation bar
  String _selectedLanguage = 'English'; // To keep track of the selected language
  bool _isToggleRight = true; // Added for the video icon toggle position
  late Future<List<CategoryModel>> _category;
  late Future<List<SliderModel>> _slider;
  LocationModel? location;

  final GlobalKey _languageIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey(); //

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Selected bottom nav item: $index');
    if (index == 0) { // If Settings icon is tapped
      _showSettingsDialog(context); // Call the new settings dialog
    }
  }

  void _showLanguageSelection(BuildContext context) {
    print('Attempting to show language selection dialog...');

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
    bool isServiceSelected = true; // Initial state

    final RenderBox? renderBox = _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print('ERROR: Settings icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    const double dialogContentWidth = 90.0;
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
          return StatefulBuilder(
            builder: (context, setState) {
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isServiceSelected = !isServiceSelected;
                                });
                              },
                              child: SizedBox(
                                width: dialogContentWidth,
                                height: dialogContentHeight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/service.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isServiceSelected ? 'Service' : 'Settings',
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

  Future<void> logoutUser(BuildContext context) async {
    await SharedPrefsHelper.clearUserData(); // Clear shared preferences

    // Navigate to GetOtpScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const GetOtpScreen()),
          (Route<dynamic> route) => false,
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
  void initState() {
    super.initState();
    _category = Getcategory.getcategorydetails();
    _slider = GetSlider.getslider();
    fetchLocation();
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
        body: FutureBuilder<List<CategoryModel>>(
            future: _category,
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No tournaments available"));
              }
              final category = snapshot.data!;

              return Stack(
                children: [
                  Column(
                    children: [
                      Header(location ??
                          LocationModel(main: "Loading...", detail: "", landmark: "")),
                      // Search Bar Row (Includes the language toggle icon)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Row(
                          children: [
                            // New: Toggle and Man Images
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/man.png',
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error, color: Colors.purple, size: 34);
                                  },
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.filter_list, color: Colors.grey,
                                              size: 18),
                                          SizedBox(width: 4),
                                          Text('Filters', style: TextStyle(
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
                              key: _languageIconKey, // Assign the GlobalKey here
                              onTap: () {
                                print(
                                    'Language toggle icon tapped! Attempting to show language selection dialog.');
                                _showLanguageSelection(
                                    context); // Call the language selection dialog on tap
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
                                      ? Image
                                      .asset( // Show English icon if current language is English
                                    'assets/icons/english.png',
                                    // Make sure this path is correct
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.error, color: Colors.red, size: 24);
                                    },
                                  )
                                      : const Text( // Show 'अ' if current language is Hindi
                                    'अ',
                                    style: TextStyle(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Banner Image
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
                          } else if (!sliderSnapshot.hasData || sliderSnapshot.data!.isEmpty) {
                            return const SizedBox(
                              height: 160,
                              child: Center(child: Text("No banners available")),
                            );
                          }

                          final sliderItems = sliderSnapshot.data!;
                          return _buildSliderCard(context, sliderItems);
                        },
                      ),


                      // Grid of Cards
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          )
                      ),

                      const SizedBox(height: 150),
                    ],
                  ),

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
                            key: _settingsIconKey,
                            iconPath: 'assets/icons/settings.png',
                            label: 'Settings',
                            index: 0,
                            onTap: () => _showSettingsDialog(context),
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
                              return const Icon(
                                  Icons.error, color: Colors.red, size: 50);
                            },
                          ),
                          // Toggle Icon with Video Icon - NOW CLICKABLE AND ANIMATED
                          GestureDetector(
                            onTap: _toggleVideoIconPosition,
                            // Call the new toggle function
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/toggle.png',
                                  width: 90,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                        Icons.error, color: Colors.red, size: 60);
                                  },
                                ),
                                AnimatedPositioned( // Use AnimatedPositioned for smooth transition
                                  duration: const Duration(milliseconds: 300),
                                  // Animation duration
                                  curve: Curves.easeInOut,
                                  // Smooth animation curve
                                  top: 0,
                                  // Adjust left/right based on _isToggleRight
                                  left: _isToggleRight ? null : 0,
                                  // When false, stick to left
                                  right: _isToggleRight ? 0 : null,
                                  // When true, stick to right
                                  child: Image.asset(
                                    'assets/icons/video_icon.png',
                                    width: 50,
                                    height: 63,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.videocam, color: Colors.red, size: 20);
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
                                return const Icon(
                                    Icons.error, color: Colors.red, size: 50);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
        )
    );
  }

  Widget Header(LocationModel location) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          location.main,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                    ),
                    Text(
                      location.landmark,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Assuming `context` is available here
                  // logoutUser(context);
                },
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
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

  Widget _buildCategoryCard(BuildContext context, CategoryModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        );
      },
      child:Container(
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  item.categoryImg,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.categoryName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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