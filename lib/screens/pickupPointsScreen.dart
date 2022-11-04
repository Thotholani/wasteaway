import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/errorScreens.dart';
import '../models/pickupPoint.dart';
import '../services/pickupPointsService.dart';
import '../theme.dart';
import 'dashboardScreen.dart';

class PickupPointsScreen extends StatelessWidget {
  const PickupPointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: showMyLocations()
            )
        )
        ),
      ),
    );
  }

  FutureBuilder<List<PickupPoint>> showMyLocations() {
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
            return buildMapWithMarkers(locations);
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

  // Widget buildMapWithMarkers(List<PickupPoint> pickupPoints) {
  //   print(
  //       "Printing what is in pickupPointsVariable after connection is successful:");
  //   print(pickupPoints);
  //
  //   List<Marker> markers = [];
  //   Map<int, PickupPoint> pointsAsMap = pickupPoints.asMap();
  //
  //   for (int i = 0; i <= pickupPoints.length; i++) {
  //     var latitude = pointsAsMap[i]!.latitude;
  //     var longitude = pointsAsMap[i]!.longitude;
  //
  //     markers.add(
  //         Marker(
  //             markerId: MarkerId(i.toString(),
  //             ),
  //             position: LatLng(double.parse(latitude), double.parse(longitude)),
  //             infoWindow: InfoWindow(title: pointsAsMap[i]!.address)
  //         )
  //     );
  //   }
  //   print("Printing markers");
  //   print(markers);
  //   return GoogleMap(
  //     initialCameraPosition: CameraPosition(
  //         target: LatLng(-15.4081, 28.2963),
  //         zoom: 11.5
  //     ),
  //     markers: Set<Marker>.of(markers),
  //   );
  // }

  Widget buildMapWithMarkers(List<PickupPoint> pickupPoints) =>
      ListView.builder(
          itemCount: pickupPoints.length,
          itemBuilder: (context, index) {
            final pickupPoint = pickupPoints[index];

            List<Marker> markers = [];
            Map<int, PickupPoint> pointsAsMap = pickupPoints.asMap();

            markers.add(
            Marker(
                markerId: MarkerId(index.toString(),
                ),
                position: LatLng(double.parse(pickupPoint.latitude),
                    double.parse(pickupPoint.longitude)),
                infoWindow: InfoWindow(title: pickupPoint.address)
            ));

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(-15.4081, 28.2963),
                  zoom: 11.5
              ),
              markers: Set<Marker>.of(markers),
            );
          });
}