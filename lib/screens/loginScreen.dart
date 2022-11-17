import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteaway/main.dart';
import 'package:wasteaway/models/client.dart';
import 'package:wasteaway/services/tests.dart';
import 'package:wasteaway/theme.dart';

import '../components/buttons.dart';
import '../components/inputBox.dart';
import '../services/authentication.dart';

var email = "";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString("email");
    setState(() {
       email = obtainedEmail!;
    });
    print("The email is: "+email);
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      if(email.isNotEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    email = "";
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/logo.png",width: 150,),
                    Text("Welcome back!",style: Theme.of(context).textTheme.headline1,),
                    SizedBox(height: 40,),
                    textInputBox(controller: emailController,inputLabel: "Email",inputType: TextInputType.emailAddress),
                    SizedBox(height: 15,),
                    passwordInputBox(passwordController: passwordController),
                    SizedBox(height: 15,),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password"),
                      ),
                    ),
                    SecondaryGreenButton(buttonText: "Login", onPressed: () {
                      emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty ? emailController
                          .text.contains("@")
                          ? login(
                          emailController.text, passwordController.text, context)
                          : Fluttertoast.showToast(
                        msg: "Your email must contain the @ symbol ",
                        backgroundColor: Color(cancelRedColor),
                      ) : Fluttertoast.showToast(
                        msg: "Please fill in all fields",
                        backgroundColor: Color(cancelRedColor),
                      );
                    }),
                    SizedBox(height: 20,),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Color(primaryBlueColor),
                          textStyle: TextStyle(fontWeight: FontWeight.normal)
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: Text("Don't have an account? Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
