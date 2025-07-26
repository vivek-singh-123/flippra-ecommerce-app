import 'package:flutter/material.dart';
import 'package:flippra/screens/shop_screen.dart'; // ShopScreen को इम्पोर्ट करें

class HomeScreenCategoryScreen extends StatefulWidget { // Class name changed
  const HomeScreenCategoryScreen({super.key});

  @override
  State<HomeScreenCategoryScreen> createState() => _HomeScreenCategoryScreenState(); // State class name changed
}

class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen> { // State class name changed
  int _selectedIndex = 0; // For the bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implement navigation or action based on selected bottom nav item
    print('Selected bottom nav item: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Scaffold body को Stack में बदला गया है ताकि Positioned children की अनुमति मिल सके
          children: [
      Column( // यह Column अब मुख्य कंटेंट को रखता है जो लंबवत (vertically) फ्लो होता है
      children: [
      // Top Bar (Location, Search, Filters, WhatsApp) - यह हिस्सा अनछुआ है
      Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: const Color(0xFF00B3A7), // Teal color from image
      child: SafeArea( // SafeArea अभी भी अंदर है ताकि स्टेटस बार को हैंडल कर सके
        child: Column(
          children: [
            // Top Row: Back, Location, WhatsApp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white, size: 20),
                            SizedBox(width: 4),
                            Text(
                              'Delhi - 6',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                          ],
                        ),
                        Text(
                          'Near Azad Market, Pahadi Dheeraj',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          'Near Axis Bank',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Space between video icon and WhatsApp icon
                Image.asset(
                  'assets/icons/whatsapp.png', // WhatsApp icon
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Search Bar Row
            Row(
              children: [
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Made circular
                    color: const Color(0xFF00B3A7), // Set to Teal color
                    boxShadow: [ // Added shadow
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'अ', // Hindi character for filters
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold), // Text color changed to black
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),

    // Banner Image
    Container(
    width: double.infinity,
    height: 100, // Adjust height as needed
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
    color: Colors.grey[300], // Placeholder color
    borderRadius: BorderRadius.circular(10),
    image: const DecorationImage(
    image: AssetImage('assets/icons/banner_placeholder.png'), // Replace with your banner image
    fit: BoxFit.cover,
    ),
    ),
    child: const Center(
    child: Text(
    'TECHNOLOGIES', // Placeholder text for the banner
    style: TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),

    // Grid of Cards (using Expanded to take remaining space)
    Expanded(
    child: GridView.builder(
    padding: const EdgeInsets.all(16.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3, // 3 cards per row
    crossAxisSpacing: 16.0,
    mainAxisSpacing: 16.0,
    childAspectRatio: 0.8, // Adjust as needed for card height
    ),
    itemCount: 15, // Total number of cards, including the doctor card
    itemBuilder: (context, index) {
    if (index == 9) { // Assuming the doctor card is at this position (0-indexed)
    return _buildDoctorCard(context); // Pass context
    }
    return _buildPlaceholderCard(context); // Pass context
    },
    ),
    ),

    // Spacer to make room for the custom bottom bars
    // यह सुनिश्चित करने के लिए कि कंटेंट बॉटम नेविगेशन बार से ओवरलैप न हो,
    // इस स्पेस को दोनों बॉटम बार की कुल ऊँचाई के बराबर या उससे ज़्यादा रखें।
    const SizedBox(height: 150), // 80 (green bar) + 60 (play button bar overlap) + some padding
    ],
    ),

    // Upper Bottom Navigation Bar (the one with Settings, 200, etc.)
    Positioned(
    bottom: 70, // ग्रीन बार को थोड़ा ऊपर किया गया है ताकि प्ले बटन वाला बार इसके नीचे आ सके
    left: 0,
    right: 0,
    child: Container(
    height: 80, // Height of this green bar
    decoration: BoxDecoration(
    color: Colors.grey[200], // Changed to light gray
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.2),
    spreadRadius: 2,
    blurRadius: 5,
    offset: const Offset(0, -3),
    ),
    ],
    // borderRadius: const BorderRadius.only( // Removed borderRadius
    //   topLeft: Radius.circular(20),
    //   topRight: Radius.circular(20),
    // ),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    // Removed const Spacer(), from here (line 283)
    _buildBottomNavIcon(
    iconPath: 'assets/icons/settings_icon.png', // Placeholder icon
    label: 'Settings',
    index: 0,
    onTap: () => _onItemTapped(0),
    ),
    _buildBottomNavIcon(
    iconPath: 'assets/icons/person_icon.png', // Placeholder icon
    label: 'Person',
    index: 1,
    onTap: () => _onItemTapped(1),
    ),
    _buildBottomNavIcon(
    iconPath: 'assets/icons/person_icon.png', // Placeholder icon
    label: 'shopping',
    index: 2,
    onTap: () => _onItemTapped(2),
    ),
    _buildBottomNavIcon(
    iconPath: 'assets/icons/person_icon.png', // Placeholder icon
    label: 'cart',
    index: 3,
    onTap: () => _onItemTapped(3),
    ),
    _buildBottomNavIcon(
    iconPath: 'assets/icons/gallery_icon.png', // Placeholder icon
    label: 'gallery',
    index: 4,
    onTap: () => _onItemTapped(4),
    ),
    ],
    ),
    ),
    ),
    // Bottom Play Button and User Icon (Overlaying the bottom nav bar)
    Positioned(
    bottom: 0, // इस मान को 0 पर सेट किया गया है ताकि यह ग्रीन बार के नीचे रहे
    left: 0,
    right: 0,
    child: Container( // <--- यह नया Container है
    // Removed color from here as it's now in decoration
    padding: const EdgeInsets.only(bottom: 10.0), // Adjust to lift slightly above the physical screen bottom
    decoration: const BoxDecoration( // Added BoxDecoration
    color: Color(0xFF00B3A7), // Set to Teal color
    borderRadius: BorderRadius.only( // Added borderRadius
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    ),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // आइकनों को समान रूप से वितरित करेगा
    crossAxisAlignment: CrossAxisAlignment.end, // Align to bottom
    children: [
    // User Icon
    Image.asset( // Changed to Image.asset directly
    'assets/icons/profile_placeholder.png', // Replace with actual user image
    width: 50,
    height: 50,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, color: Colors.red, size: 50); // Fallback
    },
    ),
    // Toggle Icon (Replaced from Play Button)
    Transform.translate( // New wrapper to adjust vertical position
    offset: const Offset(0.0, 5.0), // Adjust the Y value to move it up/down (positive moves down)
    child: GestureDetector(
    onTap: () {
    print('Toggle icon tapped');
    // TODO: Implement toggle functionality
    },
    child: Stack( // Added Stack to layer toggle and video icons
    alignment: Alignment.center, // Center the main toggle image
    children: [
    Image.asset( // Changed to Image.asset directly
    'assets/icons/toggle.png', // Replaced with toggle.png
    width: 90, // Adjust size as needed
    height: 60, // Adjust size as needed
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, color: Colors.red, size: 60); // Fallback
    },
    ),
    // Video Icon (positioned on top-right of toggle)
    Positioned(
    top: 0, // Adjust as needed to fine-tune vertical position
    right: 0, // Adjust as needed to fine-tune horizontal position
    child: Image.asset(
    'assets/icons/video_icon.png', // Video icon
    width: 50, // Smaller size for overlay
    height: 63, // Smaller size for overlay
    // Removed color property to use original image color
    errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.videocam, color: Colors.red, size: 20); // Fallback
    },
    ),
    ),
    ],
    ),
    ),
    ),
    // Box Icon (New addition)
    GestureDetector(
    onTap: () {
    print('Box icon tapped');
    // TODO: Implement box functionality
    },
    child: Image.asset( // Changed to Image.asset directly
    'assets/icons/box.png', // Your new box icon
    width: 50,
    height: 50,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error, color: Colors.red, size: 50); // Fallback
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
  Widget _buildPlaceholderCard(BuildContext context) { // context added
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
          border: Border.all(color: Colors.grey[300]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // You can add content inside the placeholder card if needed
      ),
    );
  }

  // Helper widget for the Doctor card
  Widget _buildDoctorCard(BuildContext context) { // context added
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
          border: Border.all(color: Colors.grey[300]!, width: 2),
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
              'assets/icons/doctor_placeholder.png', // Replace with actual doctor image
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
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container( // Added Container for circular background
            width: 50, // Size of the circular background
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Removed color property to make it transparent inside
              border: Border.all(
                color: const Color(0xFF00B3A7), // Teal border color
                width: 2, // Border width
              ),
              // Removed boxShadow to make it flat
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 30, // Icon size
                height: 30,
                color: Colors.white12, // Icon color changed to Teal
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black, // Text color changed to black
            ),
          ),
        ],
      ),
    );
  }
}
