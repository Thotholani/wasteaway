import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteaway/components/inputBox.dart';
import 'package:wasteaway/screens/ondemandScreen.dart';

import '../components/buttons.dart';
import '../services/fundsService.dart';
import '../theme.dart';

class LoadCashScreen extends StatefulWidget {
  LoadCashScreen({required this.user_id});
  final String user_id;

  @override
  State<LoadCashScreen> createState() => _LoadCashScreenState();
}

class _LoadCashScreenState extends State<LoadCashScreen> {
  final phoneNumberController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Load funds"),
        leading: IconButton(icon: Icon(EvaIcons.arrowIosBack,size: 30,),onPressed: () {
          Navigator.pop(context);
        },),
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                Text("Load funds from Airtel Money, MTN MoMo or Zamtel Kwacha. Mobile money transfers are not reversile so please triple check the recipient number"),
                SizedBox(height: 35,),
                textInputBox(controller: phoneNumberController,inputLabel: "Phone Number",inputType: TextInputType.phone),
                SizedBox(height: 15,),
                textInputBox(controller: amountController,inputLabel: "Amount",inputType: TextInputType.number),
                SizedBox(height: 25,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SecondaryGreenButton(
                    buttonText: 'Load Funds',
                    onPressed: () {
                      validateInputs(widget.user_id, phoneNumberController.text, amountController.text, context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> validateInputs(String userId,String number, String amount,BuildContext context) async {
    if(number.isNotEmpty && amount.isNotEmpty) {
      if(double.parse(amount) >= 80) {
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        setState((){sharedPreferences.setString("balance", amount);});
        loadFunds(userId,amount,context);
        // print("User id: " + widget.user_id);
      } else {
        Fluttertoast.showToast(
          msg: "Please enter deposit a minimum of 80 kwacha",
          backgroundColor: Color(cancelRedColor),
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all input fields",
        backgroundColor: Color(cancelRedColor),
      );
    }
  }
}


