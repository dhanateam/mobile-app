import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart'; // Add the share_plus package
import 'package:flutter/services.dart';
import 'package:telemoni/models/product.dart';
import 'package:telemoni/utils/themeprovider.dart'; // Import for Clipboard

class AboutProductWidget extends StatelessWidget {
  final Product product;

  const AboutProductWidget({super.key, required this.product});

  @override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final customColors = themeProvider.customColors;

  return DefaultTabController(
    length: 2, // Number of tabs
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: TextStyle(color: customColors.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: customColors.textColor),
            onPressed: () {
              // Add your edit functionality here
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Using the seed color from ThemeData
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                _buildAboutSection(context),
                // Conditional rendering for the dashboard based on product status
                if (product.status == 'active')
                  _buildDashboardSection(context)
                else if (product.status == 'inactive')
                  _buildInactiveSection(context,)
                else
                  Center(child: Text('Dashboard not available')),
              ],
            ),
          ),
          Material(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: TabBar(
              labelColor: customColors.textColor,
              unselectedLabelColor: customColors.textColor.withOpacity(0.6),
              tabs: const [
                Tab(text: "About"),
                Tab(text: "Dashboard"),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInactiveSection(BuildContext context) {
  return Center(
    child: Text(
      'This product is no longer available.',
      style: TextStyle(
        //color: customColors.textColor,
        fontSize: MediaQuery.of(context).size.width * 0.05,
      ),
    ),
  );
}
  Widget _buildAboutSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final String typeDisplayText;

    // Determine type and channel info
    if (product.type == 'telegram' && product.channel != null) {
      typeDisplayText =
          product.channel! ? 'Telegram Channel' : 'Telegram Group';
    } else if (product.type == 'zoom') {
      typeDisplayText = 'Zoom Meeting';
    } else {
      typeDisplayText = 'Locked Message';
    }

    return Column(
      children: [
        // Top Section (Seed color background)
        Container(
          width: double.infinity,
          color: themeProvider
              .themeData.colorScheme.inversePrimary, // Seed color as background
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Avatar and Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height *
                        0.06, // Dynamic size
                    backgroundColor: customColors.customBlue,
                    child: Text(
                      product.name[0].toUpperCase(),
                      style: TextStyle(
                        color: customColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width *
                            0.06, // Dynamic font size
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Text(
                    product.name,
                    style: TextStyle(
                      color: customColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width *
                          0.05, // Dynamic font size
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Image and Type Information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    getImageAsset(product.type), // Image based on type
                    height: MediaQuery.of(context).size.height * 0.035,
                    width: MediaQuery.of(context).size.height * 0.035,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    typeDisplayText,
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
        // Bottom Section (Default theme background)
        Container(
          width: double.infinity,
          color: themeProvider.themeData.colorScheme
              .background, // Default background (light/dark mode)
          padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.height * 0.03),
              (MediaQuery.of(context).size.height * 0.07),
              (MediaQuery.of(context).size.height * 0.02),
              (MediaQuery.of(context).size.height * 0.02)),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Row
              _buildStatusRow(context, customColors),
              Divider(color: customColors.textColor), // Separator line

              // About Section
              _buildAboutRow(context, product.about, customColors),
              Divider(color: customColors.textColor), // Separator line

              // Price Section
              _buildPriceRow(context, product.price , customColors),
              Divider(color: customColors.textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, CustomColorScheme customColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.radio_button_unchecked,
                color: customColors.iconColor), // Hollow icon
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Text(
              'Status:',
              style: TextStyle(color: customColors.textColor),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.005,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: _getStatusColor(product.status, context),
            ),
            color: _getStatusColor(product.status, context).withOpacity(0.1),
          ),
          child: Text(
            product.status,
            style: TextStyle(
              color: _getStatusColor(product.status, context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to get status color based on light/dark mode and status
  Color _getStatusColor(String status, BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    switch (status.toLowerCase()) {
      case 'active':
        return customColors.customGreen;
      case 'inactive':
        return customColors.customRed;
      case 'pending':
        return isDarkMode ? customColors.customYellow : customColors.customBlue;
      default:
        return Colors.grey; // Default color if status doesn't match any case
    }
  }

  Widget _buildAboutRow(
      BuildContext context, String about, CustomColorScheme customColors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: customColors.iconColor),
              SizedBox(width: 12.0),
              Text(
                'About',
                style: TextStyle(
                  color: customColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            about,
            style: TextStyle(color: customColors.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      BuildContext context, int price, CustomColorScheme customColors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on_outlined,
                  color: customColors.iconColor),
              SizedBox(width: 12.0),
              Text(
                'Price',
                style: TextStyle(
                  color: customColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: TextStyle(color: customColors.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final darkmode = themeProvider.isDarkMode;
    final String shareableLink = "telemoni.in/b/${product.link ?? 'link'}";
    final String typeDisplayText;

    // Determine type and channel info
    if (product.type == 'telegram' && product.channel != null) {
      typeDisplayText =
          product.channel! ? 'Telegram Channel' : 'Telegram Group';
    } else if (product.type == 'zoom') {
      typeDisplayText = 'Zoom Meeting';
    } else {
      typeDisplayText = 'Locked Message';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: themeProvider
              .themeData.colorScheme.inversePrimary, // Seed color as background
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Avatar and Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height *
                        0.06, // Dynamic size
                    backgroundColor: customColors.customBlue,
                    child: Text(
                      product.name[0].toUpperCase(),
                      style: TextStyle(
                        color: customColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width *
                            0.06, // Dynamic font size
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Text(
                    product.name,
                    style: TextStyle(
                      color: customColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width *
                          0.05, // Dynamic font size
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Image and Type Information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    getImageAsset(product.type), // Image based on type
                    height: MediaQuery.of(context).size.height * 0.035,
                    width: MediaQuery.of(context).size.height * 0.035,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    typeDisplayText,
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        // Shareable Link Card with Gradient Overlay
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.pinkAccent, // Base color of the card
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height * 0.2, // Adjust as needed
            ),
            // Gradient layer over the orange background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4), // Light black at the top
                    Colors.black.withOpacity(0.1), // Deeper black at the bottom
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height:
                  MediaQuery.of(context).size.height * 0.2, // Match the height
            ),
            // Content of the card
            Positioned.fill(
              child: Card(
                color:
                    Colors.transparent, // Make card transparent to see gradient
                elevation: 0,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First row for the shareable link with a light shade of orange
                      Container(
                        color: themeProvider.isDarkMode
                            ? Color.fromARGB(255, 188, 174, 174)
                            : Colors.orange[
                                100], // Light shade of orange for the link background
                        width: double.infinity,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        child: Text(
                          shareableLink,
                          style: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : customColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      // Second row for buttons (Copy and Share)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: shareableLink));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Link copied to clipboard"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.copy, color: customColors.iconColor),
                                const SizedBox(
                                    width:
                                        4), // Reduced space between icon and text
                                Text(
                                  "Copy",
                                  style:
                                      TextStyle(color: customColors.textColor),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share(shareableLink);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.share,
                                    color: customColors.iconColor),
                                const SizedBox(
                                    width:
                                        4), // Reduced space between icon and text
                                Text(
                                  "Share",
                                  style:
                                      TextStyle(color: customColors.textColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        // Active Subscribers Card
        Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.height * 0.02),
          child: Card(
            color: themeProvider.isDarkMode
                            ? Colors.red[900]! : Colors.redAccent, // Red color for subscribers card
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.04,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.04,
                  MediaQuery.of(context).size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Subscribers:",
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${product.subs}",
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        // Total Earnings Card
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Card(
            color: themeProvider.isDarkMode
                ? Colors.green[900]!: Colors.greenAccent, // Green color for earnings card
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.04,
                  MediaQuery.of(context).size.height * 0.02,
                  MediaQuery.of(context).size.width * 0.04,
                  MediaQuery.of(context).size.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Earnings:",
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${product.earning.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: customColors.textColor,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getImageAsset(String type) {
    switch (type) {
      case 'telegram':
        return 'assets/telegram.png'; // Adjust your asset path
      case 'zoom':
        return 'assets/zoom.png'; // Adjust your asset path
      case 'lock':
        return 'assets/lock.png'; // Adjust your asset path
      default:
        return 'assets/default.png'; // Default asset
    }
  }
}
