import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;

  const NewsDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            'This is the full news description for: $title',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
