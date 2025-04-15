import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:total_energies/core/constant/colors.dart';

class Custotpfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool showAsterisk;

  const Custotpfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.showAsterisk = false,
  });

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
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: inputTextColor),
        decoration: InputDecoration(
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
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: primaryColor)
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
