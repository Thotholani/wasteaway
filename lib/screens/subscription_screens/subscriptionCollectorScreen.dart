import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wasteaway/components/buttons.dart';
import 'package:wasteaway/models/collector.dart';
import 'package:wasteaway/services/authentication.dart';
import '../../components/cards.dart';
import '../../theme.dart';
import 'package:http/http.dart' as http;
import 'package:wasteaway/main.dart';
import 'dart:async';

class CollectorsScreen extends StatefulWidget {

  CollectorsScreen();

  @override
  State<CollectorsScreen> createState() => _CollectorsScreenState();
}

class _CollectorsScreenState extends State<CollectorsScreen> {
  int collectorId = 0;
  int selectedCollectorId = 0;
  Future<List<Collector>> collectorsFuture = getCollectors();

  static Future<List<Collector>> getCollectors() async {
    String getCollectorUrl = MyApp().url + "/getCollectors.php";

    final response = await http.get(Uri.parse(getCollectorUrl));
    final body = json.decode(response.body);
    return List.from(body.map<Collector>(Collector.fromJson).toList());
  }

  Widget customRadio(String name, int index, double rating) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCollectorId = index;
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
                "Name: " + name,
                style: TextStyle(
                    color: (selectedCollectorId == index)
                        ? Colors.white
                        : Color(fontGreyColor),
                    fontSize: 20),
              ),
              Text("Rating: " + rating.toString(),
                  style: TextStyle(
                      color: (selectedCollectorId == index)
                          ? Colors.white
                          : Color(fontGreyColor),
                      fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCollectors(List<Collector> collectors) => ListView.builder(
      itemCount: collectors.length,
      itemBuilder: (context, index) {
        final collector = collectors[index];

        return GestureDetector(
            onTap: () {
              setState(() {
                selectedCollectorId = index;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 22),
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
    );
  }
}
