// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/get_qr_model.dart';
// import 'package:total_energies/services/get_qr_service.dart';

// class QRPage extends StatefulWidget {
//   final int customerId;
//   final int eventId;

//   const QRPage({super.key, required this.customerId, required this.eventId});

//   @override
//   State<QRPage> createState() => _QRPageState();
// }

// class _QRPageState extends State<QRPage> {
//   String? base64Image;
//   String? fileName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchQRCode();
//   }

//   void fetchQRCode() async {
//     try {
//       final service = QRService();
//       final response = await service.generateQR(
//         GenerateQRRequest(
//             customerId: widget.customerId, eventId: widget.eventId),
//       );

//       setState(() {
//         base64Image = response.image;
//         fileName = response.fileName;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar:
//           AppBar(backgroundColor: backgroundColor, title: Text("QR Generator")),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : base64Image != null
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.memory(
//                         Uri.parse(base64Image!).data!.contentAsBytes(),
//                         width: 300,
//                         height: 300,
//                       ),
//                       // SizedBox(height: 10),
//                       // Text(fileName ?? '', style: TextStyle(fontSize: 16)),
//                     ],
//                   )
//                 : Text('Failed to load QR'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/get_qr_model.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/get_qr_service.dart';
import 'dart:async'; // <-- Add this import for Timer

class QRPage extends StatefulWidget {
  final int customerId;
  final int eventId;

  const QRPage({super.key, required this.customerId, required this.eventId});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String? base64Image;
  String? fileName;
  bool isLoading = true;
  int remainingTime = 59; // Set countdown time in seconds (e.g., 10 seconds)
  late final Timer _timer; // Timer to update the countdown every second

  @override
  void initState() {
    super.initState();
    fetchQRCode();
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

  void fetchQRCode() async {
    try {
      final service = QRService();
      final response = await service.generateQR(
        GenerateQRRequest(
            customerId: widget.customerId, eventId: widget.eventId),
      );

      setState(() {
        base64Image = response.image;
        fileName = response.fileName;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          AppBar(backgroundColor: backgroundColor, title: Text("QR Generator")),
      body: Column(
        children: [
          // Timer display at the top
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
          ),
          // Main content
          Expanded(
            child: Center(
              child: isLoading
                  ? LoadingScreen()
                  : base64Image != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.memory(
                              Uri.parse(base64Image!).data!.contentAsBytes(),
                              width: 300,
                              height: 300,
                            ),
                            // SizedBox(height: 10),
                            // Text(fileName ?? '', style: TextStyle(fontSize: 16)),
                          ],
                        )
                      : Text('Failed to load QR'),
            ),
          ),
        ],
      ),
    );
  }
}
