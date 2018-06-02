import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'dart:async';

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({ Key key }) : super(key: key);

  @override
  TextFormFieldDemoState createState() => new TextFormFieldDemoState();
}

class PersonData {
  String name = '';
  String password = '';
  String uuid = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => new _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        helperText: widget.helperText,
        labelText: widget.labelText,
        labelStyle: new TextStyle(
          fontFamily: FontName.normalFont,
          fontSize: 25.0,
          color: Colors.black,
        ),
        helperStyle: new TextStyle(
          fontFamily: FontName.normalFont,
          fontSize: 18.0,
          color: Colors.grey,
        ),
        suffixIcon: new GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PersonData person = new PersonData();

  @override void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  bool _autoValidate = false;
  bool _formWasEdited = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey = new GlobalKey<FormFieldState<String>>();

  void showHomeScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new HomeScreen()),
    );
  }

  void saveDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FullName', person.name);

    var uuid = new Uuid().v4().toString();
    person.uuid = uuid;
    prefs.setString('UUID', uuid);

    prefs.setInt('ImageCount', 0);

    final DatabaseReference dataBaseReference = FirebaseDatabase.instance.reference().child("AllUsers").child(person.uuid).child("name");
    dataBaseReference.set(person.name);
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      saveDetails();
      showInSnackBar('Welcome, ${person.name}!');
      showHomeScreen();
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

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;

    var password = 'Password';
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != password)
      return 'Wrong password ask Scott or Viki for the password';
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
        title: new Container(
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            child: new Text("Welcome",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontFamily: FontName.titleFont,
                  fontSize: 40.0,
                  color: Colors.white
              ),
            ),
          ),
          margin: new EdgeInsets.only(top: 8.0),
        ),
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
//                      new Text("Welcome",
//                        textAlign: TextAlign.center,
//                        style: const TextStyle(
//                          fontFamily: FontName.titleFont,
//                          fontSize: 40.0,
//                          color: Colors.black,
//                        ),
//                      ),
                      new Text("Please enter your whole name and password to enter the app. If you cant remember the password just ask Scott or Viki.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: FontName.normalFont,
                          fontSize: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
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
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    onSaved: (String value) { person.name = value; },
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
                new Container(
                  child: new PasswordField(
                    fieldKey: _passwordFieldKey,
                    helperText: 'Ask Scott or Viki',
                    labelText: 'App Password',
                    validator: _validatePassword,
                  ),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black38,
                            blurRadius: 5.0,
                            offset: new Offset(3.0, 5.0)
                        ),
                      ]
                  ),
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: const EdgeInsets.only(bottom: 8.0),
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
