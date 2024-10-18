import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:telemoni/utils/themeprovider.dart';
import 'package:flutter/services.dart'; // Import to use TextInputFormatter

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _panController = TextEditingController();
  File? _selectedImage;
  bool _isFormVisible = false;
  bool _isPanValid = true;

  final _panFormat = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _validateAndSubmit() {
    String enteredPan = _panController.text.toUpperCase();
    bool isPanValid = _panFormat.hasMatch(enteredPan);

    setState(() {
      _isPanValid = isPanValid;
    });

    if (isPanValid && _selectedImage != null) {
      final panData = {
        'pan': enteredPan,
        'image': base64Encode(_selectedImage!.readAsBytesSync()),
      };
      print('Form Submitted: $panData');
    }
  }

  List<TextInputFormatter> _getPanInputFormatters(String text) {
    if (text.length >= 5 && text.length <= 8) {
      // Return a numeric-only input formatter for digits 6–9
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    // Return input formatter for A-Z letters for positions 1–5 and 10
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
      LengthLimitingTextInputFormatter(10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isFormVisible
                  ? 'Complete the form to get verified'
                  : 'You are not verified',
              style: TextStyle(
                color: customColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            if (_isFormVisible) ...[
              TextField(
                controller: _panController,
                onChanged: (value) {
                  setState(() {
                    // Update the input formatters based on input length
                    _panController.text = value.toUpperCase();
                    _panController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _panController.text.length),
                    );
                  });
                },
                inputFormatters: _getPanInputFormatters(_panController.text),
                decoration: InputDecoration(
                  labelText: 'Enter your PAN',
                  errorText: _isPanValid ? null : 'Invalid PAN format',
                  labelStyle: TextStyle(color: customColors.textColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: customColors.textColor),
                  ),
                ),
                style: TextStyle(color: customColors.textColor),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors.buttonColor,
                ),
                child: Text(
                  'Choose Image',
                  style: TextStyle(color: customColors.textColor),
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.file(_selectedImage!, height: 100, width: 100),
                ),
            ] else ...[
              Container(
                width: mediaQuery.size.width * 0.922,
                height: mediaQuery.size.height * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/404.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_isFormVisible) {
                  _validateAndSubmit();
                } else {
                  setState(() {
                    _isFormVisible = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormVisible
                    ? themeProvider.isDarkMode
                        ? Colors.green[900]
                        : Colors.greenAccent
                    : themeProvider.isDarkMode
                        ? Colors.red[900]
                        : Colors.redAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.2,
                  vertical: mediaQuery.size.height * 0.02,
                ),
              ),
              child: Text(
                _isFormVisible ? 'Submit' : 'Get Verified',
                style: TextStyle(color: customColors.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
