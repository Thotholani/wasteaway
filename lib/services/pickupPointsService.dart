import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteaway/models/pickupPoint.dart';
import 'package:http/http.dart' as http;
import '../components/cards.dart';
import '../components/progressDialog.dart';
import '../main.dart';
import '../theme.dart';

String apiURL = MyApp().url;

class PickupPointService {
  static Future<List<PickupPoint>> getPickupPoints(String id) async {
    List<PickupPoint> _pickupPoints = [];
    String url = apiURL;
    url = url+"/getLocations.php";

    // final response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: {
      'user_id': id,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body.toString());
      print(body);
      _pickupPoints =
          List.from(body.map<PickupPoint>(PickupPoint.fromJson).toList());
    }
    return _pickupPoints;
  }

  static Future<void> createCollection(String location_id, BuildContext context, String selectedAddress) async {
    String url = apiURL;
    url = url+"/makeOnDemandRequest.php";

    print("Location id in api call: ");
    print(location_id);

    var response = await http.post(Uri.parse(url), body: {
      'location_id': location_id
    });

    if (response.statusCode == 200) {
      print(response.body);
      print("This is the response: " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["success"]) {
        bottomModal(context,selectedAddress);
      } else {
        Fluttertoast.showToast(
          msg: jsondata["message"],
          backgroundColor: Color(cancelRedColor),
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Error connecting to server",
        backgroundColor: Color(cancelRedColor),
      );
    }
  }
}