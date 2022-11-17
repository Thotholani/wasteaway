import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/errorScreens.dart';
import '../models/pickupPoint.dart';
import '../services/pickupPointsService.dart';
import '../theme.dart';
import 'dashboardScreen.dart';

List<Marker> markers = [];
int runs = 0;

class PickupPointsScreen extends StatelessWidget {
  const PickupPointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    runs = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup Points"),
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
        child: Center(
            child: Container(
                child: showMyLocations(MediaQuery.of(context).size.height)
        )
        ),
      ),
    );
  }

  FutureBuilder<List<PickupPoint>> showMyLocations(double screenSize) {
    return FutureBuilder<List<PickupPoint>>(
      future: PickupPointService.getPickupPoints(user_id),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()
          );
        } else if (snapshot.hasError) {
          return Center(child: Column(
            children: [
              Image.asset("assets/images/error.png"),
              Text("Connection Lost", style: Theme
                  .of(context)
                  .textTheme
                  .headline3,),
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
        } else if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            final locations = snapshot.data!;
            return buildMapWithMarkers(locations, screenSize);
          } else {
            return NoInformation(
              errorDetail: 'You have no pickup location related to your account. Click the button below to create an on demand pickup request',
              errorHeading: '',
              onPressed: () {},
              buttonText: 'Create a location',);
          }
        } else {
          return Center(child: Column(
            children: [
              Image.asset("assets/images/no_information.png"),
              Text("No Locations", style: Theme
                  .of(context)
                  .textTheme
                  .headline3,),
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

  Widget buildMapWithMarkers(List<PickupPoint> pickupPoints, double deviceHeight) =>
      ListView.builder(
          itemCount: pickupPoints.length,
          itemBuilder: (context, index) {
            final pickupPoint = pickupPoints[index];

            Map<int, PickupPoint> pointsAsMap = pickupPoints.asMap();

            markers.add(
            Marker(
                markerId: MarkerId(index.toString(),
                ),
                position: LatLng(double.parse(pickupPoint.latitude),
                    double.parse(pickupPoint.longitude)),
                infoWindow: InfoWindow(title: pickupPoint.address)
            ));
            runs++;

            if(runs == pickupPoints.length) {
              return Container(
                height: deviceHeight,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(-15.4081, 28.2963),
                      zoom: 11.5
                  ),
                  markers: Set<Marker>.of(markers),
                ),
              );
            } else {
              return SizedBox(
                height: 0,
              );
            }
          });
}