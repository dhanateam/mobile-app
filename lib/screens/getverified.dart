import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:telemoni/utils/themeprovider.dart';

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

  void _onPanChanged(String value) {
    String newValue = value.toUpperCase();

    // Build a new text based on character/number restrictions
    if (newValue.length <= 10) {
      StringBuffer buffer = StringBuffer();
      for (int i = 0; i < newValue.length; i++) {
        if ((i < 5 || i == 9) && RegExp(r'[A-Z]').hasMatch(newValue[i])) {
          // Letters allowed in positions 1-5 and 10
          buffer.write(newValue[i]);
        } else if ((i >= 5 && i < 9) &&
            RegExp(r'[0-9]').hasMatch(newValue[i])) {
          // Numbers allowed in positions 6-9
          buffer.write(newValue[i]);
        }
      }
      _panController.value = TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: buffer.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show different titles based on form state
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
              const SizedBox(height: 20),
              if (_isFormVisible) ...[
                TextField(
                  controller: _panController,
                  onChanged: _onPanChanged,
                  // Ensure a digit input keyboard is shown when entering positions 6-9
                  keyboardType: _panController.text.length >= 6 &&
                          _panController.text.length <= 9
                      ? TextInputType.number
                      : TextInputType.text,
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
                  width: mediaQuery.size.width * 0.9,
                  height: mediaQuery.size.height * 0.3,
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
      ),
    );
  }
}
