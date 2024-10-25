import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telemoni/models/bank.dart';
import 'package:telemoni/screens/banking.dart';
import 'package:telemoni/utils/api_service.dart';
import 'package:telemoni/utils/themeprovider.dart';

class BankFormPage extends StatefulWidget {
  const BankFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BankFormPageState createState() => _BankFormPageState();
}

class _BankFormPageState extends State<BankFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? bankName;
  String? bankingName;
  String? accountNumber;
  String? reenteredAccountNumber;
  String? ifsc;
  String errorMessage = '';
  bool showFieldError = false;
  bool _isAccountNumberVisible = false; // State variable for visibility
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final customColors = themeProvider.customColors;
    final divheight = MediaQuery.of(context).size.height * 0.02;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add Bank', style: TextStyle(color: customColors.textColor)),
        backgroundColor: themeProvider.themeData.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  'Bank',
                  'Enter bank name',
                  false,
                  (value) => bankName = value,
                  mediaQuery,
                  isFieldEmpty: bankName == null || bankName!.isEmpty,
                ),
                SizedBox(
                  height: divheight,
                ),
                _buildTextField(
                  'Account Holder Name',
                  'Name of the Account',
                  false,
                  (value) => bankingName = value,
                  mediaQuery,
                  isFieldEmpty: bankingName == null || bankingName!.isEmpty,
                ),
                SizedBox(
                  height: divheight,
                ),
                _buildTextField(
                  'Account Number',
                  'Enter account number',
                  true,
                  (value) => accountNumber = value,
                  mediaQuery,
                  obscureText:
                      !_isAccountNumberVisible, // Use the visibility state
                  isFieldEmpty: accountNumber == null || accountNumber!.isEmpty,
                  toggleVisibility: () {
                    setState(() {
                      _isAccountNumberVisible =
                          !_isAccountNumberVisible; // Toggle visibility
                    });
                  },
                  isPasswordField: true, // Mark as a password field
                ),
                SizedBox(
                  height: divheight,
                ),
                _buildTextField(
                  'Re-enter Account Number',
                  'Re-enter account number',
                  true,
                  (value) => reenteredAccountNumber = value,
                  mediaQuery,
                 // Use the visibility state
                  isFieldEmpty: reenteredAccountNumber == null ||
                      reenteredAccountNumber!.isEmpty,
                  toggleVisibility: () {
                    
                  },
                ),
                SizedBox(
                  height: divheight,
                ),
                _buildTextField(
                  'IFSC Code',
                  'Enter IFSC code',
                  false,
                  (value) => ifsc = value,
                  mediaQuery,
                  isFieldEmpty: ifsc == null || ifsc!.isEmpty,
                ),
                const SizedBox(height: 20),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.green[900]!.withOpacity(0.1)
                          : Colors.greenAccent.withOpacity(0.1),
                      side: BorderSide(
                        color: themeProvider.isDarkMode
                            ? Colors.green[900]!
                            : Colors.greenAccent,
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: themeProvider.isDarkMode
                            ? Colors.green[900]
                            : Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height *.5,)
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildTextField(
  String label,
  String hint,
  bool? keyboard,
  Function(String) onChanged,
  MediaQueryData mediaQuery, {
  bool obscureText = false,
  bool isFieldEmpty = false,
  bool isPasswordField = false,
  VoidCallback? toggleVisibility,
}) {
  return TextFormField(
    keyboardType: keyboard == true ? TextInputType.number : TextInputType.text, // Set input type based on `keyboard` value
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: showFieldError && isFieldEmpty ? Colors.red : null,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showFieldError && isFieldEmpty ? Colors.red : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: showFieldError && isFieldEmpty ? Colors.red : Colors.blue,
        ),
      ),
      suffixIcon: isPasswordField
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleVisibility,
            )
          : null, // Show the eye icon only for password fields
    ),
    onChanged: onChanged,
    obscureText: obscureText,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'This field cannot be empty';
      }
      return null;
    },
  );
}

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (accountNumber != reenteredAccountNumber) {
        setState(() {
          errorMessage = 'Account numbers do not match.';
          showFieldError = true;
        });
      } else {
        // Here you can process your data, e.g., save it to a list or database
        print(
            'Bank details submitted: $bankName, $bankingName, $accountNumber, $ifsc');
        var bank = {
            "bank": bankName!,
            "bankingname": bankingName!,
            "acno": accountNumber!,
            "ifsc": ifsc!,};
        print(bank);
        try {
          await apiService.submitBankDetails(bank);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form Submitted Successfully!')),
          );Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(
                          builder: (context) => Banking(),
                        ),);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text( '$e')),
          );
        }
      }
    } else {
      setState(() {
        showFieldError = true;
      });
    }
  }
}
