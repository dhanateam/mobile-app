import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/models/transaction.dart';
import 'package:telemoni/utils/api_service.dart';
import 'package:telemoni/utils/themeprovider.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  int? balance;
  bool req = false; // Determines if the withdraw button is active
  bool showTransactions = false;
  List<Transaction> transactions = [];
  final _formKey = GlobalKey<FormState>();
  String? _selectedBank;
  String? _accountNumber;
  String? _amount;
  bool _isApproved = false;
  final ApiService apiService = ApiService(); // Initialize ApiService

  @override
  void initState() {
    super.initState();
    fetchBalanceAndReqStatus();
  }

  // Fetches user balance and withdrawal request status
  void fetchBalanceAndReqStatus() async {
    setState(() {
      balance = 1000; // Example balance
      req = false; // Example condition: true disables the withdraw button
    });
  }

  // Fetches the user's transaction history
  void fetchTransactions() async {
    final history = await apiService.getWithdrawalHistory();
    setState(() {
      transactions = history;
    });
  }

  void refreshTransactions() {
    fetchTransactions();
    fetchBalanceAndReqStatus();
  }

  // Raises a withdrawal request if form is valid
  void raiseWithdrawal() async {
    if (_formKey.currentState!.validate() && _isApproved) {
      final selectedBank = await apiService.getBankAccounts().then((accounts) =>
          accounts.firstWhere((bank) => bank.bank == _selectedBank));
      var request = {
        'amount': _amount,
        'bank_id': selectedBank.textId,
      };
      try {
        // Call the API to create the product
        await apiService.raiseWithdrawal(request);
        Navigator.of(context).pop(); // Close form
        refreshTransactions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Withdrawal request submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit withdrawal request')),
        );
      }
    } else if (!_isApproved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please approve the transaction')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.colorScheme.inversePrimary,
        title: Text(
          'Withdrawal',
          style: TextStyle(color: customColors.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: customColors.iconColor),
            onPressed: refreshTransactions,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display available balance
            Card(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Balance:',
                      style: TextStyle(
                        color: customColors.textColor,
                        fontSize: screenHeight * 0.02,
                      ),
                    ),
                    Text(
                      '\$${balance ?? '...'}',
                      style: TextStyle(
                        color: customColors.textColor,
                        fontSize: screenHeight * 0.02,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Button to raise withdrawal
            ElevatedButton(
              onPressed: req
                  ? () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Pending Transaction',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                            content: Text(
                              'There is already a pending transaction.',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontSize: screenHeight * 0.02,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Dismiss alert
                                },
                              ),
                            ],
                          );
                        },
                      )
                  : () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Complete the Form'),
                            content: FutureBuilder<List<BankDetails>>(
                              future: apiService.getBankAccounts(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Text(
                                      'No bank accounts available.');
                                } else {
                                  final bankAccounts = snapshot.data!;
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                  labelText: 'Select Bank'),
                                              items: bankAccounts
                                                  .map((BankDetails bank) {
                                                return DropdownMenuItem<String>(
                                                  value: bank.bank,
                                                  child: Text(bank.bank),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedBank = newValue;
                                                  _accountNumber = bankAccounts
                                                      .firstWhere((bank) =>
                                                          bank.bank == newValue)
                                                      .acno;
                                                });
                                              },
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select a bank';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: 'Account Number'),
                                              readOnly: true,
                                              controller: TextEditingController(
                                                  text: _accountNumber),
                                            ),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: 'Amount'),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              onChanged: (value) {
                                                _amount = value;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    int.tryParse(value) ==
                                                        null ||
                                                    int.parse(value) <= 0) {
                                                  return 'Please enter a valid amount';
                                                }
                                                return null;
                                              },
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: _isApproved,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      _isApproved =
                                                          value ?? false;
                                                    });
                                                  },
                                                ),
                                                const Expanded(
                                                  child: Text(
                                                    "*I checked the account number and I approve the transaction",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Done'),
                                onPressed: raiseWithdrawal,
                              ),
                            ],
                          );
                        },
                      ),
              child: Text(
                'Raise Withdrawal',
                style: TextStyle(
                  color: customColors.textColor,
                  fontSize: screenHeight * 0.02,
                ),
              ),
            ),
            // Toggle for viewing withdrawal history
            OutlinedButton(
              onPressed: () {
                setState(() {
                  showTransactions = !showTransactions;
                  if (showTransactions && transactions.isEmpty) {
                    fetchTransactions();
                  }
                });
              },
              child: Text(
                'Withdrawal History',
                style: TextStyle(
                  color: customColors.textColor,
                  fontSize: screenHeight * 0.02,
                ),
              ),
            ),
            if (showTransactions)
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaction ID: 1',//${transaction.id}',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.018,
                              ),
                            ),
                            Text(
                              'Amount: \$${transaction.amount}',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontSize: screenHeight * 0.016,
                              ),
                            ),
                            Text(
                              'Status: ${transaction.status}',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontSize: screenHeight * 0.016,
                              ),
                            ),
                            Text(
                              'Date: ${transaction.date}',
                              style: TextStyle(
                                color: customColors.textColor,
                                fontSize: screenHeight * 0.016,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
