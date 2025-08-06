import 'package:flutter/material.dart';

class Shop2Screen extends StatefulWidget {
  const Shop2Screen({super.key});

  @override
  State<Shop2Screen> createState() => _Shop2ScreenState();
}

class _Shop2ScreenState extends State<Shop2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Map Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_placeholder.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text('Map Image Not Found', style: TextStyle(color: Colors.black)),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Adjusted to move it higher, showing less map
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _buildHandleBar(),
                  const SizedBox(height: 10),
                  _buildProfileCard(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => _buildUserRow(index), // Pass index for user names
                    ),
                  )
                ],
              ),
            ),
          ),

          // Back Button (shifted to Top Left) - UPDATED
          Positioned(
            top: MediaQuery.of(context).padding.top + 10, // Adjust top padding for status bar
            left: 10,
            child: GestureDetector( // Changed to GestureDetector as per reference
              onTap: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Container( // Changed to Container as per reference
                padding: const EdgeInsets.all(8), // Added padding as per reference
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4), // Semi-transparent black background as per reference
                  borderRadius: BorderRadius.circular(20), // Rounded corners as per reference
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Original Back Button (positioned at bottom right) - Commented out as requested not to delete
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.black.withOpacity(0.7),
          //     onPressed: () => Navigator.pop(context),
          //     child: const Icon(Icons.arrow_back, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHandleBar() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
          (index) => Container(
        width: 40,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  );

  Widget _buildProfileCard() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/icons/profile_placeholder.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('NAME | PRODUCT',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text('Add a little bit of body text',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
        ),
        Column(
          children: [
            const Icon(Icons.notifications_active, color: Colors.green),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text('Send I Again', style: TextStyle(color: Colors.white, fontSize: 10)),
                  Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white),
                ],
              ),
            )
          ],
        )
      ],
    ),
  );

  Widget _buildUserRow(int index) {
    List<String> userNames = ['John Qureshi', 'Ravi Kumar', 'Priya Singh', 'Amit Verma']; // Example names
    return Stack(
      children: [
        // The main chat entry card
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 85), // Adjusted left margin for more space
          padding: const EdgeInsets.all(15), // Adjusted padding for more space inside card
          decoration: BoxDecoration(
            color: Colors.white, // Changed to white background
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute icons evenly
                      children: const [
                        Icon(Icons.thumb_up, size: 18, color: Colors.grey), // Changed to thumb_up
                        // Removed SizedBox(width: 10)
                        Icon(Icons.sentiment_satisfied_alt, size: 18, color: Colors.grey), // Kept this icon
                        // Removed SizedBox(width: 10)
                        Icon(Icons.badge, size: 18, color: Colors.grey), // Changed to badge
                        // Removed SizedBox(width: 10)
                        Icon(Icons.store, size: 18, color: Colors.grey), // Changed to store
                      ],
                    ),
                    const SizedBox(height: 8), // Increased space between icon rows
                    CustomPaint( // Horizontal Dashed line separator
                      painter: _DashedLinePainter(), // This is now the horizontal dashed line
                      child: Container(
                        height: 1, // Height of the dashed line
                        width: double.infinity, // Take full width
                      ),
                    ),
                    const SizedBox(height: 8), // Increased space after dashed line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end, // Align chat and call to the right
                      children: [
                        Container( // Chat icon with background
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey, // Grey background for chat icon
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                          child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20), // White chat icon
                        ),
                        const SizedBox(width: 100), // Space between chat and call
                        Container( // Call icon with background
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey, // Grey background for call icon
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                          child: const Icon(Icons.call, color: Colors.white, size: 20), // White call icon
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Profile Avatar and Dashed Line (positioned outside the card)
        Positioned(
          left: 8, // Adjusted left position for the avatar
          top: 0,
          bottom: 0,
          child: Column(
            children: [
              CircleAvatar(
                radius: 25, // Adjusted radius
                backgroundImage: AssetImage('assets/icons/profile_placeholder.png'),
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading chat profile image: $exception');
                },
              ),
              Text(
                userNames[index], // Display user name
                style: const TextStyle(color: Colors.white, fontSize: 10), // Text color remains white for contrast
              ),
              if (index < 3) // Add dashed line for all but the last user
                Expanded(
                  child: CustomPaint(
                    painter: _DashedLinePainter(), // This will now also be horizontal dashed
                    child: Container(width: 1), // Invisible container to give CustomPaint space
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Painter for the horizontal dashed line (modified from dotted)
class _DashedLinePainter extends CustomPainter {
  // Defined as static const to be accessible within the class
  static const double dashLength = 10; // Length of each dash
  static const double dashSpace = 3; // Space between dashes (made it smaller for "close close")

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey // Color of the dashes
      ..strokeWidth = 1 // Thickness of the line
      ..style = PaintingStyle.stroke; // Changed to stroke for lines

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2), // Start point of the dash
        Offset(startX + dashLength, size.height / 2), // End point of the dash
        paint,
      );
      startX += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// Removed _DotLinePainter as _DashedLinePainter is now handling horizontal dashes.