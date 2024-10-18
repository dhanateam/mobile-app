import 'package:flutter/material.dart';

class PanNumberInput extends StatefulWidget {
  @override
  _PanNumberInputState createState() => _PanNumberInputState();
}

class _PanNumberInputState extends State<PanNumberInput> {
  TextEditingController _controller = TextEditingController();
  TextInputType _currentKeyboardType = TextInputType.text;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Switch to number keyboard when text length is between 6 and 9
      if (_controller.text.length >= 6 && _controller.text.length <= 9) {
        _currentKeyboardType = TextInputType.number;
      } else {
        // Switch back to text keyboard in other cases
        _currentKeyboardType = TextInputType.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAN Number Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          keyboardType: _currentKeyboardType,
          maxLength: 10, // Assuming PAN number length is 10 characters
          decoration: InputDecoration(
            labelText: 'Enter PAN Number',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}



