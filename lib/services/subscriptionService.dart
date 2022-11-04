import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/progressDialog.dart';
import '../main.dart';
import '../models/subscriptionPlan.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';

String apiURL = MyApp().url;

class SubscriptionService {
  static Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    List<SubscriptionPlan> _subscriptionPlans = [];
    String url = apiURL;
    url = url+"/getSubscriptionPlans.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body.toString());
      // print(body);
      _subscriptionPlans = List.from(body.map<SubscriptionPlan>(SubscriptionPlan.fromJson).toList());
    }
    return _subscriptionPlans;
  }

  void subscribe(userId,locationId, subscriptionPlan, collectorId, BuildContext context) async {
    String url = apiURL;
    url = url + "/subscribe.php";

    var response = await http.post(Uri.parse(url), body: {
      'location_id': locationId.toString(), 'subscription_plan': subscriptionPlan.toString(), 'collector_id': collectorId.toString(),'user_id':userId });
    //if we get a response from server
    if (response.statusCode == 200) {
      print("This is the response " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialog(message: "Processing your \nsubscription.Please Wait...");
          },
          barrierDismissible: false);
      if (jsondata["success"]) {
        await Future.delayed(const Duration(seconds: 1), () {});
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Column(children: [
              Icon(FeatherIcons.checkCircle,size: 50,color: Color(secondaryGreenColor),),
              SizedBox(height: 5,),
              const Text('Success')
            ])),
            content: Text(jsondata["message"],style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: const Text('Dismiss',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(context, "/dashboard",(route) => false);
                },
              ),
            ],
          );
        });
      } else {
        await Future.delayed(const Duration(seconds: 2), () {});
        Navigator.pop(context);
      }
    } else {
      await Future.delayed(const Duration(seconds: 2), () {});
      Fluttertoast.showToast(
        msg: "Error connecting to server",
        backgroundColor: Color(cancelRedColor),
      );
    }
  }

  static Future<String> getSubscriptionPlan(String user_id) async {
    String url = apiURL;
    String subscriptionPlan = "";
    url = url+"/getMySubscriptionPlan.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsondata = jsonDecode(response.body.toString());
      subscriptionPlan = jsonDecode(jsondata['user_id']);
    }
    return subscriptionPlan;
  }
}