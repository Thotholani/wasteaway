import 'dart:async';
import 'dart:ffi';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/components/inputBox.dart';
import 'package:wasteaway/screens/subscription_screens/subscriptionCollectorScreen.dart';
import 'package:wasteaway/services/authentication.dart';
import 'package:wasteaway/theme.dart';
import 'package:geocoding/geocoding.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.username, this.email, this.phoneNumber, this.password, this.pin);

  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String pin;
  double latitude = 0;
  double longitude = 0;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late StreamSubscription<Position> streamSubscription;

  final locationController = TextEditingController();
  late GoogleMapController googleMapController;

  static const double _defaultLat = 45.521563;
  static const double _defaultLng = -122.677433;
  static const CameraPosition _defaultLocation = CameraPosition(target: LatLng(_defaultLat, _defaultLng),zoom: 15);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    List<String> coordinates = [];
    bool isLoading = false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Setup pickup point",style: Theme.of(context).textTheme.headline1,),
                SizedBox(height: 10,),
                Text("Click the blue get location button and we’ll automatically setup your collection point",style: Theme.of(context).textTheme.bodyText2),
                SizedBox(height: 30,),
                textInputBox(inputType: TextInputType.streetAddress, controller: locationController, inputLabel: 'Enter Location',),
                SizedBox(height: 30,),
                Container(
                  height: 250,
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: (GoogleMapController gmapCon) {
                          googleMapController = gmapCon;
                        },
                        zoomControlsEnabled: false,
                        markers: markers,
                        initialCameraPosition: _defaultLocation,
                      ),
                      Positioned(
                        bottom: 10,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(primaryBlueColor),
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: isLoading == true ? CircularProgressIndicator(color: Colors.white,) : IconButton(
                              color: Colors.white,
                              icon: Icon(
                                  EvaIcons.pinOutline
                              ),
                              onPressed: () async {
                                setState((){
                                  isLoading = true;
                                });
                                Position position = await _determinedPosition();
                                googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));
                                markers.clear();
                                markers.add(Marker(markerId: MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));
                                var addressInText = await getAddressInText(position.latitude, position.longitude);
                                widget.latitude = position.latitude;
                                widget.longitude = position.longitude;
                                locationController.text = addressInText;
                                setState((){
                                  isLoading = false;
                                });
                                },
                            ),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                SecondaryGreenButton(buttonText: "Finish", onPressed: () {
                  widget.latitude != 0.0 && widget.longitude != 0.0 ? register(widget.username,widget.email,widget.phoneNumber,widget.password,widget.pin,locationController.text,widget.latitude.toString(),widget.longitude.toString(),context)
                  : Fluttertoast.showToast(
                    msg: "Please click the blue location button to get your location",
                    backgroundColor: Color(cancelRedColor),
                  );
                  print("Printing coordinates");
                  print(widget.latitude);
                  print(widget.longitude);
                  })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinedPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) {
      return Future.error("Location Service is disabled");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error("Location Permission is disabled");
      }
    }
    if(permission == LocationPermission.deniedForever) {
      return Future.error("Location Permission are permanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<String> getAddressInText(double lat, double long) async {

    const _apiKey = 'AIzaSyCZZ_8RSLTF0eQIyjXpjXb51AwanWMm-yg';
    final LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);
    final addressSecond = await geocoder
        .findAddressesFromCoordinates(Coordinates(lat, long));
  addressSecond.first.featureName;

    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    // print(placemark);
    Placemark place = placemark[0];
    // print(place);
    var address = "${place.street!}, ${place.subAdministrativeArea!} ${place.locality!}, ${place.administrativeArea!}, ${place.country!}";
    print("This is the address: $address");
    return address;
  }
}
