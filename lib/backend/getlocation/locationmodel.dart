class LocationModel {
  final String main;     // e.g., "Delhi - 6"
  final String detail;   // e.g., "Near Azad Market, Pahadi Dheeraj"
  final String landmark; // e.g., "Near Axis Bank"

  LocationModel({
    required this.main,
    required this.detail,
    required this.landmark,
  });

  factory LocationModel.fromMap(Map<String, String> map) {
    return LocationModel(
      main: map['main'] ?? '',
      detail: map['detail'] ?? '',
      landmark: map['landmark'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'main': main,
      'detail': detail,
      'landmark': landmark,
    };
  }
}