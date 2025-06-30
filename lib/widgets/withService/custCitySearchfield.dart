import 'package:flutter/material.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/services/city_service.dart';
import 'package:total_energies/core/constant/colors.dart';

class CitySearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showAsterisk;

  const CitySearchField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.showAsterisk = false,
  });

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final CityService _cityService = CityService();
  List<CityModel> _cities = [];
  List<CityModel> _filteredCities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      List<CityModel> cities = await _cityService.getCities(context);
      setState(() {
        _cities = cities;
        _filteredCities = cities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String query = '';
        List<CityModel> results = _cities;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Select City'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    query = value.toLowerCase();
                    setState(() {
                      results = _cities.where((c) {
                        return c.cityLatName.toLowerCase().startsWith(query) ||
                            c.cityName.startsWith(query);
                      }).toList();
                    });
                  },
                ),
                SizedBox(height: 10),
                results.isEmpty
                    ? Text('No cities found.')
                    : SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final city = results[index];
                            return ListTile(
                              title: Text(
                                Directionality.of(context) != TextDirection.rtl
                                    ? city.cityLatName
                                    : city.cityName,
                              ),
                              onTap: () {
                                widget.controller.text =
                                    Directionality.of(context) !=
                                            TextDirection.rtl
                                        ? city.cityLatName
                                        : city.cityName;
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
            ? [
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
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            readOnly: true,
            onTap: _openSearchDialog,
            decoration: InputDecoration(
              label:
                  widget.showAsterisk ? formattedLabel : Text(widget.labelText),
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
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Loading cities...",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
