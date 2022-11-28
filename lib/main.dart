import 'package:flutter/material.dart';
import 'package:wasteaway/screens/subscription_screens/subscriptionCollectorScreen.dart';
import 'package:wasteaway/screens/confirmationScreen.dart';
import 'package:wasteaway/screens/dashboardScreen.dart';
import 'package:wasteaway/screens/loadCashScreen.dart';
import 'package:wasteaway/screens/locationScreen.dart';
import 'package:wasteaway/screens/loginScreen.dart';
import 'package:wasteaway/screens/ondemandScreen.dart';
import 'package:wasteaway/screens/pickupHistory.dart';
import 'package:wasteaway/screens/pinScreen.dart';
import 'package:wasteaway/screens/registerScreen.dart';
import 'package:wasteaway/screens/subscriptionScreen.dart';
import 'package:wasteaway/screens/walletScreen.dart';
import 'package:wasteaway/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  String url = "http://192.168.7.239 /wa_server";
  // String url = "https://wasteaway.000webhostapp.com";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Color(primaryBlueColor)),
          primaryColor: Color(primaryBlueColor),
          fontFamily: "Urbanist",
          textTheme: textTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          inputDecorationTheme: inputFormTheme,
          textButtonTheme: textButtonTheme,
          appBarTheme: appBarTheme,
          scaffoldBackgroundColor: Colors.white
      ),
      home: LoginScreen(),
      routes: {
        '/login' : (context) => LoginScreen(),
        '/register' : (context) => RegisterScreen(),
        '/dashboard' : (context) => DashboardScreen(),
        '/history' : (context) => PickupHistoryScreen(),
        '/ondemand' : (context) => OnDemandScreen(),
        '/confirmation' : (context) => ConfirmationScreen(),
        '/subscription' : (context) => SubscriptionScreen(),
        '/wallet' : (context) => WalletScreen(),
      },
    );
  }
}
