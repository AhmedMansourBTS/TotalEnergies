import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/user_model.dart';
import 'package:total_energies/screens/Auth/reset_pass.dart';
import 'package:total_energies/services/user_service.dart';
import 'package:total_energies/widgets/auth/custOtpField.dart';
import 'package:total_energies/widgets/auth/header.dart';
import 'package:total_energies/widgets/auth/phone.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  var PhoneAuth;
  FirebaseAuthentication auth = FirebaseAuthentication();
  bool _showOtpField = false;
  late UserModel user;
  void sendOtp() async {
    if (_phoneController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.redAccent,
            content: Text(
              "Please enter your phone number",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )),
      );
      return;
    }
    user = await apiService.findUser(_phoneController.text);
    setState(() {
      _showOtpField = true;
    });
    PhoneAuth = await auth.sendOTP(_phoneController.text,this.user,this.context);
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
                  ElevatedButton(
                    onPressed: () {
                      auth.checkOTP(_otpController.text,this.user, this.context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(primaryColor),
                    ),
                    child: Text(
                      'btn.submit_otp_btn'.tr,
                      style: TextStyle(color: btntxtColors, fontSize: 20),
                    ),
                  )
                ],
                SizedBox(height: 10),
                if (!_showOtpField) ...[
                  ElevatedButton(
                    onPressed: sendOtp,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(primaryColor),
                    ),
                    child: Text(
                      'btn.forget_page_forget_btn'.tr,
                      style: TextStyle(color: btntxtColors, fontSize: 20),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirebaseAuthentication {
  String phoneNumber = "";
  var verId = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  sendOTP(String phoneNumber,UserModel user, BuildContext context) async {
    this.phoneNumber = phoneNumber;
    //String tempPhone = '+20$phoneNumber';

    await auth.verifyPhoneNumber(
      phoneNumber: '+20$phoneNumber',
      //timeout: const Duration(seconds: 60),
      // verificationCompleted: (PhoneAuthCredential credential) async {
      //   await auth.signInWithCredential(credential);
      // },
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        verId = verificationId;
        String smsCode = '123455';
        printMessage("sms code is $smsCode, verf Id is $verificationId");

        // Create a PhoneAuthCredential with the code
        checkOTP(smsCode, user, context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    printMessage("OTP Sent to +20$phoneNumber");
  }

  checkOTP(String smsCode,UserModel user, BuildContext context) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    // Sign the user in (or link) with the credential
    var res;
    try {
      res = await auth.signInWithCredential(credential);
      printMessage(res.toString());
    } catch (e) {
      printMessage('error while verifing otp $e');
    }

    if (res == null) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPass(user: user),
        ));
    //Get.to(() => ResetPass());
  }

  printMessage(String msg) {
    debugPrint(msg);
  }
}
