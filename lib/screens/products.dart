import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/product.dart';
import 'package:telemoni/screens/aboutproduct.dart';
import 'package:telemoni/utils/themeprovider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // List of dummy products
  final List<Product> products = [
    Product(
        productId: 1,
        about: 'About Product 1',
        earning: 100.0,
        subs: 50,
        status: 'pending',
        type: 'telegram',
        name: 'Telegram Service',
        link:"asdfa",
        price: 600),
    Product(
        productId: 2,
        about: 'About Product 2',
        earning: 200.0,
        subs: 30,
        status: 'active',
        type: 'zoom',
        link:'asLKJOEIH',
        name: 'Zoom Meeting',
        price: 600),
    Product(
        productId: 3,
        about: 'About Product 3',
        earning: 300.0,
        subs: 20,
        status: 'inactive',
        type: 'message',
        link:'LJPOwerjds',
        name: 'Locked Messages',
        price: 600),
    Product(
        productId: 4,
        about: 'About Product 4',
        earning: 150.0,
        subs: 40,
        status: 'active',
        type: 'telegram',
        link:'TVFYlaksdf',
        name: 'Telegram Chat',
        price: 600),
    Product(
        productId: 5,
        about: 'About Product 5',
        earning: 50.0,
        subs: 10,
        status: 'pending',
        type: 'zoom',
        link:"aldsjfoia",
        name: 'Zoom Webinar',
        price: 600),
  ];

  // Method to get the correct image asset based on the product type
  String getImageAsset(String type) {
    switch (type) {
      case 'telegram':
        return 'assets/telegram.png';
      case 'zoom':
        return 'assets/zoom.png';
      case 'message':
        return 'assets/lock.png';
      default:
        return 'assets/profile.png';
    }
  }

  // Method to get a random color for the avatar background
  Color getRandomColor(CustomColorScheme colors) {
    final List<Color> possibleColors = [
      colors.customRed,
      colors.customGreen,
      colors.customGrey,
    ];
    return possibleColors[Random().nextInt(possibleColors.length)];
  }

  // Method to handle card tap
  void onCardTap(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutProductWidget(product: product),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ThemeProvider>(context).customColors;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Page'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final backgroundColor = getRandomColor(colors);

          return GestureDetector(
            onTap: () => onCardTap(product),
            child: Card(
              margin: EdgeInsets.symmetric(
                horizontal:
                    screenWidth * 0.04, // Increased margin for left and right
                vertical: screenHeight * 0.01,
              ),
              child: SizedBox(
                height: screenHeight * 0.146,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Add padding for the circular avatar container
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.03), // Added left padding
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: screenWidth * 0.03),
                            child: Container(
                              width: screenHeight * 0.08, // 2 * radius
                              height: screenHeight * 0.08, // 2 * radius
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors
                                      .textColor, // Your desired border color
                                  width: 1.0, // Border width
                                ),
                              ),
                              child: CircleAvatar(
                                radius: screenHeight * 0.04,
                                backgroundColor: backgroundColor,
                                child: Text(
                                  product.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: colors.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1 * screenHeight * 0.0015,
                            child: Image.asset(
                              getImageAsset(product.type),
                              height: screenHeight * 0.035,
                              width: screenHeight * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    // Product name
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Product status
                    Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.05),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.005,
                        horizontal: screenWidth * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusBackgroundColor(product.status, colors),
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        border: Border.all(
                          color: getStatusBorderColor(product.status, colors),
                        ),
                      ),
                      child: Text(
                        product.status,
                        style: TextStyle(
                          color: getStatusTextColor(product.status, colors),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color getStatusBackgroundColor(String status, CustomColorScheme colors) {
    switch (status) {
      case 'pending':
        return Provider.of<ThemeProvider>(context, listen: false).isDarkMode
            ? colors.customYellow.withOpacity(0.1)
            : colors.customBlue.withOpacity(0.1);
      case 'active':
        return colors.customGreen.withOpacity(0.1);
      case 'inactive':
        return colors.customRed.withOpacity(0.1);
      default:
        return colors.customGrey;
    }
  }

  Color getStatusTextColor(String status, CustomColorScheme colors) {
    switch (status) {
      case 'pending':
        return Provider.of<ThemeProvider>(context, listen: false).isDarkMode
            ? colors.customYellow
            : colors.customBlue;
      case 'active':
        return colors.customGreen;
      case 'inactive':
        return colors.customRed;
      default:
        return colors.textColor;
    }
  }

  Color getStatusBorderColor(String status, CustomColorScheme colors) {
    switch (status) {
      case 'pending':
        return Provider.of<ThemeProvider>(context, listen: false).isDarkMode
            ? colors.customYellow
            : colors.customBlue;
      case 'active':
        return colors.customGreen;
      case 'inactive':
        return colors.customRed;
      default:
        return colors.customGrey;
    }
  }
}
