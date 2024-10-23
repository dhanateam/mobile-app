import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:telemoni/utils/endpoints.dart';
import 'package:telemoni/utils/secure_storage_service.dart';

class ApiService {
  final SecureStorageService secureStorageService = SecureStorageService();

  Future<String?> generateOTP(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user/otpgen'), // Use baseUrl here

      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'number': phoneNumber}),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['otp']; // Adjust according to your API response
    } else {
      throw Exception('Failed to generate OTP');
    }
  }

   Future<String?> verifyOTP(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user/verifyotp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'number': phoneNumber, 'otp': otp}),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token']; // Assuming the token is under 'token'

      // Store the token securely
      await secureStorageService.storeToken(token);
      
      return token;
    } else {
      throw Exception('Failed to verify OTP');
    }
  }

Future<void> submitDetails(Map<String, dynamic> panData) async {
  String? token = await secureStorageService.getToken(); 
final response = await http.post(
      Uri.parse('$baseUrl/api/user/add/pan'), // Use baseUrl here


      headers: {
        'authorization':'$token' ,
        'Content-Type': 'application/json',
      },
      body: json.encode(panData),
    );
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['otp']; // Adjust according to your API response
    }
  if (response.statusCode == 200) {
    // Handle success
    print('Details submitted successfully');
  } else {
    // Handle error
    print('Failed to submit details: ${response.reasonPhrase}');
  }
}

}
