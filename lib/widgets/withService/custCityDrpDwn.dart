import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/city_model.dart';
import 'package:total_energies/services/city_service.dart';

class CustCityDropdown extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showAsterisk;

  const CustCityDropdown({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.showAsterisk = false,
  });

  @override
  _CustCityDropdownState createState() => _CustCityDropdownState();
}

class _CustCityDropdownState extends State<CustCityDropdown> {
  final CityService _cityService = CityService();
  List<CityModel> _cities = [];
  bool _isLoading = true;

  // Getter for formatted label with optional asterisk
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
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      List<CityModel> cities = await _cityService.getCities(context);
      setState(() {
        _cities = cities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor:
                  backgroundColor, // Change the dropdown menu background color
            ),
            child: DropdownButtonFormField<String>(
              menuMaxHeight: 200,
              value: widget.controller.text.isNotEmpty
                  ? widget.controller.text
                  : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: txtfieldborderColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: txtfieldborderColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: inputTextColor),
                // labelText: widget.labelText,
                label: widget.showAsterisk
                    ? formattedLabel
                    : Text(widget.labelText),
                labelStyle: TextStyle(color: inputTextColor),
              ),
              items: _cities.map((CityModel city) {
                return DropdownMenuItem<String>(
                  value: city.cityId.toString(),
                  child: Text(
                    Directionality.of(context) != TextDirection.rtl
                        ? city.cityName
                        : city.cityName,
                    style: TextStyle(color: inputTextColor),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  widget.controller.text = newValue ?? "";
                });
              },
              validator: widget.validator,
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Loading cities...",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
