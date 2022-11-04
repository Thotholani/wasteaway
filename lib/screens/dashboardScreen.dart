import 'dart:convert';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteaway/components/navigationDrawer.dart';
import 'package:wasteaway/components/progressDialog.dart';
import 'package:wasteaway/main.dart';
import 'package:wasteaway/screens/loadCashScreen.dart';
import 'package:wasteaway/screens/pickupPointsScreen.dart';
import 'package:wasteaway/screens/walletScreen.dart';
import 'package:wasteaway/services/pageNavigation.dart';
import 'package:wasteaway/services/subscriptionService.dart';
import 'package:wasteaway/theme.dart';
import '../components/cards.dart';
import '../services/authentication.dart';
import 'package:wasteaway/models/client.dart';
import 'package:http/http.dart' as http;

import '../services/fundsService.dart';

late String user_id = "";
late String name = "";
late String balance = "";
late String phoneNumber = "";
late String email = "";
late String subscriptionPlan = "";
late String number_of_pickups = "";
late String no_pickup_points = "";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      user_id = prefs.getString("user_id")!;
      name = sharedPrefs.getString("name")!;
      balance = sharedPrefs.getString("balance")!;
      phoneNumber = sharedPrefs.getString("phoneNumber")!;
      email = sharedPrefs.getString("email")!;
      subscriptionPlan = sharedPrefs.getString("subscription_plan")!;
      number_of_pickups = sharedPrefs.getString("number_of_pickups")!;
      no_pickup_points = sharedPrefs.getString("no_pickup_points")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: dashboardDrawerIconTheme,
      ),
      drawer: NavigationDrawer(
        username: name,
        phoneNumber: phoneNumber,
        email: email,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Hi " + name,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text("What are we doing today?",
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Row(
                    children: <Widget>[
                      SideDivider(
                        color: thirdYellowColor,
                      ),
                      SideDivider(color: primaryBlueColor),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(palateGreenColor),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
                                },
                                child: CardContent(
                                  heading: "Balance",
                                  details: "K"+balance+".00",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PickupPointsScreen()));
                                },
                                child: CardContent(
                                  heading: "Pickup Points",
                                  details: no_pickup_points,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Services", style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ServiceCard(
                      icon: FeatherIcons.package,
                      text: "On Demand\nPickup",
                      function: () async {
                        if (double.parse(await getBalance(user_id)) < 80) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Column(children: [
                                        Icon(
                                          FeatherIcons.alertCircle,
                                          size: 50,
                                          color: Color(thirdYellowColor),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        const Text('Balance is Low')
                                      ])),
                                  content: Text(
                                    "Would you like to load cash to proceed with the on-demand pickup?",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoadCashScreen(
                                                        user_id: user_id,navigation: "/ondemand",)));
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              barrierDismissible: false);
                          await Future.delayed(const Duration(seconds: 3), () {});
                        } else {
                          navigateToPage("/ondemand", context);
                        }
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ServiceCard(
                        icon: FeatherIcons.clock,
                        text: "Pickup\nHistory",
                        function: () {
                          navigateToPage("/history", context);
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    ServiceCard(
                      icon: FeatherIcons.creditCard,
                      text: "Collection\nSubscription",
                      function: () async {
                        if (double.parse(await getBalance(user_id)) < 80) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Column(children: [
                                    Icon(
                                      FeatherIcons.alertCircle,
                                      size: 50,
                                      color: Color(thirdYellowColor),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    const Text('Balance is Low')
                                  ])),
                                  content: Text(
                                    "Would you like to load cash to proceed with the subscription?",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoadCashScreen(
                                                        user_id: user_id,navigation: "/subscription",)));
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                              barrierDismissible: false);
                          await Future.delayed(const Duration(seconds: 3), () {});
                        } else {
                          navigateToPage("/subscription", context);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Subscription Plan",
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Color(palateGreenColor),
                          borderRadius: BorderRadius.horizontal(left:Radius.circular(15))),
                      width: 115,
                      child: RotatedBox(quarterTurns: 3,
                      child: Center(child: Text("SUBSCRIPTION PLAN", style: TextStyle(color: Color(primaryBlueColor),fontWeight: FontWeight.w600),))),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Color(primaryBlueColor),
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(EvaIcons.creditCard,size: 55,color: Color(palateGreenColor),),
                              Text(subscriptionPlan,style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.w600),textAlign: TextAlign.center ,),
                              Text("${number_of_pickups} Pickups/month",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)
                            ],
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
