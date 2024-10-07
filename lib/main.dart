import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemoni/screens/home.dart';
import 'package:telemoni/utils/themeprovider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure widgets are bound before async code
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token'); // Check if a token exists

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(
          initialRoute: token == null
              ? '/login'
              : '/home'), // Direct to appropriate screen
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telemoni',
      theme: themeProvider.themeData,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPageContent(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? generatedOTP;
  bool otpVisible = false;

  // Function to generate a random OTP
  String _generateRandomOTP() {
    Random random = Random();
    return (1000 + random.nextInt(9000)).toString(); // Generate a 4-digit OTP
  }

  // Function to handle login and generate OTP
  void _handleLogin() {
    String phoneNumber = _phoneController.text;

    if (phoneNumber.isNotEmpty) {
      setState(() {
        generatedOTP = _generateRandomOTP();
        otpVisible = true; // Show OTP input
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  // Function to handle OTP verification and saving the token (phone number)
  Future<void> _verifyOTP() async {
    if (_otpController.text == generatedOTP) {
      // If OTP matches, save the phone number as a token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', _phoneController.text); // Save the phone number as a token

      // Navigate to the home page
      Navigator.pushReplacementNamed(context,'/home' );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Enter phone number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Generate OTP'),
            ),
            if (otpVisible) ...[
              const SizedBox(height: 20),
              Text('OTP: $generatedOTP',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter OTP'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP and Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

