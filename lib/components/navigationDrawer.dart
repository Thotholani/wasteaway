import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:wasteaway/screens/walletScreen.dart';
import 'package:wasteaway/screens/pickupPointsScreen.dart';
import 'package:wasteaway/screens/profileScreen.dart';
import 'package:wasteaway/services/authentication.dart';
import 'package:wasteaway/services/pageNavigation.dart';
import 'package:wasteaway/theme.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({required this.username,required this.email,required this.phoneNumber});
  final String username;
  final String email;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                  color: Color(primaryBlueColor),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: ProfileSummary(
                      email: email,
                      phoneNumber: phoneNumber,
                      username: username,
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  children: [
                    DrawerItem("Profile", FeatherIcons.user, () => drawerItemPressed(context, 0)),
                    DrawerItem("Pickup Points", FeatherIcons.mapPin, () => drawerItemPressed(context, 1)),
                    DrawerItem("Wallet", FeatherIcons.dollarSign, () => drawerItemPressed(context, 2)),
                    Divider(thickness: 1, height: 10, color: Color(greyishBlueColor),),
                    DrawerItem("Logout", FeatherIcons.logOut, () {
                      logout(context, "/login");
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(this.name, this.icon, this.onPressed);

  final String name;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: Color(primaryBlueColor),
            ),
            SizedBox(
              width: 25,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileSummary extends StatelessWidget {
  const ProfileSummary(
      {required this.email, required this.phoneNumber, required this.username});

  final String username;
  final String email;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: Theme.of(context).textTheme.headline5,
        ),
        Text(
          email,
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          phoneNumber,
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }
}

//navbar functions
void drawerItemPressed(BuildContext context, int pageIndex) {
  Navigator.pop(context);

  switch (pageIndex) {
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => PickupPointsScreen()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
      break;
  }
}
