import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/screens/bankform.dart';
import 'package:telemoni/utils/api_service.dart';
import 'package:telemoni/utils/themeprovider.dart';

class Banking extends StatefulWidget {
  const Banking({Key? key}) : super(key: key);

  @override
  _BankingState createState() => _BankingState();
}

class _BankingState extends State<Banking> {
  List<BankDetails> bankList = [];
  bool isLoading = true;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchBankAccounts();
  }

  Future<void> _fetchBankAccounts() async {
    try {
      List<BankDetails> banks = await apiService.getBankAccounts();
      setState(() {
        bankList = banks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bank accounts: $e')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final customColors = themeProvider.customColors;

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
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...bankList
                    .map((bank) =>
                        _buildBankCard(bank, customColors, themeProvider))
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
                  onPressed: bankList.length >= 2
                      ? null // Disable button if 2 or more banks exist
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BankFormPage(),
                            ),
                          );
                        },
                ),
                if (bankList.length >= 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Maximum 2 bank accounts allowed. Delete an account to add a new one.',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
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
                    onPressed: () async {
                      if (bank.textId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Cannot delete bank account: ID is null.')),
                        );
                        return;
                      }

                      // Show confirmation dialog
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete this bank account?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        // Call the delete API from the ApiService instance
                        try {
                          final response = await ApiService().deleteBankAccount(
                              bank.textId!); // Ensure textId is not null
                          print(bank.textId);
                          if (response.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Bank account deleted successfully.')),
                            );
                            setState(() {
                              _fetchBankAccounts();
                            });
                            // Optionally, you can refresh the list or call setState if necessary
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to delete bank account: ${response.message}')),
                            );
                            setState(() {
                              _fetchBankAccounts();
                            });
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('An error occurred: $error')),
                          );
                        }
                      }
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
