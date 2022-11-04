import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/models/subscriptionPlan.dart';
import 'package:wasteaway/services/subscriptionService.dart';
import 'package:wasteaway/theme.dart';
import '../components/errorScreens.dart';
import '../main.dart';
import '../models/collector.dart';
import '../models/pickupPoint.dart';
import '../services/collectorsService.dart';
import '../services/pickupPointsService.dart';
import 'dashboardScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final controller = PageController();
  bool onLastPage = false;

  int locationId = 0;
  int selected = 10000;
  int selectedPlanIndex = 10000;
  bool addressIsSelected = false;
  bool planIsSelected = false;
  String selectedAddress = "";
  String chosenSubscriptionPlan = "";
  String selectedLocationId = "";
  int collectorId = 0;
  int selectedCollectorId = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget customRadio(String address, int index, int id) {
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
              color: (selected == index)
                  ? Color(secondaryGreenColor)
                  : Color(iconButtonBackgroundColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Address: " + address,
                style: TextStyle(
                    color: (selected == index)
                        ? Colors.white
                        : Color(fontGreyColor),
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLocations(List<PickupPoint> pickupPoints) => ListView.builder(
      itemCount: pickupPoints.length,
      itemBuilder: (context, index) {
        final pickupPoint = pickupPoints[index];
        return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
                selectedLocationId = pickupPoint.location_id;
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
                    color: (selected == index)
                        ? Color(secondaryGreenColor)
                        : Color(iconButtonBackgroundColor)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          pickupPoint.address,
                          style: TextStyle(
                              color: (selected == index)
                                  ? Colors.white
                                  : Color(fontGreyColor),
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      });

  Widget buildSubscriptionPlans(List<SubscriptionPlan> subscriptionPlans) =>
      ListView.builder(
          itemCount: subscriptionPlans.length,
          itemBuilder: (context, index) {
            final subscriptionPlan = subscriptionPlans[index];
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPlanIndex = index;
                    chosenSubscriptionPlan =
                        subscriptionPlans[selectedPlanIndex].subscription_plan;
                    planIsSelected = true;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: (selectedPlanIndex == index)
                              ? Color(secondaryGreenColor)
                              : Color(iconButtonBackgroundColor),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                      // color: (selected == index) ? Color(secondaryGreenColor) : Color(iconButtonBackgroundColor)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(subscriptionPlan.billing_time),
                                    Text(
                                      "K" + subscriptionPlan.fee + "/month",
                                      style: TextStyle(
                                          color: Color(primaryBlueColor),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("for " +
                                        subscriptionPlan.number_of_pickups +
                                        " pickups")
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: (selectedPlanIndex == index)
                                        ? Color(secondaryGreenColor)
                                        : Color(iconButtonBackgroundColor),
                                  ),
                                  height: 15,
                                  width: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });

  Widget buildCollectors(List<Collector> collectors) => ListView.builder(
      itemCount: collectors.length,
      itemBuilder: (context, index) {
        final collector = collectors[index];

        return GestureDetector(
            onTap: () {
              setState(() {
                selectedCollectorId = index;
                collectorId = int.parse(collectors[selectedCollectorId].collector_id);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (selectedCollectorId == index)
                        ? Color(secondaryGreenColor)
                        : Color(iconButtonBackgroundColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Name: " + collector.name,
                      style: TextStyle(
                          color: (selectedCollectorId == index)
                              ? Colors.white
                              : Color(fontGreyColor),
                          fontSize: 20),
                    ),
                    Text("Rating: " + collector.rating.toString(),
                        style: TextStyle(
                            color: (selectedCollectorId == index)
                                ? Colors.white
                                : Color(fontGreyColor),
                            fontSize: 20))
                  ],
                ),
              ),
            ));
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            onLastPage = (index == 2);
          });
        },
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Select a Location",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Select one of your pickup points"),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        child: showMyLocations(),
                      ),
                    ),
                  ]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Select a Subscription Plan",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Choose a plan you'd want to subscribe to."),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        child: showSubscriptionPlans(),
                      ),
                    ),
                  ]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
              child: Column(
                children: [
                  Text(
                    "Select a collector",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Choose a collector that you'd like to service your location",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: FutureBuilder<List<Collector>>(
                      future: collectorsFuture,
                      builder: (context, snapshot) {
                        print(snapshot);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("😞 ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          final collectors = snapshot.data;
                          return buildCollectors(collectors!);
                        } else {
                          return const Center(child: Text("No Collectors"));
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Container(
          alignment: Alignment(0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SmoothPageIndicator(
                  effect: WormEffect(
                      activeDotColor: Color(secondaryGreenColor),
                      dotColor: Color(greyishBlueColor)),
                  controller: controller,
                  count: 3),
              onLastPage
                  ? GestureDetector(
                      onTap: () {
                        print("Selected Plan: $chosenSubscriptionPlan");
                        print("Selected location: $selectedLocationId");
                        print("Selected Collector: $collectorId");
                        if(collectorId == 0 || chosenSubscriptionPlan.isEmpty || selectedLocationId.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Please select a location, subscription plan and collector",
                            backgroundColor: Color(cancelRedColor),
                          );
                        } else {
                          SubscriptionService().subscribe(user_id,selectedLocationId, chosenSubscriptionPlan, collectorId, context);
                        }
                      },
                      child: CircularIconButton(
                        icon: EvaIcons.checkmark,
                        text: "Subscribe",
                      ))
                  : GestureDetector(
                      onTap: () {
                        controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: CircularIconButton(
                        icon: EvaIcons.arrowIosForward,
                        text: "Next",
                      )),
            ],
          ))
    ]));
  }

  FutureBuilder<List<PickupPoint>> showMyLocations() {
    return FutureBuilder<List<PickupPoint>>(
      future: PickupPointService.getPickupPoints(user_id),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ConnectionError(errorDetail: snapshot.error.toString(), errorHeading: 'Connection Error',);;
        } else if (snapshot.hasData) {
          if(snapshot.data!.isNotEmpty){
            final locations = snapshot.data;
            return buildLocations(locations!);
          } else {
            return NoInformation(errorDetail: "You don't hav`e any pickup location", errorHeading: '', onPressed: () {  }, buttonText: 'Register a pickup location',);
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

  FutureBuilder<List<SubscriptionPlan>> showSubscriptionPlans() {
    return FutureBuilder<List<SubscriptionPlan>>(
      future: SubscriptionService.getSubscriptionPlans(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("😞 ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final subscriptions = snapshot.data;
          return buildSubscriptionPlans(subscriptions!);
        } else {
          return const Center(child: Text("No subscriptions"));
        }
      },
    );
  }

  Future<List<Collector>> collectorsFuture = CollectorsService.getCollectors();
}
