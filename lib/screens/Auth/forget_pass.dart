import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/services/user_service.dart';
import 'package:total_energies/widgets/auth/custOtpField.dart';
import 'package:total_energies/widgets/auth/header.dart';
import 'package:total_energies/widgets/auth/phone.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserService apiService = UserService();

  bool _showOtpField = false;

  void sendOtp() {
    if (_phoneController.text.length > 8) {
      setState(() {
        _showOtpField = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.redAccent,
            content: Text(
              "Please enter your phone number",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      );
    }
  }

  String? _validatePhone(PhoneNumber? phone) {
    if (phone == null || phone.number.isEmpty) {
      return 'forget_page.empty_verification'.tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: appbariconColors),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(Title: 'forget_page.title'.tr),
                CustPhoneField(
                  controller: _phoneController,
                  labelText: 'forget_page.phone_no'.tr,
                  hintText: 'forget_page.phone_no_hint'.tr,
                  initialCountryCode: "EG",
                  validator: _validatePhone,
                ),
                if (_showOtpField) ...[
                  SizedBox(height: 10),
                  Custotpfield(
                    controller: _otpController,
                    labelText: 'forget_page.otp_label'.tr,
                    hintText: 'forget_page.otp_hint'.tr,
                    // validator: _validateEmail,
                    // prefixIcon: Icons.mail,
                  ),
                ],
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: sendOtp,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                  ),
                  child: Text(
                    'btn.forget_page_forget_btn'.tr,
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
