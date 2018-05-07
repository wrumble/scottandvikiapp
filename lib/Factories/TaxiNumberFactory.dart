import 'package:scott_and_viki/Widgets/TaxiNumberContainer.dart';
import 'package:flutter/material.dart';


class TaxiNumberFactory extends StatelessWidget {

  static final number1 = new TaxiNumberContainer("Keller Kars", "01892 541589");
  static final number2 = new TaxiNumberContainer("Skyline Taxi", "01732 400200");
  static final number3 = new TaxiNumberContainer("Castle Cars", "01732 363637");
  static final number4 = new TaxiNumberContainer("Station Taxis", "01732 363636");
  static final number5 = new TaxiNumberContainer("Royal Cars", "01892 646646");
  static final number6 = new TaxiNumberContainer("AK Taxi", "01892 802803");
  static final number7 = new TaxiNumberContainer("Premier Cars", "01892 535535");
  static final number8 = new TaxiNumberContainer("Reliable Taxi", "07821 579982");
  static final number9 = new TaxiNumberContainer("Express Cars", "01892 535735");
  static final number10 = new TaxiNumberContainer("Joe's Taxi Service", "07941 504678");

  final taxiList = [
    number1,
    number2,
    number3,
    number4,
    number5,
    number6,
    number7,
    number8,
    number9,
    number10
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: taxiList.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
              child: taxiList[index]
          );
        });
  }
}