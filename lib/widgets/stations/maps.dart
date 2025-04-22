import 'package:flutter/material.dart';
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

    // Check if it's already a URL
    if (mapUrl.startsWith('http')) {
      uri = Uri.parse(mapUrl);
    } else {
      final encodedQuery = Uri.encodeComponent(mapUrl);
      uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedQuery");
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.map_outlined),
      label: Text(label),
      onPressed: _launchMap,
    );
  }
}
