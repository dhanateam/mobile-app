import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:telemoni/utils/themeprovider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _panController = TextEditingController();
  final _focusNode = FocusNode();
  File? _selectedImage;
  bool _isFormVisible = false;
  bool _isPanValid = true;
  String _verificationStatus = '';
bool _isImageRequired = false;

  // PAN format regex: 5 uppercase letters, 4 digits, and 1 uppercase letter
  final _panFormat = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus(); // Check verification status on initial render
  }

  @override
  void dispose() {
    _panController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Function to check verification status (returns random value for demonstration)
  void _checkVerificationStatus() {
    final statuses = ['verified', 'pending', 'not verified'];
    setState(() {
      _verificationStatus = statuses[Random().nextInt(statuses.length)];
    });
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

  // Method to handle input changes and dynamically switch keyboards
  void _onPanChanged(String value) {
    String newValue = value.toUpperCase();

    // Limit the length of the input to 10 characters
    if (newValue.length > 10) {
      newValue = newValue.substring(0, 10);
    }

    // Check the length to handle keyboard switching logic
    if (newValue.length == 5) {
      // Close the alphabetical keyboard and open the numerical keyboard
      _focusNode.unfocus();
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_focusNode);
        SystemChannels.textInput
            .invokeMethod('TextInput.setClient', [null, TextInputType.number]);
      });
    } else if (newValue.length == 9) {
      // Close the numerical keyboard and open the alphabetical keyboard
      _focusNode.unfocus();
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_focusNode);
        SystemChannels.textInput
            .invokeMethod('TextInput.setClient', [null, TextInputType.text]);
      });
    }

    // Update the text field with the uppercase value
    _panController.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newValue.length),
      ),
    );

    setState(() {
      _isPanValid = true; // Reset validation state when input changes
    });
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
              if (_verificationStatus == 'verified')
                Text(
                  'You are verified',
                  style: TextStyle(
                    color: customColors.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (_verificationStatus == 'pending')
                Column(
                  children: [
                    Image.asset(
                      'assets/clock.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please wait while we verify your details',
                      style: TextStyle(
                        color: customColors.textColor,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
!_isFormVisible
                          ? 'You are not verified'
                          : 'Complete the form to get verified',                      style: TextStyle(
                        color: customColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                        if (!_isFormVisible)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'assets/404.jpg',
                        width: MediaQuery.of(context).size.width*.9,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_isFormVisible)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [

                              TextField(
                                controller: _panController,
                                focusNode: _focusNode,
                                onChanged: _onPanChanged,
                                keyboardType: _panController.text.length >= 5 &&
                                        _panController.text.length < 9
                                    ? TextInputType.number
                                    : TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9]'),
                                  ),
                                ],
                                maxLength: 10,
                                decoration: InputDecoration(
                                  labelText: 'Enter your PAN',
                                  errorText:
                                      _isPanValid ? null : 'Invalid PAN ',
                                  labelStyle:
                                      TextStyle(color: customColors.textColor),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: customColors.textColor),
                                  ),
                                ),
                                style: TextStyle(color: customColors.textColor),
                              ),
                              const SizedBox(height: 16),
                             Column(
                                children: [
                                  if (_selectedImage != null)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Image.file(
                                        _selectedImage!,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                  ElevatedButton(
                                    onPressed: _pickImage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: customColors.customBlue,
                                    ),
                                    child: Text(
                                      'Pan Image',
                                      style: TextStyle(
                                          color: customColors.textColor),
                                    ),
                                  ),
                                  if (_isImageRequired &&
                                      _selectedImage ==
                                          null) // Show the error only when the submit button is clicked and image is not selected
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'We need your PAN to verify your details',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        if (_isFormVisible) {
                          _validateAndSubmit();
                          setState(() {
                            _isImageRequired = _selectedImage ==
                                null; // Show error if image is not selected
                          });
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
                          vertical: mediaQuery.size.height * 0.016,
                        ),
                      ),
                      child: Text(
                        _isFormVisible ? 'Submit' : 'Get Verified',
                        style: TextStyle(color: customColors.textColor),
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),
      ),
    );
  }
}
