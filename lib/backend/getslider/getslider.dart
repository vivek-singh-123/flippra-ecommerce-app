import 'dart:convert';
import 'package:http/http.dart' as http;
import 'slidermodel.dart';

class GetSlider {
  static Future<List<SliderModel>> getslider() async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowSlider");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'token': "wvnwivnoweifnqinqfinefnq"},
    );

    print("Status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => SliderModel.fromJson(item)).toList();
    } else {
      throw Exception('❌ Failed to load slider. Status: ${response.statusCode}');
    }
  }
}