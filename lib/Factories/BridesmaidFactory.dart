import 'package:scott_and_viki/PersonCard.dart';
import 'package:flutter/material.dart';

class BridesmaidFactory extends StatelessWidget {

  static final natasha = new PersonCard('Natasha Smith', Colors.white, "assets/NS.jpg", "Maid of Honour", "Viki and Tasha met at Pony Club and began riding in a team together at the age of 5! They rode for East Sussex Pony Club until the age of 15, and then trained the team they used to ride for until Viki moved away to University at 18. Viki and Tasha also went to secondary school together. Viki’s favourite shared memory is spending the week in Windsor during the Queen’s Golden Jubilee where Tasha rode Viki’s horse, Tiger, for Great Britain and Viki attended as Tasha’s groom, getting to watch All The Queen’s Horses performance from the ringside!", 18.0);
  static final veronica = new PersonCard('Veronica Foster', Colors.black, "assets/RF.jpg", "Bridesmaid", "Ronnie has known Viki since she was born as their families kept their horses together in Cross-in-Hand. Ronnie trained Viki and Tasha in their Pony Club team, and Viki also spent many years working with Ronnie showing ponies for a local breeder. Viki’s favourite shared memory is Ronnie picking her up from school in her sports car with the music blasting when we were going training!", 18.0);
  static final christy = new PersonCard('Christy Leone', Colors.black, "assets/CL.jpg", "Bridesmaid", "Christy and Viki went to Sixth Form together and became friends towards the end of secondary school. Christy and Viki used to spend a lot of time during our free study periods at Christy’s parents house in Heathfield watching Charmed, eating crumpets and drinking tea! Viki’s favourite shared memory is bombing around is Christy’s classic mini, whose petrol gauge didn’t work meaning Viki often came to rescue Christy with a can of Four Star fuel!", 18.0);
  static final hannah = new PersonCard('Hannah Frackiewicz', Colors.white, "assets/HF.jpg", "Bridesmaid", "Hannah and Viki went to secondary school together and share a love of all things homemade, especially knitting, sewing and baking! Viki’s favourite shared memory is being snowed in when they were both living in walking distance of each other in Heathfield, going sledging down the road and then walking home with a bottle of wine!", 18.0);
  static final abi = new PersonCard('Abi Fowden-Heffer', Colors.white, "assets/AFH.jpg", "Bridesmaid", "Abi and Viki’s parents live next door to each other in Blackboys and from the age of 13, Viki spent most of her time out hacking with Abi on their horses. Viki’s favourite shared memory is sneaking onto the Toll rides and racing through the fields to the gate that only one horse could fit through at a time!", 18.0);
  static final mandn = new PersonCard('Millie and Nicole Smith', Colors.white, "assets/MN.jpg", "Flower Girls", "Millie and Nicole and Tasha’s daughters and are both very talented in all of their interests.Viki’s favourite shared memory is going on holiday to Disney World, Florida with the family and visiting all of the attractions there!", 18.0, 25.0);
  static final sam = new PersonCard('Sam Foster', Colors.white, "assets/SF.jpg", "Page Boy", "Sam is Ronnie’s son, and Viki’s godson. Sam spent most of his early childhood in a pushchair at the side of a show ring while Viki and Ronnie competed. Viki’s favourite shared memory is going shooting on the farm and having Sam as her side kick!", 18.0);

  static final cardList = [
    natasha,
    veronica,
    christy,
    hannah,
    abi,
    mandn,
    sam
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