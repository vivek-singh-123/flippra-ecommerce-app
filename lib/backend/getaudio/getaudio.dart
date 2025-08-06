import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetAudio extends GetxController{
  final isLoading = false.obs;
  final message = ''.obs;

  Future<List<dynamic>> getaudio({
    required String token,
    required String langauge,
  }) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/voice");
    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'language':langauge
        },
      );
      if(response.statusCode == 200){
        final bodyString = response.body;

        // Extract JSON from XML using regex (e.g., [ { ... } ])
        final match = RegExp(r'\[.*\]').firstMatch(bodyString);
        if (match != null) {
          final jsonString = match.group(0)!;
          final data = jsonDecode(jsonString);
          print("Video data from getvideo ${data}");
          return data; // Should be a List<dynamic>
        } else {
          print("⚠️ No JSON found in response body");
          return [];
        }
      } else {
        print("❌ Failed with status code: ${response.statusCode}");
        return [];
      }
    }
    catch(e){
      print("Exception ${e}");
      return [];
    }
  }

}