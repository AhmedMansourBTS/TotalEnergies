import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:total_energies/core/constant/colors.dart';

class Custtxtfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon; // Optional suffix icon
  final bool showAsterisk;
  final List<TextInputFormatter>? inputFormatters;

  const Custtxtfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text, // Default to text input
    this.validator,
    this.prefixIcon,
    this.suffixIcon, // Optional validation function
    this.showAsterisk = false,
    this.inputFormatters,
  });

  // Getter for formatted label with optional asterisk
  Widget get formattedLabel {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: TextStyle(color: inputTextColor, fontSize: 16),
        children: showAsterisk
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: inputTextColor),
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          // labelText: labelText,
          label: showAsterisk ? formattedLabel : Text(labelText),
          labelStyle: TextStyle(color: inputTextColor),
          hintText: hintText,
          hintStyle: TextStyle(color: inputTextColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: txtfieldborderColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: txtfieldborderColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: primaryColor)
              : null, // Add prefix icon if provided
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: primaryColor)
              : null, // Add suffix icon if provided
        ),
        validator: validator, // Use the validation function if provided
      ),
    );
  }
}
