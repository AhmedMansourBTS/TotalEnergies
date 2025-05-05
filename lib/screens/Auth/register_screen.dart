import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/services/user_service.dart';
import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:total_energies/widgets/withService/car_brand_search.dart';
import 'package:total_energies/widgets/auth/custCnfrmPassField.dart';
import 'package:total_energies/widgets/auth/custDateField.dart';
import 'package:total_energies/widgets/auth/phone.dart';
import 'package:total_energies/widgets/auth/textWithCheckbox.dart';
import 'package:total_energies/widgets/auth/custPassField.dart';
import 'package:total_energies/widgets/Buttons/custRowRdioBtn.dart';
import 'package:total_energies/widgets/auth/custTxtField.dart';
import 'package:total_energies/widgets/withService/custCitySearchfield.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  // final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carModelYear = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _carBrandController = TextEditingController();
  // final TextEditingController _agreeTermsController = TextEditingController();

  bool _agreeTerms = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UserService apiService = UserService();

  void register() async {
    // Check if the form is valid before proceeding
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'register_page.terms_verification'.tr,
              style: TextStyle(fontSize: 18),
            )),
      );
      return;
    }

    UserModel user = UserModel(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneNumberController.text,
      birthDate: _birthDateController.text,
      carModel: _carBrandController.text,
      gender: _genderController.text,
      // cityCode: _cityCodeController.hashCode,
      cityCode: int.tryParse(_cityCodeController.text) ?? 0,
      password: _passwordController.text,
      // carModelYear: _carModelYear.text,
      carModelYear: int.tryParse(_carModelYear.text) ?? 0,
    );
    var Res = await apiService.registerUser(user);
    int success = Res.statusCode;
    String mess = Res.body;
    print(Res.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success == 200 ? Colors.green : Colors.red,
        content: Text(
          success == 200 ? 'register_page.success_verification'.tr : mess,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );

    if (success == 200) Navigator.pop(context);
  }

// Email Address validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'register_page.email_verification'.tr;
    }
    return null; // Valid input
  }

// Email Address validation function
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    } else if (!RegExp(r'^[a-zA-Z\s]{3,}$').hasMatch(value)) {
      return 'register_page.name_verification'.tr;
    }
    return null; // Valid input
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    } else if (value.length < 8) {
      return 'register_page.pass_verification'.tr;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(value)) {
      return 'register_page.pass_verification'
          .tr; // You can create a specific translation for this case
    }
    return null;
  }

// Confirm Password validation function
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    } else if (value.length < 8) {
      return 'register_page.pass_verification'.tr;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(value)) {
      return 'register_page.pass_verification'
          .tr; // You can create a specific translation for this case
    }
    return null;
  }

  // Date validation function
  // String? _validateDate(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "Please select a date";
  //   }
  //   return null;
  // }
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    }

    try {
      // Ensure the date is in "YYYY-MM-DD" format before parsing
      List<String> parts = value.split("-");
      if (parts.length != 3) return 'register_page.date_verification'.tr;

      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      DateTime selectedDate = DateTime(year, month, day);
      DateTime today = DateTime.now();
      DateTime minAllowedDate =
          DateTime(today.year - 16, today.month, today.day);

      if (selectedDate.isAfter(minAllowedDate)) {
        return 'register_page.age_verification'.tr;
      }
    } catch (e) {
      return 'register_page.date_verification'.tr;
    }

    return null; // ✅ Valid input
  }

  // Validation function defined in the page
  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    }
    return null;
  }

// Validation function defined in the page
  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    }
    return null;
  }

// Year validation function
  String? _validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    }
    // Check if input is exactly 4 digits and numeric
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'register_page.year_verification'.tr;
    }
    // Convert string to integer
    int year = int.tryParse(value) ?? 0;
    // Check if year is within the valid range
    if (year < 1990 || year > 2030) {
      return 'register_page.year_verification1'.tr;
    }
    return null; // Valid input
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: appbariconColors),
        title: Row(
          children: [
            // SizedBox(
            //   height: kToolbarHeight - 25,
            //   child: Image.asset(
            //     "assets/images/logo1.1.png",
            //     fit: BoxFit.contain,
            //   ),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            // SizedBox(
            //   height: kToolbarHeight - 25,
            //   child: Image.asset(
            //     "assets/images/ADNOC logo1.1.png",
            //     fit: BoxFit.contain,
            //   ),
            // ),
            LogoRow(),
            const Spacer(),
            TranslateButton()
          ],
        ),
        //title: Directionality.of(context) != TextDirection.rtl
        //     ? Container(
        //         alignment: Alignment.centerRight,
        //         child: TranslateButton(),
        //       )
        //     : Container(
        //         alignment: Alignment.centerLeft,
        //         child: TranslateButton(),
        //       ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Custtxtfield(
                  controller: _nameController,
                  labelText: 'register_page.username_label'.tr,
                  hintText: 'register_page.username_hint'.tr,
                  keyboardType: TextInputType.text,
                  validator: _validateName,
                  prefixIcon: Icons.person,
                  showAsterisk: true,
                ),
                CustPhoneField(
                  controller: _phoneNumberController,
                  labelText: 'register_page.phone_no_label'.tr,
                  hintText: 'register_page.phone_no_hint'.tr,
                  initialCountryCode: "EG",
                  showAsterisk: true,
                ),
                Custtxtfield(
                  controller: _emailController,
                  labelText: 'register_page.email_label'.tr,
                  hintText: 'register_page.email_hint'.tr,
                  keyboardType: TextInputType.emailAddress,
                  // validator: _validateEmail,
                  prefixIcon: Icons.mail,
                ),
                Custrowrdiobtn(
                  controller: _genderController,
                  labelText: 'register_page.gender_label'.tr,
                  options: [
                    'register_page.gender_hint1'.tr,
                    'register_page.gender_hint2'.tr
                  ],
                  // validator: _validateGender,
                  showAsterisk: true,
                ),
                // CustCityDropdown(
                //   controller: _cityCodeController,
                //   labelText: 'register_page.gov_label'.tr,
                //   hintText: 'register_page.gov_hint'.tr,
                //   // validator: _validateCity,
                //   showAsterisk: true,
                // ),
                CitySearchField(
                  controller: _cityCodeController,
                  labelText: "City",
                  hintText: "Select your city",
                  showAsterisk: true, // Show * if required
                ),
                CustDatePickerField(
                  controller: _birthDateController,
                  labelText: 'register_page.birth_date_label'.tr,
                  hintText: 'register_page.birth_date_hint'.tr,
                  dateFrom: DateTime(1930, 1, 1), // Example: Minimum date
                  dateTo: DateTime.now(), // Example: Maximum date (today)
                  // validator: _validateDate,
                ),
                // Custtxtfield(
                //   controller: _carModelController,
                //   labelText: 'register_page.car_brand_label'.tr,
                //   hintText: 'register_page.car_brand_hint'.tr,
                //   keyboardType: TextInputType.text,
                //   // validator: _validateName,
                //   prefixIcon: Icons.directions_car,
                // ),
                CarBrandSearchField(
                  controller: _carBrandController,
                  labelText: "Car Brand",
                  hintText: "Select car brand",
                  // showAsterisk: true,
                ),
                Custtxtfield(
                  controller: _carModelYear,
                  labelText: 'register_page.car_brand_year_label'.tr,
                  hintText: 'register_page.car_brand_year_hint'.tr,
                  keyboardType: TextInputType.number,
                  // validator: _validateYear,
                  prefixIcon: Icons.calendar_today,
                ),
                CustPasswordField(
                  controller: _passwordController,
                  labelText: 'register_page.password_label'.tr,
                  hintText: 'register_page.password_hint'.tr,
                  validator: _validatePassword,
                  showAsterisk: true,
                ),
                CustConfirmPasswordField(
                  controller: _confirmPasswordController,
                  passwordController:
                      _passwordController, //  Pass the original password
                  labelText: 'register_page.confrim_password_label'.tr,
                  hintText: 'register_page.confrim_password_hint'.tr,
                  validator: _validateConfirmPassword,
                  showAsterisk: true,
                ),

                TextWithCheckbox(
                  text: 'register_page.term&cond'.tr,
                  value: _agreeTerms,
                  onChanged: (bool value) {
                    setState(() {
                      _agreeTerms = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: register,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                    fixedSize:
                        WidgetStateProperty.all(Size(double.maxFinite, 40)),
                  ),
                  child: Text(
                    'btn.reg_btn'.tr,
                    style: TextStyle(color: btntxtColors, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
