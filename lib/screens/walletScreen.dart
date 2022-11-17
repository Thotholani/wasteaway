import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/screens/dashboardScreen.dart';

import '../theme.dart';
import 'loadCashScreen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet"),
        leading: IconButton(
          icon: Icon(
            EvaIcons.arrowIosBack,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 80,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(thirdYellowColor),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15))),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.height * 0.02,
                  decoration: BoxDecoration(
                      color: Color(palateGreenColor),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15))),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(primaryBlueColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Balance",
                          style: TextStyle(
                              color: Color(greyishBlueColor),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("K$balance.00",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width * 0.15,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoadCashScreen(
                                                user_id: user_id,navigation: "/wallet",)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.dollarSign,
                                    color: Color(primaryBlueColor),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    "Load Cash",
                                    style:
                                        TextStyle(color: Color(primaryBlueColor)),
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ))
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Transaction History",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                Spacer(),
                Image.asset("assets/images/no_transaction.png",width: MediaQuery.of(context).size.height * 0.4,),
                Spacer(),
                Text(
                  "No Transactions Yet",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text("Load funds from your mobile money to create a transaction",textAlign: TextAlign.center,),
                Spacer()
              ],
            ),
        ),
          ),
    );
  }
}
