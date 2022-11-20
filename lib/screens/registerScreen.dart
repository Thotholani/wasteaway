import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wasteaway/screens/pinScreen.dart';
import 'package:wasteaway/services/authentication.dart';
import 'package:wasteaway/theme.dart';

import '../components/buttons.dart';
import '../components/inputBox.dart';
import '../services/tests.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullnameController = TextEditingController();
  final phonenumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/logo.png",width: 150,),
                  Text("Create an account",style: Theme.of(context).textTheme.headline1,),
                  SizedBox(height: 20,),
                  textInputBox(controller: fullnameController,inputLabel: "Fullname",inputType: TextInputType.text),
                  SizedBox(height: 15,),
                  textInputBox(controller: emailController,inputLabel: "Email",inputType: TextInputType.emailAddress),
                  SizedBox(height: 15,),
                  textInputBox(controller: phonenumberController,inputLabel: "Phone Number",inputType: TextInputType.phone),
                  SizedBox(height: 15,),
                  passwordInputBox(passwordController: passwordController),
                  SizedBox(height: 15,),
                  PrimaryBlueButton(buttonText: "Register",onPressed: (){
                    if(phonenumberController.text.length == 10 && phonenumberController.text.startsWith("0")) {
                      emailController.text.isNotEmpty && passwordController.text.isNotEmpty && fullnameController.text.isNotEmpty && phonenumberController.text.isNotEmpty ? emailController
                          .text.contains("@") ? Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(fullnameController.text, emailController.text, phonenumberController.text, passwordController.text))) : Fluttertoast.showToast(
                        msg: "Your email must contain the @ symbol ",
                        backgroundColor: Color(cancelRedColor),
                      ) : Fluttertoast.showToast(
                        msg: "Please fill in all fields",
                        backgroundColor: Color(cancelRedColor),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Your phone number should be exactly 10 digits long and start with 0",
                        backgroundColor: Color(cancelRedColor),
                      );
                    }
                  },),
                  SizedBox(height: 20,),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Color(secondaryGreenColor),
                        textStyle: TextStyle(fontWeight: FontWeight.normal)
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
