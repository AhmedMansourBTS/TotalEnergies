import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/widgets/Promotions/activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class ExpPromoDet extends StatefulWidget {
  final ExpiredPromoModel promotion;

  const ExpPromoDet({super.key, required this.promotion});

  @override
  _ExpPromoDetState createState() => _ExpPromoDetState();
}

class _ExpPromoDetState extends State<ExpPromoDet> {
  int custserial = 0;

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      custserial = prefs.getInt('serial') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: LogoRow(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.promotion.imagePath == null ||
                      widget.promotion.imagePath == ''
                  ? Image.network(widget.promotion.imagePath ?? '')
                  : Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(height: 20),
            Text(
              widget.promotion.eventTopic,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.promotion.eventEnDescription,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text(
                      "Start Date: ${widget.promotion.startDate.toString().split(' ')[0]}",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text(
                      'End date: ${widget.promotion.endDate.toString().split(' ')[0]}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                  ActivityIndicator(
                    left: widget.promotion.qrMaxUsage,
                    total: widget.promotion.qrMaxUsage,
                    title: 'Usage times',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
