import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/widgets/stations/maps.dart';

class StationDetailsScreen extends StatelessWidget {
  final StationModel station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              LogoRow(),
              Spacer(),
              Text(
                station.stationName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Station Code: ${station.stationCode ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Address: ${station.stationAdress ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Government: ${station.stationGovernment ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("BT Code: ${station.btCode ?? 'N/A'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Active: ${station.activeYN == true ? 'Yes' : 'No'}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            OpenMapLinkButton(
              label: 'Open Location in Google Maps',
              mapUrl: station.stationAdress ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
