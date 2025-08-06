class CategoryModel {
  final int id;
  final String categoryImg;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryImg,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['ID'],
      categoryImg: json['CategoryImg'].toString().startsWith("http")
          ? json['CategoryImg']
          : "https://flippraa.anklegaming.live/image/${json['CategoryImg']}",
      categoryName: json['CategoryName'],
    );
  }
}