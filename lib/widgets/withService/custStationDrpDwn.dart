import 'package:flutter/material.dart';

class StationsDropdown extends StatelessWidget {
  final List<int> stations;
  final List<String> stationAddresses;
  final int? selectedStation;
  final Function(int? stationSerial, String? stationAddress) onChanged;

  const StationsDropdown({
    super.key,
    required this.stations,
    required this.stationAddresses,
    required this.selectedStation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        hintText: "Select a Station",
      ),
      value: selectedStation,
      items: List.generate(stations.length, (index) {
        return DropdownMenuItem<int>(
          value: stations[index],
          child: Text('Station ${stations[index]}'),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          int stationIndex = stations.indexOf(value);
          String address = stationAddresses[stationIndex];
          onChanged(value, address);
        }
      },
    );
  }
}
