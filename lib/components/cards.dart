import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasteaway/services/collectionsService.dart';
import 'package:wasteaway/services/ticketsService.dart';

import '../theme.dart';
import 'buttons.dart';

class SideDivider extends StatelessWidget {
  SideDivider({required this.color});
  int color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(color),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      width: 10,
    );
  }
}

class CardContent extends StatelessWidget {
  CardContent({required this.heading,required this.details});
  String heading;
  String details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(heading,style: TextStyle(color: Color(primaryBlueColor),fontSize: 15, fontWeight: FontWeight.bold),),
        Text(details,style: TextStyle(color: Color(primaryBlueColor),fontSize: 24,fontWeight: FontWeight.bold))
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  ServiceCard({required this.icon, required this.text, required this.function});
  IconData icon;
  String text;
  VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: function,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color(iconButtonBackgroundColor)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,color: Color(secondaryGreenColor),),
              SizedBox(height: 15,),
              Text(text,style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}

// Collection Card
  
  class PickupCard extends StatefulWidget {
    PickupCard({required this.collectionNumber,required this.date,required this.fee,required this.status});
    int collectionNumber;
    String date;
    double fee;
    String status;
  
    @override
    State<PickupCard> createState() => _PickupCardState();
  }
  
  class _PickupCardState extends State<PickupCard> {
    @override
    Widget build(BuildContext context) {
      String collectionNumber = widget.collectionNumber.toString();
      String  date = widget.date.toString();
      String fee = widget.fee.toString();
      String status = widget.status.toString();
  
      TextEditingController descriptionController = TextEditingController();
      String description = "";
  
      var selectedItem;
  
      IconData icon = EvaIcons.clockOutline;
      int iconColor = thirdYellowColor;
      List<Widget> actions = [
        CancelRedButton(buttonText: 'Cancel Request', onPressed: (){
          CollectionsService.cancelRequest(collectionNumber, context);
        })
      ];
  
      if(status == "Completed") {
        int dropDownColor = 0xffffffff;
        setState(() {
          icon = EvaIcons.checkmarkCircle;
          iconColor = secondaryGreenColor;
          actions = [
            FrontIconButton(buttonText: 'Report a Problem', onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: AlertDialog(
                        title: Column(children: [
                          SizedBox(height: 5,),
                          const Text('Report a problem')
                        ]),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("What type of problem have you encountered", style: TextStyle(color: Color(primaryBlueColor),fontSize: 16),),
                            SizedBox(height: 5,),
                            DropdownButton(
                              dropdownColor: Color(dropDownColor),
                              isExpanded: true,
                              value: selectedItem,
                              focusColor: Color(greyishBlueColor),
                              elevation: 0,
                              style: TextStyle(color: Color(greyishBlueColor)),
                                items: [
                                  DropdownMenuItem(child: Text("Uncollected Garbage"),value: "Uncollected Garbage",),
                                  DropdownMenuItem(child: Text("Late Pickup"),value: "Late Pickup",),
                                  DropdownMenuItem(child: Text("Other"),value: "Other",),
                                ], onChanged: (newValue){
                                if(dropDownColor == 0xffffffff) {
                                  dropDownColor == greyishBlueColor;
                                } else {
                                  dropDownColor == 0xffffffff;
                                }
                                print(newValue);
                                selectedItem = newValue.toString();
                                // setState((){
                                //   selectedItem = newValue.toString();
                                // });
                            }),
                            SizedBox(height: 15,),
                            Text("Describe your problem", style: TextStyle(color: Color(primaryBlueColor),fontSize: 16),),
                            SizedBox(height: 5,),
                            TextField(
                              style: TextStyle(
                                color: Color(primaryBlueColor)
                              ),
                              controller: descriptionController,
                              decoration: InputDecoration(labelText: 'Enter a description'),
                              keyboardType: TextInputType.multiline,
                              maxLines: 10, // <-- SEE HERE
                            )
                          ],
                        ),
                        actions: [
                          PrimaryBlueButton(buttonText: "Submit", onPressed: (){
                            description = descriptionController.text;
                            // print("Description: $description");
                            // print("Selected Item: $selectedItem");
                            // print("Collection Number: $collectionNumber");
                            TicketService().makeTicket(collectionNumber, selectedItem, description, context);
                          })
                        ],
                      ),
                    );
                  },
                  barrierDismissible: false);
            }, icon: EvaIcons.alertTriangleOutline, color: thirdYellowColor,)
          ];
        });
      } else if (status == "Canceled") {
        setState(() {
          icon = EvaIcons.closeCircleOutline;
          iconColor = cancelRedColor;
          actions = [];
        });
      } else if (status == "Under Investigation") {
        setState(() {
          icon = EvaIcons.searchOutline;
          iconColor = infoCyanColor;
          actions = [
  
          ];
        });
      } else if (status == "In Transit") {
        setState(() {
          icon = EvaIcons.searchOutline;
          iconColor = tealColor;
          actions = [
            PrimaryBlueButton(buttonText: 'Call Collector', onPressed: (){})
          ];
        });
      } else if (status == "FOD") {
        setState(() {
          icon = EvaIcons.searchOutline;
          iconColor = 0xff838BA1;
          actions = [
            ColorButton(buttonText: 'Redeem Free On Demand',color: 0xff838BA1, onPressed: (){
              CollectionsService.redeemFreeOnDemand(context, collectionNumber);
            })
          ];
        });
      }
  
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ExpansionTile(
          title: Container(
            alignment: Alignment.center,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Icon(icon, size: 50,color: Color(iconColor),),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Collection Number: " + collectionNumber,style: Theme.of(context).textTheme.bodyText1,),
                    Text("Date: "+ date,style: Theme.of(context).textTheme.bodyText1,),
                    Text("Fee: k"+ fee,style: Theme.of(context).textTheme.bodyText1,),
                    Text("Status: "+ status,style: Theme.of(context).textTheme.bodyText1,)
                  ],
                )
              ],
            ),
          ),
          children: actions,
        ),
      );
    }
  }

// Collection Card

class CollectorCard extends StatefulWidget {
  CollectorCard({required this.name,required this.rating});

  final String name;
  final double rating;

  late int containerColor = iconButtonBackgroundColor;
  late int fontColor = fontGreyColor;

  @override
  State<CollectorCard> createState() => _CollectorCardState();
}

class _CollectorCardState extends State<CollectorCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {

        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(widget.containerColor)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Name: "+widget.name,style: TextStyle(
                  color: Color(widget.fontColor),
                  fontSize: 20
              ),),
              Text("Rating: "+widget.rating.toString(),style: TextStyle(
                  color: Color(widget.fontColor),
                  fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}

void bottomModal(BuildContext context, String address) {
  MediaQueryData queryData;
  queryData = MediaQuery.of(context);
  showModalBottomSheet(
    isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      context: context,
      builder: (context) =>
          Container(
            height: queryData.size.height*0.48,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 22),
              child: Column(
                children: <Widget>[
                  AvatarGlow(child: Container(
                      height: 75,width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffB0E2B6),
                      ),
                      child: Icon(EvaIcons.search,size: 50,color: Colors.white,)), endRadius: 60,glowColor: Colors.green,),
                  Shimmer.fromColors(child:Text('Looking for a collector...',style: Theme.of(context).textTheme.headline6,)
                  , baseColor: Color(secondaryGreenColor), highlightColor: Color(primaryBlueColor)),
                  SizedBox(height: queryData.size.height*0.01,),
                  Text(address),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount",style: Theme.of(context).textTheme.headline3,),
                      Text("K50.00", style: Theme.of(context).textTheme.headline3,)
                    ],
                  ),
                  SizedBox(height:queryData.size.height*0.02,),
                  CancelRedButton(buttonText: "Cancel Request", onPressed: (){
                    CollectionsService.cancelOnDemandRequest(context);
                  })
                ],
              ),
            ),
          ));
}