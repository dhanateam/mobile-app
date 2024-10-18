import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/models/transaction.dart';
import 'package:telemoni/utils/themeprovider.dart';

List<BankDetails> getBankAccounts() {
  return [
    BankDetails(
        bank: 'Bank A',
        bankingName: 'Bank A Name',
        acno: '1234567890',
        ifsc: 'IFSC0001',
        textId: '1'),
    BankDetails(
        bank: 'Bank B',
        bankingName: 'Bank B Name',
        acno: '0987654321',
        ifsc: 'IFSC0002',
        textId: '2'),
  ];
}

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

  @override
  void initState() {
    super.initState();
    fetchBalanceAndReqStatus();
  }

  void fetchBalanceAndReqStatus() {
    // Simulate API call to get balance and req status
    setState(() {
      balance = 1000; // Example balance
      req = false; // Example condition: true disables the withdraw button
    });
  }

  void fetchTransactions() {
    // Simulate API call to fetch transaction list
    transactions = List.generate(
      5,
      (index) => Transaction(
        status: index % 2 == 0 ? 'Completed' : 'Pending',
        amount: 100 + index * 10,
        date: DateTime.now().subtract(Duration(days: index)),
        bankName: 'Bank ${index + 1}',
        transactionId: 'TXN${index + 1001}',
      ),
    );
  }

  void refreshTransactions() {
    setState(() {
      fetchTransactions();
    });
    fetchBalanceAndReqStatus();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final customColors = themeProvider.customColors;
    final isdark = themeProvider.isDarkMode;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.colorScheme.inversePrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: customColors.iconColor),
          onPressed: () => Navigator.pop(context),
        ),
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
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                final List<BankDetails> bankAccounts =
                                    getBankAccounts();
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Dropdown for selecting bank
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

                                      // Non-editable field for account number
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Account Number'),
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: _accountNumber),
                                      ),

                                      // Amount field
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Amount'),
                                        keyboardType: TextInputType.number,
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
                                              int.tryParse(value) == null ||
                                              int.parse(value) <= 0) {
                                            return 'Please enter a valid amount';
                                          }
                                          return null;
                                        },
                                      ),

                                      // Checkbox for approval
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _isApproved,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _isApproved = value ?? false;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              "*I checked the account number and I approve the transaction",
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.015,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Done'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      _isApproved) {
                                    final selectedBank = getBankAccounts()
                                        .firstWhere((bank) =>
                                            bank.bank == _selectedBank);
                                    final transaction = {
                                      'bank_id': selectedBank.textId,
                                      'amount': _amount,
                                    };
                                    print(
                                        'Transaction: $transaction'); // Replace with actual submission logic
                                    Navigator.of(context).pop(); // Close form
                                  } else if (!_isApproved) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please approve the transaction')),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: req
                    ? customColors.customGreen.withOpacity(0.1)
                    : customColors.customGreen,
              ),
              child: Text(
                'Raise Withdrawal',
                style: TextStyle(
                  color: isdark ? Colors.green[900]! : Colors.greenAccent,
                  fontSize: screenHeight * 0.02,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
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
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  transaction.status == 'Completed'
                      ? Icons.check_circle
                      : Icons.pending,
                  color: transaction.status == 'Completed'
                      ? Colors.green
                      : Colors.orange,
                ),
                Text('\$${transaction.amount}'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${transaction.date.toLocal().toString().split(' ')[0]}',
            ),
            Text(
                'Time: ${transaction.date.toLocal().toString().split(' ')[1]}'),
            Text('Bank: ${transaction.bankName}'),
            Text('Transaction ID: ${transaction.transactionId}'),
          ],
        ),
      ),
    );
  }
,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
