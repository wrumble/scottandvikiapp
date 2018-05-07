import 'package:scott_and_viki/OrderOfTheDay.dart';
import 'package:scott_and_viki/MapsAndDirections.dart';
import 'package:scott_and_viki/Cards/TaxiNumberCard.dart';
import 'package:scott_and_viki/Cards/HomeScreenCard.dart';
import 'package:scott_and_viki/TheBridesmaids.dart';
import 'package:scott_and_viki/TheGroomsmen.dart';
import 'package:flutter/material.dart';

class HomeScreenCardFactory extends StatelessWidget {

  static final bridesmaidsCard = new HomeScreenCard('The Bridesmaids', 'assets/4.jpg');
  static final groomsmenCard = new HomeScreenCard('The Groomsmen', 'assets/5.jpg');
  static final orderOfTheDayCard = new HomeScreenCard('Order of the day', 'assets/SVSunset.jpg');
  static final mapsAndDirectionsCard = new HomeScreenCard('Maps and Directions', 'assets/2.jpg');
  static final taxiNumbersCard = new HomeScreenCard('Taxi Numbers', 'assets/3.jpg', Colors.black);

  static final cardList = [
    bridesmaidsCard,
    groomsmenCard,
    orderOfTheDayCard,
    mapsAndDirectionsCard,
    taxiNumbersCard
  ];

  static final screensList = [
    new TheBridesmaids(),
    new TheGroomsmen(),
    new OrderOfTheDay(),
    new MapsAndDirections(),
    new TaxiNumberCard()
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: cardList[index]
          );
        });
  }
}