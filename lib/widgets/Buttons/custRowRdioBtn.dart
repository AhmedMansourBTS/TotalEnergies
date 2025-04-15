import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class Custrowrdiobtn extends FormField<String> {
  Custrowrdiobtn({
    super.key,
    required TextEditingController controller,
    required String labelText,
    required List<String> options,
    super.validator,
    bool showAsterisk = false,
  }) : super(
          builder: (FormFieldState<String> state) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(labelText,
                  //     style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: inputTextColor)),
                  RichText(
                    text: TextSpan(
                      text: labelText,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: inputTextColor),
                      children: showAsterisk
                          ? [
                              TextSpan(
                                text: ' *',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ]
                          : [],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: state.hasError
                              ? Colors.red
                              : Colors.black), // ✅ Show error border
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: options.map((option) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: option,
                              groupValue: state.value,
                              onChanged: (String? value) {
                                state.didChange(value); // ✅ Update state value
                                controller.text =
                                    value ?? ""; // ✅ Update controller
                              },
                            ),
                            Text(
                              option,
                              style: TextStyle(color: inputTextColor),
                            ),
                            SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  if (state.hasError) // ✅ Show error message
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 8),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
