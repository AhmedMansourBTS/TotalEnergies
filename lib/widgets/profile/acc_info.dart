import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String labelText;
  final String valueText;
  final IconData icon;

  const ProfileInfoTile({
    super.key,
    required this.labelText,
    required this.valueText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(valueText, style: TextStyle(fontSize: 18)),
            Icon(icon),
          ],
        ),
        Container(
          color: Colors.white,
          height: 3,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 15),
        ),
      ],
    );
  }
}
