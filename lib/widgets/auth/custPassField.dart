import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class CustPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showAsterisk;

  const CustPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.showAsterisk = false,
  });

  @override
  _CustPasswordFieldState createState() => _CustPasswordFieldState();
}

class _CustPasswordFieldState extends State<CustPasswordField> {
  bool _isObscured = true;
  String _password = '';

  bool get _hasMinLength => _password.length >= 6;
  bool get _hasUppercase => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _password.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _password.contains(RegExp(r'[0-9]'));

  Widget _buildCheckItem(bool condition, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            condition ? Icons.check_circle : Icons.cancel,
            color: condition ? Colors.green : Colors.red,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: inputTextColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          onChanged: (val) {
            setState(() {
              _password = val;
            });
          },
          decoration: InputDecoration(
            label:
                widget.showAsterisk ? formattedLabel : Text(widget.labelText),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: inputTextColor),
            labelStyle: TextStyle(color: inputTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: txtfieldborderColor, width: 1.0),
            ),
            prefixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
          validator: widget.validator,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCheckItem(_hasMinLength, "More than 6 characters"),
              _buildCheckItem(_hasUppercase, "Contains uppercase letter"),
              _buildCheckItem(_hasLowercase, "Contains lowercase letter"),
              _buildCheckItem(_hasNumber, "Contains number"),
            ],
          ),
        ),
      ],
    );
  }

  Widget get formattedLabel {
    return RichText(
      text: TextSpan(
        text: widget.labelText,
        style: TextStyle(color: inputTextColor, fontSize: 16),
        children: widget.showAsterisk
            ? [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
            : [],
      ),
    );
  }
}
