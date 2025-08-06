class SliderModel {
  final int id;
  final String images;

  SliderModel({
    required this.id,
    required this.images,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    final dynamic img = json['Images']; // ✅ Updated to match your API key

    final imageUrl = (img != null && img.toString().trim().isNotEmpty)
        ? (img.toString().startsWith("http")
        ? img
        : "https://flippraa.anklegaming.live/image/$img")
        : 'https://flippraa.anklegaming.live/image/banner_placeholder.png';

    return SliderModel(
      id: json['ID'] ?? 0,
      images: imageUrl,
    );
  }
}