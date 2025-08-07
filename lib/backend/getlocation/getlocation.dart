import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'locationmodel.dart';

class LocationFetchApi {
  static Future<LocationModel> getAddressFromLatLng() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationModel(
          main: "Location Disabled",
          detail: "Please enable location services.",
          landmark: "Settings > Location",
        );
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationModel(
            main: "Permission Denied",
            detail: "Location permission was denied",
            landmark: "",
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationModel(
          main: "Permission Denied Forever",
          detail: "Location permissions are permanently denied.",
          landmark: "Go to settings to enable.",
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // Build the full address string
        String fullAddress = [
          place.name,
          place.thoroughfare,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country
        ].where((part) => part != null && part!.trim().isNotEmpty).join(', ');

        print("📍 Location fetched: $fullAddress");

        return LocationModel(
          main: place.locality ?? '', // e.g., "New Delhi"
          detail: fullAddress,        // full formatted address
          landmark: place.name ?? '', // e.g., "2/7"
        );
      } else {
        return LocationModel(
          main: "Location Not Found",
          detail: "No placemark data",
          landmark: "",
        );
      }
    } catch (e) {
      return LocationModel(
        main: "Unknown Location",
        detail: "Could not fetch address",
        landmark: e.toString(),
      );
    }
  }
}
