import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetUser extends GetxController {
  final isLoading = false.obs;
  final message = ''.obs;

  Future<List<dynamic>> getuserdetails({
    required String token,
    required String phone,
  }) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowRegisterUsers");

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'phonenumber': phone,
        },
      );

      if (response.statusCode == 200) {
        final bodyString = response.body;

        // Extract JSON from XML using regex (e.g., [ { ... } ])
        final match = RegExp(r'\[.*\]').firstMatch(bodyString);
        if (match != null) {
          final jsonString = match.group(0)!;
          final data = jsonDecode(jsonString);
          print("user data from getuser ${data}");
          return data; // Should be a List<dynamic>
        } else {
          print("⚠️ No JSON found in response body");
          return [];
        }
      } else {
        print("❌ Failed with status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print('❌ Exception while fetching user details: $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}