import 'package:flutter/material.dart';
import '../theme.dart';

class SecondaryGreenButton extends StatelessWidget {
  SecondaryGreenButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ElevatedButton.styleFrom(primary: Color(secondaryGreenColor)),
      ),
    );
  }
}

class PrimaryBlueButton extends StatelessWidget {
  PrimaryBlueButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ElevatedButton.styleFrom(primary: Color(primaryBlueColor)),
      ),
    );
  }
}

class CancelRedButton extends StatelessWidget {
  CancelRedButton({required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ElevatedButton.styleFrom(primary: Color(cancelRedColor)),
      ),
    );
  }
}

class CircularIconButton extends StatelessWidget {
  CircularIconButton({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(secondaryGreenColor)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class FrontIconButton extends StatelessWidget {
  FrontIconButton({required this.icon, required this.color, required this.buttonText, required this.onPressed});
  IconData icon;
  int color;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child:
          ElevatedButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                SizedBox(width: 30,),
                Text(buttonText),
              ],
            ),
            style: ElevatedButton.styleFrom(primary: Color(color)),
          ),
    );
  }
}

class ColorButton extends StatelessWidget {
  ColorButton({required this.buttonText, required this.onPressed, required this.color});

  final String buttonText;
  final VoidCallback onPressed;
  final int color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
        style: ElevatedButton.styleFrom(primary: Color(color)),
      ),
    );
  }
}
