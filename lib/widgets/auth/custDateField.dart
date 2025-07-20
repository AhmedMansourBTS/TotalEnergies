import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:intl/intl.dart';

class CustDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String? Function(String?)? validator;

  const CustDatePickerField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.dateFrom,
    required this.dateTo,
    this.validator,
  });

  @override
  _CustDatePickerFieldState createState() => _CustDatePickerFieldState();
}

class _CustDatePickerFieldState extends State<CustDatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.dateTo,
      firstDate: widget.dateFrom,
      lastDate: widget.dateTo,
    );

    _updateDateInField(pickedDate!);
  }

  void _updateDateInField(DateTime date) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    widget.controller.text = formattedDate;
  }

  void _parseAndFormatText(String input) {
    try {
      List<String> parts = input.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);

        DateTime enteredDate = DateTime(year, month, day);
        if (enteredDate.isAfter(widget.dateFrom.subtract(Duration(days: 1))) &&
            enteredDate.isBefore(widget.dateTo.add(Duration(days: 1)))) {
          _updateDateInField(enteredDate); // Valid range, format
        }
      }
    } catch (e) {
      // Ignore or show error if needed
    }
  }

  Widget get formattedLabel => RichText(
        text: TextSpan(
          text: widget.labelText,
          style: TextStyle(color: Colors.black, fontSize: 16),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: widget.controller,
        style: TextStyle(color: inputTextColor),
        keyboardType: TextInputType.datetime,
        onChanged: (val) => _parseAndFormatText(val),
        decoration: InputDecoration(
          label: formattedLabel,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: inputTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: txtfieldborderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: txtfieldborderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          prefixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: primaryColor),
            onPressed: () => _selectDate(context),
          ),
        ),
        validator: widget.validator,
        readOnly: false, // ✅ Allow text entry
        onTap: () {}, // ❌ Disable picker on full field tap
      ),
    );
  }
}
