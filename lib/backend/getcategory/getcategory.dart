import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import './categoryModel.dart';

class GetChildCategory {
  static Future<List<CategoryModel>> getchildcategorydetails(String categoryType) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowChildCategory");

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
      final List<dynamic> jsonData = jsonDecode(response.body);
      final category = jsonData.map((item) => CategoryModel.fromJson(item)).toList();
      print("Parsed Category List : ${category.length} items");
      return category;
    } else {
      throw Exception('❌ Failed to load tournaments. Status: ${response.statusCode}');
    }
  }
}
