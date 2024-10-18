import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/utils/themeprovider.dart';

class CreateChannelPage extends StatefulWidget {
  final String type;

  const CreateChannelPage({required this.type, super.key});

  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _validity = 'One Day';
  String _ppu = '';
  String? _base64Image; // Store the base64 string of the selected image

  @override
  Widget build(BuildContext context) {
    final customColors = Provider.of<ThemeProvider>(context).customColors;

    return Scaffold(
     appBar: AppBar(
  title: Text(
    widget.type == 'Channel' ? 'Telegram Channel' : 'Telegram Group',
    style: TextStyle(
      color: customColors.textColor, // Set the text color using customColors
    ),
  ),
        backgroundColor: Theme.of(context)
            .colorScheme
            .inversePrimary, // Set background using seed color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: customColors.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFirstCard(customColors),
            const SizedBox(height: 20),
            _buildSecondCard(customColors),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors
                    .customGreen, // Change button color to customGreen
                shadowColor: customColors.shadowColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Create Request'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstCard(CustomColorScheme customColors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: customColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: _getPhoto,
                  child: CircleAvatar(
                    backgroundColor: customColors.customGrey,
                    child:
                        Icon(Icons.camera_alt, color: customColors.iconColor),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter ${widget.type} name',
                      hintStyle: TextStyle(
                          color: customColors.textColor.withOpacity(0.6)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customColors.customBlue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customColors.customGrey),
                      ),
                    ),
                    style: TextStyle(color: customColors.textColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: widget.type == 'Channel'
                    ? 'Describe the channel'
                    : 'Describe the group',
                hintStyle:
                    TextStyle(color: customColors.textColor.withOpacity(0.6)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: customColors.customBlue),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: customColors.customGrey),
                ),
              ),
              style: TextStyle(color: customColors.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondCard(CustomColorScheme customColors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Plan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: customColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: customColors.iconColor),
                const SizedBox(width: 8),
                Text('Period:',
                    style: TextStyle(color: customColors.textColor)),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _validity,
                  dropdownColor: customColors.customGrey,
                  items:
                      ['One Day', 'One Week', 'One Month'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(color: customColors.textColor)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _validity = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.attach_money, color: customColors.iconColor),
                const SizedBox(width: 8),
                Text('Price:', style: TextStyle(color: customColors.textColor)),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _ppu = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Price (10 - 10000)',
                      hintStyle: TextStyle(
                          color: customColors.textColor.withOpacity(0.6)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customColors.customBlue),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customColors.customGrey),
                      ),
                    ),
                    style: TextStyle(color: customColors.textColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
Future<void> _getPhoto() async {
    try {
      // Directly open the gallery to pick an image
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _base64Image = base64Encode(bytes); // Convert image to base64
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo selected successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image was selected.')),
        );
      }
    } catch (e) {
      // Handle any errors that may occur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while picking the image.')),
      );
    }
  }

  void _createRequest() {
    if (_ppu.isEmpty ||
        _nameController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields except the image are mandatory.')),
      );
      return;
    }

    final request = {
      'ppu': _ppu,
      'channelName': _nameController.text,
      'displayText': _descriptionController.text,
      'image': _base64Image, // Add the base64 image to the request
      'type': 'Telegram',
      'ctype': widget.type == 'Channel',
      'validity': _validity.toLowerCase().replaceFirst('one ', ''),
    };

    // Dummy API call
    print('Request Data: $request');
    // Here you could make an actual API call with the request object.
  }
}
