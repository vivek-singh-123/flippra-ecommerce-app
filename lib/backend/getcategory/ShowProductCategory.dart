import 'dart:convert';
import 'package:http/http.dart' as http;


class Getcategory {
  // Use ProductCategoryModel in the return type since that's what you're parsing
  static Future<List<ProductCategoryModel>> getcategorydetails(String categoryType) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowProductCategory",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': "wvnwivnoweifnqinqfinefnq",
        'CategoryType': categoryType,
      },
    );

    print("Status code : ${response.statusCode}");
    print("Raw response :\n ${response.body}");

    if (response.statusCode == 200) {
      // Some .asmx services return JSON wrapped in a string, so handle that
      dynamic decoded = jsonDecode(response.body);

      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      final List<dynamic> jsonData = decoded;
      final categories = jsonData
          .map((item) => ProductCategoryModel.fromJson(item))
          .toList();

      print("Parsed Category List : ${categories.length} items");
      return categories;
    } else {
      throw Exception(
          '❌ Failed to load categories. Status: ${response.statusCode}');
    }
  }
}

class ProductCategoryModel {
  final int id;
  final String categoryImg;
  final String categoryName;
  final String categoryType;

  ProductCategoryModel({
    required this.id,
    required this.categoryImg,
    required this.categoryName,
    required this.categoryType,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['ID'] ?? 0,
      categoryImg: json['CategoryImg'] ?? '',
      categoryName: json['CategoryName'] ?? '',
      categoryType: json['CategoryType'] ?? '',
    );
  }

  // Add this method to get full image URL:
  String get fullImageUrl {
    return "https://flippraa.anklegaming.live/image/$categoryImg";
  }
}
