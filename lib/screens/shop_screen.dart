import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // State Variables
  final MapController _mapController = MapController();
  Position? _currentPosition;
  String _locationText1 = 'Fetching location...';
  String _locationText2 = '';
  String _locationText3 = '';
  int _selectedServiceIndex = 0;
  bool _isToggleRight = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // --- LOGIC ---

  Future<void> _getCurrentLocation() async {
    // This logic remains unchanged
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _locationText1 = 'Location services disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _locationText1 = 'Location permissions denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _locationText1 = 'Location permissions permanently denied');
      return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (mounted) {
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _locationText1 = '${place.locality ?? 'Unknown'} - ${place.postalCode ?? ''}';
            _locationText2 = place.subLocality ?? place.street ?? '';
            _locationText3 = 'Near ${place.name ?? place.thoroughfare ?? ''}';
          });
        } else {
          setState(() => _locationText1 = 'No location data available');
        }
        _mapController.move(LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 16.0);
      }
    } catch (e) {
      if (mounted) setState(() => _locationText1 = 'Error fetching location');
    }
  }

  void _toggleVideoIconPosition() {
    setState(() => _isToggleRight = !_isToggleRight);
  }

  // --- UI BUILDER METHODS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content Layout
          Column(
            children: [
              _buildMapSection(),
              _buildBusinessCardList(),
            ],
          ),
          // Overlaid UI Elements
          _buildBackButton(),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  /// Builds the top section containing the map and the location info bar.
  Widget _buildMapSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      color: Colors.grey[200],
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(28.7041, 77.1025), // Default to Delhi
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey={apiKey}',
                additionalOptions: const {'apiKey': '2a411b50aafc4c1996eca70d594a314c'},
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),
          _buildLocationInfoBar(),
        ],
      ),
    );
  }

  /// Builds the location info bar that overlays the map.
  Widget _buildLocationInfoBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF00B3A7),
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
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_locationText1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(_locationText2, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(_locationText3, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
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
    );
  }

  /// Builds the scrollable list of business cards.
  Widget _buildBusinessCardList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: 5,
          itemBuilder: (context, index) => _buildBusinessCard(context),
        ),
      ),
    );
  }

  /// Builds a single business card item.
  Widget _buildBusinessCard(BuildContext context) {
    // This function builds one card, so it's already well-separated.
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(image: AssetImage('assets/icons/business_card_placeholder.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Business Card', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    label: const Text('Request Now', style: TextStyle(color: Colors.white, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  /// Builds the back button that overlays the top-left of the screen.
  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  /// Builds the entire two-part bottom navigation bar.
  Widget _buildBottomNavigationBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildServiceIconRow(), // Section 1
            _buildToggleBar(),      // Section 2
          ],
        ),
      ),
    );
  }

  /// Builds the top row of the bottom navigation bar (circular service icons).
  Widget _buildServiceIconRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildServiceIcon('assets/icons/setting.png', 'Setting', 0),
          _buildServiceIcon('assets/icons/low.png', 'Low', 1),
          _buildServiceIcon('assets/icons/home.png', 'Home', 2),
          _buildServiceIcon('assets/icons/cart.png', 'Cart', 3),
          _buildServiceIcon('assets/icons/parcel.png', 'Parcel', 4),
          _buildServiceIcon('assets/icons/doctor.png', 'Doctor', 5),
        ],
      ),
    );
  }

  /// Builds the bottom row of the bottom navigation bar (profile, toggle, box).
  Widget _buildToggleBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF00B3A7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/icons/profile_placeholder.png', width: 50, height: 50),
          GestureDetector(
            onTap: _toggleVideoIconPosition,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/icons/toggle.png', width: 90, height: 60),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: _isToggleRight ? null : 0,
                  right: _isToggleRight ? 0 : null,
                  child: Image.asset('assets/icons/video_icon.png', width: 50, height: 63),
                ),
              ],
            ),
          ),
          Image.asset('assets/icons/box.png', width: 50, height: 50),
        ],
      ),
    );
  }

  /// Builds a single circular service icon for the top row of the nav bar.
  Widget _buildServiceIcon(String imagePath, String label, int index) {
    bool isSelected = _selectedServiceIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedServiceIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : const Color(0xFF00B3A7),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}