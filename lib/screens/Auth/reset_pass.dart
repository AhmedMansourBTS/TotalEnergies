import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/user_model.dart';
import 'package:total_energies/services/user_service.dart';
import 'package:total_energies/widgets/auth/header.dart';
import 'package:total_energies/widgets/auth/custPassField.dart';
import 'package:total_energies/widgets/auth/custCnfrmPassField.dart';

class ResetPass extends StatefulWidget {
  final UserModel user;
  ResetPass({super.key, required this.user});
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _cnfPasswordController =
      new TextEditingController();
  final userService = new UserService();
  late UserModel user;
  _ResetPassState() {
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
                Header(Title: 'register_page.password_label'.tr),
                CustPasswordField(
                  controller: _passwordController,
                  labelText: 'register_page.password_label'.tr,
                  hintText: 'register_page.password_hint'.tr,
                  validator: _validatePassword,
                  showAsterisk: true,
                ),
                CustConfirmPasswordField(
                  controller: _cnfPasswordController,
                  passwordController:
                      _passwordController, //  Pass the original password
                  labelText: 'register_page.confrim_password_label'.tr,
                  hintText: 'register_page.confrim_password_hint'.tr,
                  validator: _validateConfirmPassword,
                  showAsterisk: true,
                ),
                ElevatedButton(
                  onPressed: resetPass,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                  ),
                  child: Text(
                    'btn.save_change'.tr,
                    style: TextStyle(color: btntxtColors, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'register_page.empty_verification'.tr;
    } else if (value != _passwordController.text) {
      return 'register_page.unmatched_conf_pass'.tr;
    }
    return null;
  }

  void resetPass() {
    user = UserModel.from(widget.user);
    user.password = _passwordController.text;
    //int id = user.serial as int;
    userService.updateUser(143, user);
    print('');
  }
}
