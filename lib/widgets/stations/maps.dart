import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapLinkButton extends StatelessWidget {
  final String mapUrl;

  const OpenMapLinkButton({
    super.key,
    required this.mapUrl,
  });

  Future<void> _launchMap() async {
    Uri uri;

    if (mapUrl.startsWith('http')) {
      // If mapUrl is already a Google Maps URL, launch it directly
      uri = Uri.parse(mapUrl);
    } else {
      // Encode the address or coordinates for the destination parameter
      final encodedQuery = Uri.encodeComponent(mapUrl);
      // Use directions URL to start navigation automatically
      uri = Uri.parse(
          "https://www.google.com/maps/dir/?api=1&destination=$encodedQuery&travelmode=driving");
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
            Icon(Icons.location_on_outlined,
                size: 60, color: Colors.blueAccent),
            SizedBox(height: 15),
            Text(
              'Start Navigation in Google Maps?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You are about to leave this app and start navigation in Google Maps.\n\nDo you want to continue?',
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.transparent,
        side: BorderSide(
          color: primaryColor,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 3,
        padding: const EdgeInsets.all(12), // Adjusted for icon-only button
        minimumSize: Size(48, 48), // Ensure button is large enough for icon
      ),
      onPressed: () => _confirmAndLaunchMap(context),
      child: Icon(
        Icons.location_on_outlined,
        color: primaryColor,
        size: 24,
      ),
    );
  }
}
