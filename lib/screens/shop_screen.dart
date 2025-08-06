import 'package:flutter/material.dart';
import 'package:flippra/screens/shop2_screen.dart'; // Import shop2_screen.dart

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top Map and Location/Filters Section
              Container(
                height: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
                color: Colors.grey[200], // Placeholder for map background
                child: Stack(
                  children: [
                    // Placeholder for the Map Image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/icons/map_placeholder.png', // Replace with your map image
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.blueGrey[100],
                            child: const Center(
                              child: Text('Map Image Missing', style: TextStyle(color: Colors.black54)),
                            ),
                          );
                        },
                      ),
                    ),
                    // Location and Filters Bar overlaying the map
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B3A7), // Teal color from image
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white, // White circle for location icon
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Delhi - 6',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Sadar Bazar, Pahadi Dheeraj',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                      Text(
                                        'Near Axis Bank',
                                        style: TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2), // Semi-transparent white for filters
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Text('Filters', style: TextStyle(color: Colors.white, fontSize: 14)),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable List of Business Cards
              Expanded(
                child: Container(
                  color: Colors.white, // Background for the cards section
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: 5, // Example: 5 business cards
                    itemBuilder: (context, index) {
                      return _buildBusinessCard(context);
                    },
                  ),
                ),
              ),

              // Spacer for the custom bottom bar
              const SizedBox(height: 150), // Adjust height to match your custom bottom bar
            ],
          ),

          // Back Button (Top Left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Adjust top padding for status bar
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Go back to the previous screen (HomeScreenCategoryScreen)
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4), // Semi-transparent black background
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // New: Top Right Button to navigate to Shop2Screen
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Adjust top padding for status bar
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Shop2Screen()), // Navigate to Shop2Screen
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4), // Semi-transparent black background
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: const Icon(
                  Icons.arrow_forward, // Forward arrow icon
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Custom Bottom Navigation Bar (Request Now, Microphone, User Icons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150, // Total height of the custom bottom section
              decoration: BoxDecoration(
                color: const Color(0xFF00B3A7), // Teal color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Request Now button with user icons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        // Three user icons
                        _buildUserIconSmall(),
                        _buildUserIconSmall(),
                        _buildUserIconSmall(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('Request Now tapped');
                              // TODO: Implement request functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Green color for button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              elevation: 3,
                            ),
                            child: const Text(
                              'Request Now',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Microphone icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.mic, color: Colors.black, size: 30),
                        ),
                      ],
                    ),
                  ),
                  // Bottom row of icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBottomNavIcon(Icons.settings, 'Settings', 0),
                      _buildBottomNavIcon(Icons.person, '200', 1),
                      _buildBottomNavIcon(Icons.person, '200', 2),
                      _buildBottomNavIcon(Icons.person, '200', 3),
                      _buildBottomNavIcon(Icons.image, '200', 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for small user icons
  Widget _buildUserIconSmall() {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/man.png', // Using man.png for user icon
          width: 20,
          height: 20,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Helper for business cards
  Widget _buildBusinessCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Image and Add Button
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Placeholder for business card image
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/business_card_placeholder.png'), // Replace with actual business card image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    print('Add button tapped');
                    // TODO: Implement add functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green color for add button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Right Content (Business Card details)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Business Card',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text('₹ 6000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Icon(Icons.star_border, color: Colors.amber, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print('Request Now tapped for card');
                      // TODO: Implement request functionality for this card
                    },
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    label: const Text('Request Now', style: TextStyle(color: Colors.white, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green color for request button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for bottom navigation icons
  Widget _buildBottomNavIcon(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation for these icons
        print('Bottom nav icon tapped: $label');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white, // All icons are white as per image
            size: 30,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}