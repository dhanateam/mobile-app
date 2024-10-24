import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final http.Client _client;
  String? _token; // Private token

  ApiClient(this._client);

  // Getter to access the token
  String? get token => _token;

  // Set the token after successful login
  void setToken(String token) {
    _token = token;
  }

  // Add common headers (including token) to each request
  Map<String, String> _getHeaders() {
    return {
      'authorization': _token != null ? 'Bearer $_token' : '',
      'Content-Type': 'application/json',
    };
  }

  // POST method for API requests
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse(endpoint),
      headers: _getHeaders(),
      body: json.encode(body),
    );
    return response;
  }

  // Optional: GET method for API requests
  Future<http.Response> get(String endpoint) async {
    final response = await _client.get(
      Uri.parse(endpoint),
      headers: _getHeaders(),
    );
    return response;
  }
}
