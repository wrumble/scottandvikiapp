import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiNumberContainer extends StatelessWidget {
  final String name;
  final String number;

  TaxiNumberContainer(this.name, this.number);

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new InkWell(
                child: new Text("${this.name} - ${this.number}",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        fontFamily: 'DancingScript-Regular',
                        fontSize: 25.0,
                        color: Colors.black)
                ),
                onTap: () => launch("tel:${this.number}"),
              ),
              margin: new EdgeInsets.only(
                  left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
            )
          ],
        ),
        margin: new EdgeInsets.only(
            left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
        decoration: new BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5.0,
                  offset: new Offset(3.0, 5.0)
              ),
            ]
        )
    );
  }
}