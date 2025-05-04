// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class Header extends StatelessWidget {
//   String Title;
//   Header({
//     super.key,
//     required this.Title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Center(
//                 child: Image.asset(
//                   "assets/images/logo.png",
//                   width: 250,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Image.asset(
//                   "assets/images/logo1.png",
//                   width: 250,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Container(
//           margin: EdgeInsets.only(bottom: 40),
//           child: Text(
//             Title,
//             style: TextStyle(fontSize: 25, color: inputTextColor),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final String Title;

  const Header({super.key, required this.Title});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double scale = 0.5;
  double opacity = 0.0;
  double leftLogoPosition = -200;
  double rightLogoPosition = -200;
  double topLogoPosition = -200;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        scale = 1.0;
        opacity = 1.0;
        leftLogoPosition = 0; // Move to center
        rightLogoPosition = 0; // Move to center
        topLogoPosition = 0; // Move to center
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                top: topLogoPosition,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                  // height: 100,
                ),
              ),
              // AnimatedPositioned(
              //   duration: Duration(seconds: 2),
              //   curve: Curves.easeInOut,
              //   right: rightLogoPosition,
              //   child: Image.asset(
              //     "assets/images/ADNOC logo1.png",
              //     width: 200,
              //     height: 100,
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          widget.Title,
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ],
    );
  }
}
