class Endpoints {
  static const String baseUrl = 'http://13.201.168.52';
  static const String generateOTP = '$baseUrl/api/auth/user/otpgen';
  static const String addPan = '$baseUrl/api/user/add/pan';
  static const String verifyOtp = '$baseUrl/api/auth/user/verifyotp';
  static const String addProviderBank = '$baseUrl/api/provider/add/bank';
  static const String createProduct = '$baseUrl/api/provider/add/product';
  static const String getBankAccounts = '$baseUrl/api/provider//get/bankaccounts';
  static const String getProducts = '$baseUrl/api/provider//get/products';
  static const String deleteBankAccount = '$baseUrl/api/provider/delete/bankaccount';
  static const String raiseWithdrawal = '$baseUrl/api/provider/raise/withdrawl';
  static const String withdrawalHistory = '$baseUrl/api/provider/wallet/transactions';
}
