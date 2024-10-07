import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen's height and width to calculate card dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final cardHeight = screenHeight * 0.22;
    final cardWidth = screenWidth * 0.92;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product to get started'),
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
              () {
                // Action to perform on tap for Telegram card
                print('Telegram Channel card clicked');
              },
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
                print('Zoom Webinar card clicked');
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
                print('Locked Messages card clicked');
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
