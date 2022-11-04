import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/screens/locationScreen.dart';
import 'package:wasteaway/theme.dart';
import '../components/inputBox.dart';
import '../services/tests.dart';

class PinScreen extends StatefulWidget {
  PinScreen(this.name, this.email, this.phoneNumber, this.password);

  final String name;
  final String email;
  final String phoneNumber;
  final String password;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final pinController = OtpFieldController();
  var pin = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                Image.asset("assets/images/lock.png"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Set a PIN Code",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "Enter a 4 digit code to use in case you get locked out of your account",
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 30,
                ),
                PinBox(
                  pinController: pinController,
                  onCompleted: (value) {
                    pin = value!;
                  },
                ),
                SizedBox(
                  height: 35,
                ),
                PrimaryBlueButton(
                    buttonText: 'Submit',
                    onPressed: () {
                      pin.length != 4 ? Fluttertoast.showToast(
                        msg: "Please enter a 4 digit pin",
                        backgroundColor: Color(cancelRedColor),
                      ) :
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen(widget.name, widget.email, widget.phoneNumber, widget.password, pin)));
                      pin = "";
                      setState((){
                        pinController.clear();
                      });
                    }),
                SizedBox(
                  height: 15,
                ),
                Text("This PIN will also be used in our USSD application")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
