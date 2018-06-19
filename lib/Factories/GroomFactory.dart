import 'package:scott_and_viki/PersonCard.dart';
import 'package:flutter/material.dart';

class GroomFactory extends StatelessWidget {

  static final wayneCard = new PersonCard('Wayne Rumble', Colors.white, "assets/wayne.jpg", "Best Man #1", "Scotts second eldest, but best brother", 25.0);
  static final benCard = new PersonCard('Ben Rumble', Colors.white, "assets/ben.jpg", "Best Man #2", "Scotts eldest brother and biggest man at the wedding.", 25.0);
  static final edCard = new PersonCard('Ed Sealey', Colors.black, "assets/ed.jpg", "Usher", "Who?", 25.0);
  static final harryCard = new PersonCard('Harry Sealey', Colors.black, "assets/harry.jpg", "Usher", "Scotts friend from milton abbey school. Best Eddie Jones impression there is...", 25.0);
  static final tomJCard = new PersonCard('Tom Jackson', Colors.white, "assets/tomJ.jpg", "Usher", "Scotts friend from milton abbey school. He will be the smallest man at the wedding.", 25.0);
  static final tomBCard = new PersonCard('Tom Bailey', Colors.white, "assets/tomB.jpg", "Usher", "Scotts friend from milton abbey school. If you need your garden done call 07540 470727.", 25.0);
  static final oliCard = new PersonCard('Oli Fowke', Colors.white, "assets/oli.jpg", "Usher", "Scotts friend from milton abbey school. He will be the hairiest man at the wedding.", 25.0);
  static final garyCard = new PersonCard('Gary Walton', Colors.white, "assets/gary.jpg", "Usher", "Scotts known Gary for 4 years. He's Viki's younger brother and has enormous calf muscles.", 25.0);

  static final cardList = [
    wayneCard,
    benCard,
    edCard,
    harryCard,
    tomJCard,
    tomBCard,
    oliCard,
    garyCard
  ];

  static final cardListView = new ListView.builder(
      itemCount: cardList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Container( //You need to make my child interactive
            child: cardList[index]
        );
      });

  @override
  Widget build(BuildContext context) {
    return cardListView;
  }
}