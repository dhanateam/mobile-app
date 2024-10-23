import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  // Store token
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
