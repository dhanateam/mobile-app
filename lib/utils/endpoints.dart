class Endpoints {
  static const String baseUrl = 'http://13.201.168.52';
  static const String generateOTP = '$baseUrl/api/auth/user/otpgen';
  static const String addPan = '$baseUrl/api/user/add/pan';
  static const String verifyOtp = '$baseUrl/api/auth/user/verifyotp';
  static const String addProviderBank = '$baseUrl/api/provider/add/bank';
  static const String createProduct = '$baseUrl/api/provider/add/product';
}
