import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteaway/theme.dart';
import '../components/progressDialog.dart';
import '../main.dart';
import 'package:wasteaway/models/client.dart';

String apiURL = MyApp().url;

Future<void> register(name, email, phoneNumber, password, pin, address,addressName, latitude, longitude, BuildContext context) async {
  String url = apiURL;
  url = url + "/register.php";

  print("Latitude right before sending to server: ${latitude}");
  print("Longitude: ${longitude}");

  var response = await http.post(Uri.parse(url), body: {
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'pin': pin,
    'address': address,
    'addressName':addressName,
    'latitude': latitude,
    'longitude': longitude,
  });
  //if we get a response from server
  if (response.statusCode == 200) {
    print(response.body);
    print("This is the response body: " + response.body.toString());
    var jsondata = jsonDecode(response.body.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProgressDialog(
              message: "We're setting you up.\nHold on Tight...");
        },
        barrierDismissible: false);
    if (jsondata["success"]) {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, "/confirmation", (route) => false);
    } else {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: jsondata["message"],
        backgroundColor: Color(0xFFDE2222),
      );
      // print("Failed to create account");
    }
  } else {
    await Future.delayed(const Duration(seconds: 2), () {});
    // Navigator.pop(context);
    Fluttertoast.showToast(
      msg: "Error connecting to server",
      backgroundColor: Color(0xFFDE2222),
    );
    // print("Error connecting to server");
  }
}

void login(email, password, BuildContext context) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Authenticating...");
      },
      barrierDismissible: false);

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  String url = apiURL;
  url = url + "/login.php";

  var response = await http
      .post(Uri.parse(url), body: {'email': email, 'password': password});
  //if we get a response from server
  if (response.statusCode == 200) {
    print("This is the response " + response.body.toString());
    var jsondata = jsonDecode(response.body.toString());
    if (jsondata["success"]) {
      await Future.delayed(const Duration(seconds: 1), () {});
      sharedPreferences.setString("user_id", jsondata['user_id']);
      sharedPreferences.setString("name", jsondata['name']);
      sharedPreferences.setString("phoneNumber", jsondata['phoneNumber']);
      sharedPreferences.setString("balance", jsondata['balance']);
      sharedPreferences.setString("email", jsondata['email']);
      sharedPreferences.setString("subscription_plan", jsondata['package_plan']);
      sharedPreferences.setString("number_of_pickups", jsondata['number_of_pickups']);
      sharedPreferences.setString("no_pickup_points", jsondata['no_pickup_points']);

      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
      Fluttertoast.showToast(
        msg: "Welcome " + sharedPreferences.getString("name").toString(),
        backgroundColor: Color(secondaryGreenColor),
      );
    } else {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: jsondata["message"],
        backgroundColor: Color(cancelRedColor),
      );
    }
  } else {
    await Future.delayed(const Duration(seconds: 2), () {});
    Fluttertoast.showToast(
      msg: "Error connecting to server",
      backgroundColor: Color(cancelRedColor),
    );
  }
}

void logout(BuildContext context, String path) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.remove("user_id");
  sharedPreferences.remove("name");
  sharedPreferences.remove("phoneNumber");
  sharedPreferences.remove("balance");
  sharedPreferences.remove("email");
  sharedPreferences.remove("subscription_plan");
  sharedPreferences.remove("number_of_pickups");
  sharedPreferences.remove("no_pickup_points");

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: "Logging Out...");
      },
      barrierDismissible: false
  );
  await Future.delayed(const Duration(seconds: 2), () {});
  Navigator.pop(context);

  Navigator.pop(context);
  Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  Fluttertoast.showToast(
    msg: "Logout Successful",
    backgroundColor: Color(secondaryGreenColor),
  );
}
