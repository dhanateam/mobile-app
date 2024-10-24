import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:telemoni/utils/endpoints.dart';
import 'package:telemoni/utils/secure_storage_service.dart';

class ApiService {
  final SecureStorageService secureStorageService = SecureStorageService();
  static String? _token;

  // Method to set the token after OTP verification or on login
  static Future<void> setTokyo(String token) async {
    _token = token; // Store token in memory
  }

  // Method to get the token, either from memory or secure storage if not set
  Future<String?> getTokyo() async {
    if (_token != null) {
      return _token; // Return in-memory token if already set
    } else {
      // Fetch from secure storage and set in memory for future use
      _token = await secureStorageService.getToken();
      return _token;
    }
  }

  // Method to clear the token, e.g., on logout
  static void clearToken() {
    _token = null; // Clear in-memory token
  }

  Future<String?> generateOTP(String phoneNumber) async {
    final response = await http.post(
      Uri.parse(Endpoints.generateOTP), // Use baseUrl here

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
      Uri.parse(Endpoints.verifyOtp),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'number': phoneNumber, 'otp': otp}),
    );
    //print(json.encode({'number': phoneNumber, 'otp': otp}),);

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

Future<void> submitPanDetails(Map<String, dynamic> panData) async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }

    final response = await http.post(
      Uri.parse(Endpoints.addPan),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode(panData),
    );

    if (response.statusCode == 200) {
      print('Details submitted successfully');
    } else {
      print('Failed to submit details: ${response.reasonPhrase}');
    }
  }

  Future<void> submitBankDetails(Map<String, dynamic> bankData) async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }

    final response = await http.post(
      Uri.parse(Endpoints.addProviderBank),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode(bankData),
    );

    if (response.statusCode == 200) {
      print('Bank Details submitted successfully');
    } else {
      print('Failed to submit details: ${response.body}');
    }
  }

  Future<void> createProduct(Map<String, dynamic> create) async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }

    final response = await http.post(
      Uri.parse(Endpoints.createProduct),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode(create),
    );
    print(json.encode(create));

    if (response.statusCode == 201) {
      print('Details submitted successfully');
    } else {
      print('Failed to submit details: ${response.body}');
    }
  }

}
