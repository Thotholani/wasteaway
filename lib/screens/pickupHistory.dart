import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import "package:flutter/material.dart";
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/components/cards.dart';
import 'package:wasteaway/models/collection.dart';
import 'package:wasteaway/services/collectionsService.dart';

import '../components/errorScreens.dart';
import '../services/pageNavigation.dart';
import '../theme.dart';
import 'dashboardScreen.dart';

class PickupHistoryScreen extends StatefulWidget {
  const PickupHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PickupHistoryScreen> createState() => _PickupHistoryScreenState();
}

class _PickupHistoryScreenState extends State<PickupHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pickup History"),
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
        child: Column(
          children: [
            Expanded(child: getMyCollections()),
          ],
        ),
      )),
    );
  }

  FutureBuilder<List<Collection>> getMyCollections() {
    return FutureBuilder<List<Collection>>(
      future: CollectionsService.getCollections(user_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ConnectionError(errorDetail: snapshot.error.toString(), errorHeading: 'Connection Error',);
        } else if (snapshot.hasData) {
          if(snapshot.data!.isNotEmpty) {
            final collections = snapshot.data;
            return buildCollections(collections!);
          } else {
            return NoInformation(errorDetail: 'You have no past or present pickup requests. Click the button below to create an on demand pickup request', errorHeading: 'No Collections Available', onPressed: () {
              navigateToPage("/ondemand", context);
            }, buttonText: 'Make Pickup Request',);
          }
        } else {
          return Center(
            child: Column(
                children: [
                  Image.asset("assets/images/404.png"),
                  Text("Page Not Found",style: Theme.of(context).textTheme.headline3,)
                ]
            ),
          );
        }
      },
    );
  }

  Widget buildCollections(List<Collection> collections) => ListView.builder(
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        return PickupCard(
            collectionNumber: int.parse(collection.collectionId),
            date: collection.collectionDate,
            fee: double.parse(collection.fee),
            status: collection.status);
      });
}