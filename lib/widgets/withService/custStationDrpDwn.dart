// import 'package:flutter/material.dart';

// class StationsDropdown extends StatelessWidget {
//   final List<int> stations;
//   // final List<String> stationAddresses;
//   final int? selectedStation;
//   final Function(int? stationSerial, String? stationAddress) onChanged;

//   const StationsDropdown({
//     super.key,
//     required this.stations,
//     // required this.stationAddresses,
//     required this.selectedStation,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<int>(
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         hintText: "Select a Station",
//       ),
//       value: selectedStation,
//       items: List.generate(stations.length, (index) {
//         return DropdownMenuItem<int>(
//           value: stations[index],
//           child: Text('Station ${stations[index]}'),
//         );
//       }),
//       onChanged: (value) {
//         if (value != null) {
//           int stationIndex = stations.indexOf(value);
//           // String address = stationAddresses[stationIndex];
//           onChanged(value, address);
//         }
//       },
//     );
//   }
// }

// Works well
// import 'package:flutter/material.dart';
// import 'package:total_energies/models/stations_model.dart';
// import 'package:total_energies/services/station_service.dart';

// class StationsDropdown extends StatefulWidget {
//   final List<int> stationSerials;
//   final Function(StationModel?, String?) onChanged; // updated: returns station + addressUrl
//   final StationModel? selectedStation;

//   const StationsDropdown({
//     super.key,
//     required this.stationSerials,
//     required this.onChanged,
//     this.selectedStation,
//   });

//   @override
//   State<StationsDropdown> createState() => _StationsDropdownState();
// }

// class _StationsDropdownState extends State<StationsDropdown> {
//   late Future<List<StationModel>> _stationsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _stationsFuture = _loadFilteredStations();
//   }

//   Future<List<StationModel>> _loadFilteredStations() async {
//     StationService service = StationService();
//     List<StationModel> allStations = await service.getStations();
//     return allStations
//         .where((station) => widget.stationSerials.contains(station.serial))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<StationModel>>(
//       future: _stationsFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Text('No stations available.');
//         } else {
//           final stations = snapshot.data!;
//           return DropdownButtonFormField<StationModel>(
//             value: widget.selectedStation,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//               hintText: "Select a Station",
//             ),
//             items: stations.map((station) {
//               return DropdownMenuItem<StationModel>(
//                 value: station,
//                 child: Text(station.stationArabicName),
//               );
//             }).toList(),
//             onChanged: (StationModel? selected) {
//               widget.onChanged(selected, selected?.stationAdress);
//             },
//           );
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/models/stations_model.dart';
import 'package:total_energies/services/station_service.dart';

class StationsDropdown extends StatefulWidget {
  final List<int> stationSerials;
  final Function(StationModel?, String?) onChanged;
  final StationModel? selectedStation;

  const StationsDropdown({
    super.key,
    required this.stationSerials,
    required this.onChanged,
    this.selectedStation,
  });

  @override
  State<StationsDropdown> createState() => _StationsDropdownState();
}

class _StationsDropdownState extends State<StationsDropdown> {
  late Future<List<StationModel>> _stationsFuture;
  List<StationModel> _stations = [];
  StationModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedStation;
    _stationsFuture = _loadFilteredStations();
  }

  Future<List<StationModel>> _loadFilteredStations() async {
    StationService service = StationService();
    List<StationModel> allStations = await service.getStations();
    final filtered = allStations
        .where((station) => widget.stationSerials.contains(station.serial))
        .toList();
    _stations = filtered;
    return filtered;
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<StationModel> results = _stations;
        String query = "";

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Search Station'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      query = value.toLowerCase();
                      setState(() {
                        results = _stations
                            .where((s) => s.stationArabicName
                                .toLowerCase()
                                .contains(query))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: results.isEmpty
                        ? const Center(child: Text('No stations found.'))
                        : ListView.builder(
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final station = results[index];
                              return ListTile(
                                title: Text(station.stationArabicName),
                                onTap: () {
                                  setState(() {
                                    _selected = station;
                                  });
                                  widget.onChanged(
                                      station, station.stationAdress);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StationModel>>(
      future: _stationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No stations available.');
        } else {
          return GestureDetector(
            onTap: _openSearchDialog,
            child: AbsorbPointer(
              child: DropdownButtonFormField<StationModel>(
                value: _selected,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  hintText: "Select a Station",
                  suffixIcon: const Icon(Icons.search),
                ),
                items: snapshot.data!.map((station) {
                  return DropdownMenuItem<StationModel>(
                    value: station,
                    child: Text(station.stationArabicName),
                  );
                }).toList(),
                onChanged: (_) {}, // Disabled, search dialog handles selection
              ),
            ),
          );
        }
      },
    );
  }
}
