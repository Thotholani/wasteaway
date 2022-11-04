import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:wasteaway/theme.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

//text input box
class textInputBox extends StatelessWidget {
  textInputBox({required this.controller,required this.inputLabel,required this.inputType});

  final TextEditingController controller;
  final String inputLabel;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Color(greyishBlueColor),
        fontWeight: FontWeight.normal,
        fontSize: 16
      ),
      autofocus: false,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(greyishBlueColor)),
          ),
          label: Text(inputLabel)
      ),
    );
  }
}

//password input box
class passwordInputBox extends StatefulWidget {
  passwordInputBox({required this.passwordController});
  final TextEditingController passwordController;
  bool _isObscured = true;

  @override
  State<passwordInputBox> createState() => _passwordInputBoxState();
}

class _passwordInputBoxState extends State<passwordInputBox> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          color: Color(greyishBlueColor),
          fontWeight: FontWeight.normal,
          fontSize: 16
      ),
      autofocus: false,
      controller: widget.passwordController,
      obscureText: widget._isObscured,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(greyishBlueColor)),
          ),
          label: Text("Password"),
          suffixIcon: IconButton(
            color: Color(greyishBlueColor),
            icon: Icon(widget._isObscured ? EvaIcons.eyeOutline : EvaIcons.eyeOff2Outline),
            onPressed: () {
              setState((){
                widget._isObscured = !widget._isObscured;
              });
            },
            focusColor: Color(greyishBlueColor),
          ),
      ),
    );
  }
}

//OTP Style Pin Box
class PinBox extends StatelessWidget {
  PinBox({required this.pinController, required this.onCompleted});
  final OtpFieldController pinController;
  final void Function(String?) onCompleted;

  @override
  Widget build(BuildContext context) {
    return OTPTextField(
      controller: pinController,
      contentPadding: EdgeInsets.all(0),
      otpFieldStyle: OtpFieldStyle(
          focusBorderColor: Color(secondaryGreenColor),
          backgroundColor: Color(0xfffafafa),
          borderColor: Color(borderGreyColor)
      ),
      length: 4,
      width: double.infinity,
      textFieldAlignment: MainAxisAlignment.spaceBetween,
      fieldWidth: 55,
      fieldStyle: FieldStyle.box,
      outlineBorderRadius: 5,
      style: TextStyle(
          fontSize: 24,
          color: Color(secondaryGreenColor),
          fontWeight: FontWeight.bold
      ),
      onCompleted:  onCompleted,
    );
  }
}