import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/screens/addproduct.dart';
import 'package:telemoni/screens/getverified.dart';
import 'package:telemoni/screens/products.dart';
import 'package:telemoni/screens/profile.dart';
import 'package:telemoni/utils/themeprovider.dart';

class MainPageContent extends StatefulWidget {
  const MainPageContent(
      {super.key});

  

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  int _selectedIndex = 0;

  // List of screens for navigation
  final List<Widget> _pages = [
    const VerificationScreen(),
    const AddProductPage(),
     const ProductsPage(),
    const ProfilePage(),  ];

  // Function to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Telemoni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
 onPressed: () {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();},
                  tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: iconColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: iconColor),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory, color: iconColor),
            label: 'My Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: iconColor),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 111, 63, 193),
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor:
            iconColor, // Ensure unselected icon color matches the theme
        selectedLabelStyle: TextStyle(color: labelColor),
        unselectedLabelStyle: TextStyle(color: labelColor),
      ),
    );
  }
}
