import 'package:flutter/material.dart';

import '../theme.dart';

class ConnectionError extends StatelessWidget {
  ConnectionError({required this.errorHeading, required this.errorDetail});
  final String errorHeading;
  final String errorDetail;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Image.asset("assets/images/error.png"),
            Text(
              errorHeading,
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(errorDetail, textAlign: TextAlign.center),
          ],
        )
    );
  }
}

class NoInformation extends StatelessWidget {
  NoInformation({required this.errorHeading, required this.errorDetail, required this.buttonText, required this.onPressed});
  final String errorHeading;
  final String errorDetail;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            Image.asset("assets/images/no_information.png"),
            Text(
              errorHeading,
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(errorDetail,textAlign: TextAlign.center),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 55,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side:
                            BorderSide(color: Color(primaryBlueColor))))),
              ),
            )
          ]
      ),
    );
  }
}
