import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/progressDialog.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';

String apiURL = MyApp().url;

  void loadFunds(String userId, String amount, BuildContext context, String navigationPoint) async {
    String url = apiURL;
    url = url+"/loadFunds.php";

    // final response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
      'amount':amount
    });

    if (response.statusCode == 200) {
      print("This is the response " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialog(message: "Contacting mobile \nmoney services...");
          },
          barrierDismissible: false);
      if (jsondata["success"]) {
        await Future.delayed(const Duration(seconds: 1), () {});
        Navigator.pop(context);

        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("balance", jsondata['balance']);

        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Column(children: [
              Image.asset("assets/images/confirmation_tick.png",width: MediaQuery.of(context).size.height * 0.1,),
              SizedBox(height: 5,),
              const Text('Success')
            ])),
            content: Text("Funds Loaded Successfully. Click continue to proceed.",style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: const Text('Continue',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, navigationPoint);
                },
              ),
            ],
          );
        });
      } else {
        await Future.delayed(const Duration(seconds: 2), () {});
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata["message"],
          backgroundColor: Color(cancelRedColor),
        );
      }
    }
  }

  Future<String> getBalance(String userId) async {
    String balance = "";
    String url = apiURL;
    url = url+"/getBalance.php";
    // final response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
    });

    if (response.statusCode == 200) {
      print("This is the response " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["success"]) {
        balance = jsondata["balance"];
      } else {
        print("Unable to get your balance");
      }
    }
    return balance;
  }