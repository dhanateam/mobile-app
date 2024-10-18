import 'package:flutter/material.dart';
import 'package:telemoni/screens/createchannel.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen's height and width to calculate card dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final cardHeight = screenHeight * 0.22;
    final cardWidth = screenWidth * 0.92;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product to get started',
          style: TextStyle(
            fontSize: 16 * MediaQuery.of(context).textScaleFactor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCard(
              context,
              cardHeight,
              cardWidth,
              'Launch a Telegram Channel',
              Colors.blueAccent.shade100, // Telegram-themed background color
              'assets/telegram.png', // Update with your asset path
              () => _showTelegramOptions(context),
            ),
            SizedBox(height: screenHeight * 0.02), // Space between cards
            buildCard(
              context,
              cardHeight,
              cardWidth,
              'Launch a Zoom Webinar',
              Colors.orangeAccent.shade100, // Zoom-themed background color
              'assets/zoom.png', // Update with your asset path
              () {
                // Action to perform on tap for Zoom card
              },
            ),
            SizedBox(height: screenHeight * 0.02), // Space between cards
            buildCard(
              context,
              cardHeight,
              cardWidth,
              'Create Locked Messages',
              Colors.greenAccent
                  .shade100, // Locked message-themed background color
              'assets/lock.png', // Update with your asset path
              () {
                // Action to perform on tap for Locked Messages card
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a card widget with specified properties and onClick functionality
  Widget buildCard(
      BuildContext context,
      double height,
      double width,
      String text,
      Color backgroundColor,
      String imagePath,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(
            width * 0.04), // Adjust padding relative to card width
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: width * 0.05, // Font size relative to screen width
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color explicitly set to black
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: width * 0.04), // Padding to the right side
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  height: height * 0.5, // Image size relative to card height
                  width: height * 0.5, // Ensuring the image remains circular
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
void _showTelegramOptions(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select the Type'),
        content: const Text('Please choose an option:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateChannelPage(type: 'Channel'),
                ),
              );
            },
            child: const Text('Telegram Channel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateChannelPage(type: 'Group'),
                ),
              );
            },
            child: const Text('Telegram Group'),
          ),
        ],
      );
    },
  );
}
