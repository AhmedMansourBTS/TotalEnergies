import 'package:flutter/material.dart';
import 'package:total_energies/models/car_brands_model.dart';
import 'package:total_energies/services/car_brand_service.dart';
import 'package:total_energies/core/constant/colors.dart';

class CarBrandSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showAsterisk;

  const CarBrandSearchField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.showAsterisk = false,
  });

  @override
  State<CarBrandSearchField> createState() => _CarBrandSearchFieldState();
}

class _CarBrandSearchFieldState extends State<CarBrandSearchField> {
  final CarBrandService _carBrandService = CarBrandService();
  List<CarBrand> _carBrands = [];
  List<CarBrand> _filteredBrands = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarBrands();
  }

  Future<void> _fetchCarBrands() async {
    try {
      List<CarBrand> brands = await _carBrandService.getCarBrands();
      setState(() {
        _carBrands = brands;
        _filteredBrands = brands;
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
        List<CarBrand> results = _carBrands;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Select Car Brand'),
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
                      results = _carBrands
                          .where((b) =>
                              b.english.toLowerCase().startsWith(query) ||
                              b.arabic.startsWith(query))
                          .toList();
                    });
                  },
                ),
                SizedBox(height: 10),
                results.isEmpty
                    ? Text('No brands found.')
                    : SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final brand = results[index];
                            return ListTile(
                              title: Text(
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? brand.arabic
                                    : brand.english,
                              ),
                              onTap: () {
                                widget.controller.text =
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'ar'
                                        ? brand.arabic
                                        : brand.english;
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
                "Loading car brands...",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
