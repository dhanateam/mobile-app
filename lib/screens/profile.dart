import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/utils/themeprovider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Access custom colors from ThemeProvider
    final customColors = Provider.of<ThemeProvider>(context).customColors;

    // Scaling factors
    double paddingScale = screenWidth * 0.04;
    double avatarRadius = screenWidth * 0.1;
    double fontSize = screenWidth * 0.045;
    double cardElevation = screenWidth * 0.01;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(paddingScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First card with profile picture and greeting
            Card(
              elevation: cardElevation,
              shadowColor: customColors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(paddingScale),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundImage: const AssetImage(
 'assets/profile.png'),                    ),
                    SizedBox(width: paddingScale),
                    Text(
                      'Hello, Ranku',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: customColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: paddingScale),

            // Second card with Wallet and Earnings
            Card(
              elevation: cardElevation,
              shadowColor: customColors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingScale,
                  horizontal: paddingScale / 2,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: customColors.iconColor,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: customColors.textColor,
                        ),
                      ),
                      onTap: () {
                        // Handle Wallet tap
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.attach_money,
                        color: customColors.iconColor,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        'Earnings',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: customColors.textColor,
                        ),
                      ),
                      onTap: () {
                        // Handle Earnings tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: paddingScale),

            // Third card with Dashboard, Settings, and Logout
            Card(
              elevation: cardElevation,
              shadowColor: customColors.shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingScale,
                  horizontal: paddingScale / 2,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.dashboard,
                        color: customColors.iconColor,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: customColors.textColor,
                        ),
                      ),
                      onTap: () {
                        // Navigate to Dashboard
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: customColors.iconColor,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: customColors.textColor,
                        ),
                      ),
                      onTap: () {
                        // Navigate to Settings
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: customColors.iconColor,
                        size: screenWidth * 0.07,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: customColors.textColor,
                        ),
                      ),
                      onTap: () {
                        // Handle Logout functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
