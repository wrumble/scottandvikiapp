import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class EditName extends StatefulWidget {
  const EditName({ Key key }) : super(key: key);

  @override
  EditNameState createState() => new EditNameState();
}

class EditNameState extends State<EditName> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var newName;
  var currentName;
  var uuid;

  Future<Null> getCurrentNameAndUuid() async {
    final instance = await SharedPreferences.getInstance();

    setState(() {
      currentName = instance.getString("FullName");
      uuid = instance.getString("UUID");
      newName = "";
    });
  }

  @override void initState() {
    super.initState();

    getCurrentNameAndUuid();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  bool _autoValidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void exitScreen() {
    Navigator.pop(context);
  }

  void saveUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FullName', newName);
  }

  Future<Null> uploadNameChange() async {
    final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(uuid).child("name");

    dataBaseReference.set(newName);
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      uploadNameChange();
      saveUserName();
      showInSnackBar('Name Changed to, $newName!');
      exitScreen();
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Full Name is required.';
    final RegExp nameExp = new RegExp(r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)", caseSensitive: false);
    if (!nameExp.hasMatch(value))
      return 'Please enter your full name.';
    return null;
  }

  Future<bool> _warnUserAboutInvalidData() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formWasEdited || form.validate())
      return true;

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('This form has errors'),
          content: const Text('Really leave this form?'),
          actions: <Widget> [
            new FlatButton(
              child: const Text('Yes'),
              onPressed: () { Navigator.of(context).pop(true); },
            ),
            new FlatButton(
              child: const Text('No'),
              onPressed: () { Navigator.of(context).pop(false); },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new TitleText("Edit Name"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: new Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          onWillPop: _warnUserAboutInvalidData,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 8.0),
                new Container(
                    child: new Column(
                      children: <Widget>[
                        new Text("Misspelled your name",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: FontName.titleFont,
                            fontSize: 35.0,
                            color: Colors.black,
                          ),
                        ),
                        new Text("Please enter your first and last name. No need for any middle names.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: FontName.normalFont,
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
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
                ),
                const SizedBox(height: 24.0),
                new Container(
                    child: new TextFormField(
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                        helperText: 'First and Last Name',
                        labelText: 'Whole Name',
                        labelStyle: const TextStyle(
                          fontFamily: FontName.normalFont,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                        helperStyle: const TextStyle(
                          fontFamily: FontName.normalFont,
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                      onSaved: (String value) { newName = value; },
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      validator: _validateName,
                    ),
                    margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: const EdgeInsets.only(bottom: 8.0),
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
                ),
                const SizedBox(height: 24.0),
                new FlatButton(
                  textColor: Colors.white,
                  padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
                  color: Colors.black,
                  onPressed: () => _handleSubmitted(),
                  child: new Text('Done!',
                    style: new TextStyle(fontFamily: FontName.normalFont,
                        fontSize: 30.0,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
