import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wasteaway/models/collection.dart';
import 'dart:convert';
import '../components/progressDialog.dart';
import '../main.dart';
import '../theme.dart';

class CollectionsService {
  static Future<List<Collection>> getCollections(String userId) async {
    String url = MyApp().url + "/getCollections.php";

    var response = await http.post(Uri.parse(url), body: {
      'user_id': userId,
    });

    final body = json.decode(response.body);
    return List.from(body.map<Collection>(Collection.fromJson).toList());
  }

  static void cancelRequest(String collectionId, BuildContext context) async {
    String url = MyApp().url;
    url = url+"/cancelRequest.php";

    // final response = await http.get(Uri.parse(url));
    var response = await http.post(Uri.parse(url), body: {
      'collection_id': collectionId,
    });

    if (response.statusCode == 200) {
      print("This is the response " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialog(message: "Canceling Request.\n Please Wait...");
          },
          barrierDismissible: false);
      if (jsondata["success"]) {
        await Future.delayed(const Duration(seconds: 1), () {});
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Column(children: [
              Icon(FeatherIcons.checkCircle,size: 50,color: Color(secondaryGreenColor),),
              SizedBox(height: 5,),
              const Text('Success')
            ])),
            content: Text(jsondata["message"],style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: const Text('Dismiss',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      } else {
        await Future.delayed(const Duration(seconds: 2), () {});
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata["message"],
          backgroundColor: Color(cancelRedColor),
        );
      }
    }
  }

  static void cancelOnDemandRequest(BuildContext context) async {
    String url = MyApp().url;
    url = url+"/cancelOnDemandRequest.php";

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("This is the response " + response.body.toString());
      var jsondata = jsonDecode(response.body.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ProgressDialog(message: "Canceling Request.\n Please Wait...");
          },
          barrierDismissible: false);
      if (jsondata["success"]) {
        await Future.delayed(const Duration(seconds: 1), () {});
        Navigator.pop(context);
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Column(children: [
              Image.asset("assets/images/confirmation_tick.png",width: MediaQuery.of(context).size.height * 0.1,),
              SizedBox(height: 5,),
              const Text('Success')
            ])),
            content: Text(jsondata["message"],style: Theme.of(context).textTheme.bodyText1,),
            actions: [
              TextButton(
                child: const Text('Dismiss',style: TextStyle(color: Colors.green),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      } else {
        await Future.delayed(const Duration(seconds: 2), () {});
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata["message"],
          backgroundColor: Color(cancelRedColor),
        );
      }
    }
  }
}