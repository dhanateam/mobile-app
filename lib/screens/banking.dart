import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/screens/bankform.dart';
import 'package:telemoni/utils/themeprovider.dart';

class Banking extends StatelessWidget {
  const Banking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    List<BankDetails> bankList = [
      BankDetails(
          bank: 'ABC Bank',
          bankingName: 'Ranku ABC',
          acno: '1234567890',
          textId: 'ask898GJ',
          ifsc: 'ABCD1234'),
      BankDetails(
          bank: 'XYZ Bank',
          bankingName: 'Ranku XYZ',
          textId: 'ask8478GJ',
          acno: '0987654321',
          ifsc: 'XYZD5678'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.colorScheme.inversePrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: customColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Banking',
          style: TextStyle(color: customColors.textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...bankList
                .map(
                    (bank) => _buildBankCard(bank, customColors, themeProvider))
                .toList(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.add, color: customColors.textColor),
              label: Text('Add Bank',
                  style: TextStyle(color: customColors.textColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.green[900]
                    : Colors.greenAccent,
              ),
              onPressed: () {
                // Navigate to the BankFormPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BankFormPage(), // Navigate to form page
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(BankDetails bank, CustomColorScheme customColors,
      ThemeProvider themeProvider) {
    return Card(
      elevation: 4,
      shadowColor: customColors.shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(bank.bank, style: TextStyle(color: customColors.textColor)),
        trailing: Icon(Icons.arrow_drop_down, color: customColors.iconColor),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bank: ${bank.bank}',
                    style: TextStyle(color: customColors.textColor)),
                Text('Name: ${bank.bankingName}',
                    style: TextStyle(color: customColors.textColor)),
                Text('Ac No: ${bank.acno}',
                    style: TextStyle(color: customColors.textColor)),
                Text('IFSC: ${bank.ifsc}',
                    style: TextStyle(color: customColors.textColor)),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: customColors.customRed),
                    onPressed: () {
                      print('Deleted bank textId: ${bank.textId}');
                      // Add delete functionality if needed
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
