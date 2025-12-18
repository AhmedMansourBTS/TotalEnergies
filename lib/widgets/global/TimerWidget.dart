import 'package:flutter/material.dart';

import 'dart:async';


class TimerWideget extends StatefulWidget {
  // final int customerId;
  // final int eventId;
  TimerWideget({super.key});

  @override
  State<TimerWideget> createState() => _TimerWideget();
}

class _TimerWideget extends State<TimerWideget> {
  late final Timer _timer; // Timer to update the countdown every second
  int remainingTime = 60;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer.cancel(); // Stop the timer once countdown reaches 0
        Navigator.pop(context); // Navigate back to the Redeem page
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the page is disposed
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'QR Code expires in $remainingTime seconds',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red, // You can customize the color here
              ),
            ),
          )
    );
  }
}