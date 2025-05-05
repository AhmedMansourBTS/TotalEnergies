// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class CustDatePickerField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   // final String label;
//   final String hintText;
//   final DateTime dateFrom; // ✅ Minimum date
//   final DateTime dateTo; // ✅ Maximum date
//   final String? Function(String?)? validator;

//   const CustDatePickerField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     // required this.label,
//     required this.hintText,
//     required this.dateFrom,
//     required this.dateTo,
//     this.validator,
//   });

//   @override
//   _CustDatePickerFieldState createState() => _CustDatePickerFieldState();
// }

// class _CustDatePickerFieldState extends State<CustDatePickerField> {
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: widget.dateFrom,
//       firstDate: widget.dateFrom,
//       lastDate: widget.dateTo,
//     );

//     if (pickedDate != null) {
//       final formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
//           "${pickedDate.month.toString().padLeft(2, '0')}/"
//           "${pickedDate.year}";
//       setState(() {
//         widget.controller.text = formattedDate;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 12),
//       child: TextFormField(
//         controller: widget.controller,
//         readOnly: true, // Prevent manual input
//         style: TextStyle(color: inputTextColor), // Toggle password visibility

//         decoration: InputDecoration(
//           // labelText: widget.labelText,
//           label: RichText(
//             text: TextSpan(
//               text: widget.labelText, // Translated label
//               style: TextStyle(
//                   color: Colors.black, fontSize: 16), // Default label color
//               children: [
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red, fontSize: 16), // Red *
//                 ),
//               ],
//             ),
//           ),
//           labelStyle: TextStyle(color: inputTextColor),
//           hintText: widget.hintText,
//           hintStyle: TextStyle(color: inputTextColor),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: txtfieldborderColor, width: 1.0),
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: txtfieldborderColor, width: 1.0),
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//                 color: Colors.green, width: 2.0), // Change focus border color
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           prefixIcon: IconButton(
//             icon: Icon(
//               Icons.calendar_today,
//               color: primaryColor,
//             ),
//             onPressed: () => _selectDate(context), // Open date picker
//           ),
//         ),
//         validator: widget.validator,
//         onTap: () =>
//             _selectDate(context), // Open date picker when tapping the field
//       ),
//     );
//   }
// }

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
      initialDate: widget.dateFrom,
      firstDate: widget.dateFrom,
      lastDate: widget.dateTo,
    );

    if (pickedDate != null) {
      _updateDateInField(pickedDate);
    }
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
