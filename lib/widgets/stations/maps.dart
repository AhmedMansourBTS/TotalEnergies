import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapLinkButton extends StatelessWidget {
  final String label;
  final String mapUrl;

  const OpenMapLinkButton({
    super.key,
    required this.label,
    required this.mapUrl,
  });

  Future<void> _launchMap() async {
    Uri uri;

    if (mapUrl.startsWith('http')) {
      uri = Uri.parse(mapUrl);
    } else {
      final encodedQuery = Uri.encodeComponent(mapUrl);
      uri = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$encodedQuery");
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _confirmAndLaunchMap(BuildContext context) async {
    if (mapUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No station selected. Please select a station first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    bool? shouldLaunch = await showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 60, color: Colors.blueAccent),
            SizedBox(height: 15),
            Text(
              'Navigate to Google Maps?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You are about to leave this app and open Google Maps.\n\nDo you want to continue?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child:
                        Text('Continue', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (shouldLaunch == true) {
      await _launchMap();
    }
  }

  // Future<void> _confirmAndLaunchMap(BuildContext context) async {
  //   bool? shouldLaunch = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false, // force user to choose
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: Column(
  //         children: [
  //           Icon(Icons.map_outlined, size: 50, color: Colors.blueAccent),
  //           SizedBox(height: 10),
  //           Text(
  //             'Open Google Maps?',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         'You are about to leave this app and open Google Maps.\nDo you want to continue?',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       actionsAlignment: MainAxisAlignment.spaceEvenly,
  //       actions: [
  //         OutlinedButton(
  //           style: OutlinedButton.styleFrom(
  //             side: BorderSide(color: Colors.redAccent),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text('Cancel', style: TextStyle(color: Colors.redAccent)),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.green,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //           onPressed: () => Navigator.pop(context, true),
  //           child: Text('Continue', style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (shouldLaunch == true) {
  //     await _launchMap();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // 🎯 Background color
        foregroundColor: primaryColor, // 🎯 Icon and text color
        side: BorderSide(
          color: primaryColor, // 🎯 Border color
          width: 2, // 🎯 Border width
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // 🎯 Border radius
        ),
        elevation: 3, // optional: slight shadow
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 12), // optional: size
      ),
      icon: Icon(
        Icons.map_outlined,
        color: primaryColor,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: primaryColor,
        ),
      ),
      onPressed: () => _confirmAndLaunchMap(context),
    );
  }
}
