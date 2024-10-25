import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/models/product.dart';
import 'package:telemoni/models/transaction.dart';
import 'package:telemoni/utils/endpoints.dart';
import 'package:telemoni/utils/secure_storage_service.dart';

class ApiService {
  // Create a private static instance of the class
  static final ApiService _instance = ApiService._internal();

  // The HTTP client used throughout the app
  final http.Client _client = http.Client();

  // Private constructor to restrict external instantiation
  ApiService._internal();

  // Factory constructor that returns the singleton instance
  factory ApiService() {
    return _instance;
  }
  final SecureStorageService secureStorageService = SecureStorageService();
  static String? _token;

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
    final response = await _client.post(
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
    final response = await _client.post(
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

    final response = await _client.post(
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

    final response = await _client.post(
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

    final response = await _client.post(
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

  Future<List<BankDetails>> getBankAccounts() async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }

    final response = await _client.get(
      Uri.parse(Endpoints.getBankAccounts),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response into a list of bank details
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => BankDetails.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load bank accounts: ${response.reasonPhrase}');
    }
  }

  Future<List<Product>> getProducts() async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }
    final response = await _client.get(
      Uri.parse(Endpoints.getProducts),
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON data into a list of products
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products: ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> deleteBankAccount(String textId) async {
    String? token = await getTokyo(); // Get token from memory or secure storage
    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }
    final response = await http.delete(
      Uri.parse(Endpoints.deleteBankAccount), // Include textId in the URL
      headers: {
        'authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode({'id': textId}),
    );

    if (response.statusCode == 200) {
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> raiseWithdrawal(Map<String, dynamic> request) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.raiseWithdrawal),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_AUTH_TOKEN", // Add authorization token
        },
        body: json.encode({request
          // "bank_id": bankId,
          // "amount": amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to raise withdrawal');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Withdrawal history API
  Future<List<Transaction>> getWithdrawalHistory() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.withdrawalHistory),
        headers: {
          "Authorization": "Bearer YOUR_AUTH_TOKEN", // Add authorization token
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON data into a list of products
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Transaction.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch withdrawal history');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
