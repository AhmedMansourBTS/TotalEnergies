// import 'package:flutter/material.dart';
// import 'package:total_energies/models/city_model.dart';
// import 'package:total_energies/services/city_service.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class CitySearchField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final String? Function(String?)? validator;
//   final bool showAsterisk;

//   const CitySearchField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     required this.hintText,
//     this.validator,
//     this.showAsterisk = false,
//   });

//   @override
//   State<CitySearchField> createState() => _CitySearchFieldState();
// }

// class _CitySearchFieldState extends State<CitySearchField> {
//   final CityService _cityService = CityService();
//   List<CityModel> _cities = [];
//   List<CityModel> _filteredCities = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCities();
//   }

//   Future<void> _fetchCities() async {
//     try {
//       List<CityModel> cities = await _cityService.getCities(context);
//       setState(() {
//         _cities = cities;
//         _filteredCities = cities;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _openSearchDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String query = '';
//         List<CityModel> results = _cities;

//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Select City'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     suffixIcon: Icon(Icons.search),
//                   ),
//                   onChanged: (value) {
//                     query = value.toLowerCase();
//                     setState(() {
//                       results = _cities.where((c) {
//                         return c.cityLatName.toLowerCase().startsWith(query) ||
//                             c.cityName.startsWith(query);
//                       }).toList();
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 results.isEmpty
//                     ? Text('No cities found.')
//                     : SizedBox(
//                         height: 200,
//                         width: double.maxFinite,
//                         child: ListView.builder(
//                           itemCount: results.length,
//                           itemBuilder: (context, index) {
//                             final city = results[index];
//                             return ListTile(
//                               title: Text(
//                                 Directionality.of(context) != TextDirection.rtl
//                                     ? city.cityLatName
//                                     : city.cityName,
//                               ),
//                               onTap: () {
//                                 widget.controller.text =
//                                     Directionality.of(context) !=
//                                             TextDirection.rtl
//                                         ? city.cityLatName
//                                         : city.cityName;
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   Widget get formattedLabel {
//     return RichText(
//       text: TextSpan(
//         text: widget.labelText,
//         style: TextStyle(color: inputTextColor, fontSize: 16),
//         children: widget.showAsterisk
//             ? [
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               ]
//             : [],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: widget.controller,
//             readOnly: true,
//             onTap: _openSearchDialog,
//             decoration: InputDecoration(
//               label:
//                   widget.showAsterisk ? formattedLabel : Text(widget.labelText),
//               hintText: widget.hintText,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(color: txtfieldborderColor),
//               ),
//               suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor),
//             ),
//             validator: widget.validator,
//           ),
//           if (_isLoading)
//             Padding(
//               padding: const EdgeInsets.only(top: 5),
//               child: Text(
//                 "Loading cities...",
//                 style: TextStyle(fontSize: 12, color: Colors.black),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:total_energies/models/city_model.dart';
// import 'package:total_energies/services/city_service.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class CitySearchField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final String? Function(String?)? validator;
//   final bool showAsterisk;

//   const CitySearchField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     required this.hintText,
//     this.validator,
//     this.showAsterisk = false,
//   });

//   @override
//   State<CitySearchField> createState() => _CitySearchFieldState();
// }

// class _CitySearchFieldState extends State<CitySearchField> {
//   final CityService _cityService = CityService();
//   List<CityModel> _cities = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCities();
//   }

//   Future<void> _fetchCities() async {
//     try {
//       List<CityModel> cities = await _cityService.getCities();
//       if (mounted) {
//         setState(() {
//           _cities = cities;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _openSearchDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String query = '';
//         List<CityModel> results = _cities;

//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: const Text('Select City'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   autofocus: true,
//                   decoration: const InputDecoration(
//                     hintText: 'Search...',
//                     suffixIcon: Icon(Icons.search),
//                   ),
//                   onChanged: (value) {
//                     query = value.toLowerCase();
//                     setState(() {
//                       results = _cities.where((c) {
//                         return c.cityLatName.toLowerCase().startsWith(query) ||
//                             c.cityName.startsWith(query);
//                       }).toList();
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 results.isEmpty
//                     ? const Text('No cities found.')
//                     : SizedBox(
//                         height: 200,
//                         width: double.maxFinite,
//                         child: ListView.builder(
//                           itemCount: results.length,
//                           itemBuilder: (context, index) {
//                             final city = results[index];
//                             return ListTile(
//                               title: Text(
//                                 Directionality.of(context) != TextDirection.rtl
//                                     ? city.cityLatName
//                                     : city.cityName,
//                               ),
//                               onTap: () {
//                                 widget.controller.text =
//                                     Directionality.of(context) != TextDirection.rtl
//                                         ? city.cityLatName
//                                         : city.cityName;
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         ),
//                       ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   Widget get formattedLabel {
//     return RichText(
//       text: TextSpan(
//         text: widget.labelText,
//         style: TextStyle(color: inputTextColor, fontSize: 16),
//         children: widget.showAsterisk
//             ? const [
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: Colors.red, fontSize: 16),
//                 ),
//               ]
//             : [],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: widget.controller,
//             readOnly: true,
//             onTap: _openSearchDialog,
//             decoration: InputDecoration(
//               label: widget.showAsterisk ? formattedLabel : Text(widget.labelText),
//               hintText: widget.hintText,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(color: txtfieldborderColor),
//               ),
//               suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor),
//             ),
//             validator: widget.validator,
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.only(top: 5),
//               child: Text(
//                 "Loading cities...",
//                 style: TextStyle(fontSize: 12, color: Colors.black),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:total_energies/models/governorate_model.dart';
import 'package:total_energies/services/governorate_service.dart';
import 'package:total_energies/core/constant/colors.dart';

class GovernorateSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showAsterisk;

  const GovernorateSearchField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.showAsterisk = false,
  });

  @override
  State<GovernorateSearchField> createState() => _GovernorateSearchFieldState();
}

class _GovernorateSearchFieldState extends State<GovernorateSearchField> {
  List<GovernorateModel> _governorates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGovernorates();
  }

  Future<void> _fetchGovernorates() async {
    try {
      List<GovernorateModel> result = await GovernorateService.getAllGovernorates();
      if (mounted) {
        setState(() {
          _governorates = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String query = '';
        List<GovernorateModel> results = _governorates;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Governorate'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    query = value.toLowerCase();
                    setState(() {
                      results = _governorates.where((g) {
                        return g.governorateLatName.toLowerCase().startsWith(query) ||
                               g.governorateName.startsWith(query);
                      }).toList();
                    });
                  },
                ),
                const SizedBox(height: 10),
                results.isEmpty
                    ? const Text('No governorates found.')
                    : SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final gov = results[index];
                            return ListTile(
                              title: Text(
                                Directionality.of(context) != TextDirection.rtl
                                    ? gov.governorateLatName
                                    : gov.governorateName,
                              ),
                              onTap: () {
                                widget.controller.text =
                                    Directionality.of(context) != TextDirection.rtl
                                        ? gov.governorateLatName
                                        : gov.governorateName;
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget get formattedLabel {
    return RichText(
      text: TextSpan(
        text: widget.labelText,
        style: TextStyle(color: inputTextColor, fontSize: 16),
        children: widget.showAsterisk
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            readOnly: true,
            onTap: _openSearchDialog,
            decoration: InputDecoration(
              label: widget.showAsterisk ? formattedLabel : Text(widget.labelText),
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: txtfieldborderColor),
              ),
              suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor),
            ),
            validator: widget.validator,
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Loading governorates...",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
