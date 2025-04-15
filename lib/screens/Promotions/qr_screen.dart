// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';

// class QrScreen extends StatelessWidget {
//   final PromotionsModel promotion;

//   const QrScreen({super.key, required this.promotion});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: Row(
//             children: [
//               SizedBox(
//                 height: kToolbarHeight,
//                 child: Image.asset(
//                   "assets/images/logo.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(
//                 height: kToolbarHeight,
//                 child: Image.asset(
//                   "assets/images/ADNOC logo1.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Center(
//           // child: promotion.imagePath == null || promotion.imagePath == ''
//           //     ? Image.network(promotion.imagePath ?? '')
//           //     : Image.asset("assets/images/logo.png"),
//           child: promotion.imagePath == null || promotion.imagePath == ''
//               ? Image.asset("assets/images/logo.png")
//               : Image.network(promotion.imagePath ?? ''),
//         ),
//       ),
//     );
//   }
// }

// QR code works well but with constant serials
// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/get_qr_model.dart';
// import 'package:total_energies/services/get_qr_service.dart';

// class QRPage extends StatefulWidget {
//   const QRPage({super.key});

//   @override
//   _QRPageState createState() => _QRPageState();
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
//         GenerateQRRequest(customerId: 121, eventId: 1073),
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
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: Row(
//             children: [
//               SizedBox(
//                 height: kToolbarHeight,
//                 child: Image.asset(
//                   "assets/images/logo.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               SizedBox(
//                 height: kToolbarHeight,
//                 child: Image.asset(
//                   "assets/images/ADNOC logo1.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
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
//                       SizedBox(height: 10),
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
import 'package:total_energies/services/get_qr_service.dart';

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

  @override
  void initState() {
    super.initState();
    fetchQRCode();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          AppBar(backgroundColor: backgroundColor, title: Text("QR Generator")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
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
    );
  }
}
