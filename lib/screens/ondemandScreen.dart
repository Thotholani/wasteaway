import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasteaway/services/pickupPointsService.dart';
import 'package:wasteaway/theme.dart';
import '../components/buttons.dart';
import '../components/cards.dart';
import '../components/errorScreens.dart';
import '../models/pickupPoint.dart';

late String user_id;

class OnDemandScreen extends StatefulWidget {
  const OnDemandScreen({Key? key}) : super(key: key);

  @override
  State<OnDemandScreen> createState() => _OnDemandScreenState();
}

class _OnDemandScreenState extends State<OnDemandScreen> {

  late SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      user_id = prefs.getString("user_id")!;
    });
  }

  late GoogleMapController googleMapController;

  static const double _defaultLat = 45.521563;
  static const double _defaultLng = -122.677433;
  static const CameraPosition _defaultLocation = CameraPosition(target: LatLng(_defaultLat, _defaultLng),zoom: 15);

  //location radio
  int locationId = 0;
  int selected = 10000;
  bool addressIsSelected = false;
  var selectedId = "";
  var selectedAddress = "";

  Widget customRadio(String address,int index,int id) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (selected == index) ? Color(secondaryGreenColor) : Color(iconButtonBackgroundColor)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Address: "+address,style: TextStyle(
                  color: (selected == index) ? Colors.white : Color(fontGreyColor),
                  fontSize: 20
              ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPickupPoints(List<PickupPoint> pickupPoints) => ListView.builder(
      itemCount: pickupPoints.length,
      itemBuilder: (context, index) {
        final pickupPoint = pickupPoints[index];
        return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
                selectedId = pickupPoint.location_id;
                selectedAddress = pickupPoint.address;
                addressIsSelected = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (selected == index) ? Color(secondaryGreenColor) : Color(iconButtonBackgroundColor)
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          pickupPoint.address,style: TextStyle(
                            color: (selected == index) ? Colors.white : Color(fontGreyColor),
                            fontSize: 12
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        leading: IconButton(icon: Icon(EvaIcons.arrowIosBack,size: 30,),onPressed: () {
          Navigator.pop(context);
        },),
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Select one of your pickup points"),
              SizedBox(height: 15,),
              Expanded(
                child: Container(
                  child: showMyLocations(),
                ),
              ),
              SizedBox(height: 15,),
              Text("Service Fee"),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount",style: Theme.of(context).textTheme.headline3,),
                  Text("K50.00", style: Theme.of(context).textTheme.headline3,)
                ],
              ),
              SizedBox(height: 20,),
              SecondaryGreenButton(onPressed: () {
                //Checks to see if address has been
                if(addressIsSelected) {
                  // print("Selected Id in on demand screen: ");
                  // print(selectedId);
                  PickupPointService.createCollection(selectedId, context,selectedAddress);
                } else {
                  Fluttertoast.showToast(
                    msg: "Please Select a pickup point",
                    backgroundColor: Color(cancelRedColor),
                  );
                }
              }, buttonText: 'Order Pickup',),
            ]
          ),
        ),
    ),
    );
  }

  FutureBuilder<List<PickupPoint>> showMyLocations() {
    return FutureBuilder<List<PickupPoint>>(
                  future: PickupPointService.getPickupPoints(user_id),
                  builder: (context, snapshot) {
                    print(snapshot);
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child:CircularProgressIndicator()
                      );
                    }else if(snapshot.hasError){
                      return Center(child: Column(
                        children: [
                          Image.asset("assets/images/error.png"),
                          Text("Connection Lost",style: Theme.of(context).textTheme.headline3,),
                          Text("${snapshot.error}"),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: 200,
                            height: 55,
                            child:
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Retry"),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: BorderSide(color: Color(primaryBlueColor))
                                      )
                                  )
                              ),
                            ),
                          )
                        ],
                      ));
                    } else if(snapshot.hasData) {
                      if(snapshot.data!.isNotEmpty) {
                        final locations = snapshot.data;
                        return buildPickupPoints(locations!);
                      } else {
                        return NoInformation(errorDetail: 'You have no pickup location related to your account. Click the button below to create an on demand pickup request', errorHeading: '', onPressed: () {  }, buttonText: 'Make Pickup Request',);
                      }
                    } else {
                      return Center(child: Column(
                        children: [
                          Image.asset("assets/images/no_information.png"),
                          Text("No Locations",style: Theme.of(context).textTheme.headline3,),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: 200,
                            height: 55,
                            child:
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("Retry"),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          side: BorderSide(color: Color(primaryBlueColor))
                                      )
                                  )
                              ),
                            ),
                          )
                        ],
                      ));
                    }
                  },
                );
  }
}
