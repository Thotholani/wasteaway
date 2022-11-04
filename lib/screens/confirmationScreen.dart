import 'package:flutter/material.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/services/pageNavigation.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/confirmation_tick.png",width: 150,),
            SizedBox(height: 20,),
            Text("Registration Complete",textAlign:TextAlign.center,style: Theme.of(context).textTheme.headline1,),
            SizedBox(height: 20,),
            Text("Your account has successfully been created! Click back to login to be redirected to the login page", style: Theme.of(context).textTheme.bodyText2,textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            SecondaryGreenButton(buttonText: "Back to Login", onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            })
          ],
        ),
      ),
    );
  }
}
