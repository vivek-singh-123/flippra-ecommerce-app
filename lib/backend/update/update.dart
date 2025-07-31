import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateUser extends GetxController{
  final isLoading = false.obs;
  final message = ''.obs;

  Future<void> updateuser ({
    required String token,
    required String firstname,
    required String lastname,
    required String Gender,
    required String Email,
    required String City,
    required String phone,
  }) async {
    final url = Uri.parse('https://flippraa.anklegaming.live/APIs/APIs.asmx/ProfileUpdate');

    try{
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'token':token,
            'firstname':firstname,
            'lastname':lastname,
            'Gender':Gender,
            'Email':Email,
            'City':City,
            'phone':phone,
          }
      );
      if(response.statusCode == 200){
        print("✅ Successfully joined");
        print(response.body);
      }
    }
    catch (e) {
      print('❌ Exception while joining $e');
    }
  }
}