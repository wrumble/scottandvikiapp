import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'Localisations.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
//
//class WelcomeScreen extends StatelessWidget {
//  @override
//
//  void initState() {
//    _controller.addListener(onChange);
//    _textFocus.addListener(onChange);
//  }
//
//  TextEditingController _controller = new TextEditingController();
//
//  FocusNode _textFocus = new FocusNode();
//
//  void onChange(){
//    String text = _controller.text;
//    bool hasFocus = _textFocus.hasFocus;
//    //do your text transforming
//    _controller.text = newText;
//    _controller.selection = new TextSelection(
//        baseOffset: newText.length,
//        extentOffset: newText.length
//    );
//  }
//
//  Widget build(BuildContext context) {
//
//    var backgroundImage = new BoxDecoration(
//      image: new DecorationImage(
//        image: new AssetImage('assets/background.png'),
//        fit: BoxFit.cover,
//      ),
//    );
//
//    var titleText = new TitleText(Localize.of(context).appTitle);
//
//    var requestTextContainer = new Container(
//        child: new Text("Please enter your first and last name.",
//          style: new TextStyle(
//              fontFamily: FontName.normalFont,
//              fontSize: 30.0,
//              color: Colors.white,
//          ),
//          textAlign: TextAlign.center,
//        ),
//        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
//        padding: new EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
//        decoration: new BoxDecoration(
//            color: Colors.black,
//            boxShadow: [
//              new BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 5.0,
//                  offset: new Offset(3.0, 5.0)
//              ),
//            ]
//        )
//    );
//
//
//
//    var firstNameContainer = new Container(
//        child: new TextFormField(
//          controller: _controller,
//          focusNode: _textFocus,
//          style: new TextStyle(
//            fontFamily: FontName.normalFont,
//            fontSize: 25.0,
//            color: Colors.black,
//          ),
//          keyboardType: TextInputType.text,
//          autofocus: true,
//          decoration: new InputDecoration(
//            labelText: 'First Name',
//            fillColor: Colors.white,
//
//          ),
//        ),
//        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
//        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
//        decoration: new BoxDecoration(
//            color: Colors.white,
//            boxShadow: [
//              new BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 5.0,
//                  offset: new Offset(3.0, 5.0)
//              ),
//            ]
//        )
//    );
//
//    var lastNameContainer = new Container(
//        child: new TextFormField(
//          style: new TextStyle(
//            fontFamily: FontName.normalFont,
//            fontSize: 25.0,
//            color: Colors.black,
//          ),
//          keyboardType: TextInputType.text,
//          autofocus: true,
//          decoration: new InputDecoration(
//            labelText: 'Last Name',
//            fillColor: Colors.black
//          ),
//        ),
//        margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
//        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
//        decoration: new BoxDecoration(
//            color: Colors.white,
//            boxShadow: [
//              new BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 5.0,
//                  offset: new Offset(3.0, 5.0)
//              ),
//            ]
//        )
//    );
//
//    var passwordContainer = new Container(
//        child: new TextFormField(
//          style: new TextStyle(
//            fontFamily: FontName.normalFont,
//            fontSize: 25.0,
//            color: Colors.black,
//          ),
//          keyboardType: TextInputType.text,
//          autofocus: true,
//          decoration: new InputDecoration(
//            labelText: 'Password',
//            fillColor: Colors.white,
//
//          ),
//        ),
//        margin: new EdgeInsets.only(top: 16.0, bottom: 16.0),
//        padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
//        decoration: new BoxDecoration(
//            color: Colors.white,
//            boxShadow: [
//              new BoxShadow(
//                  color: Colors.black38,
//                  blurRadius: 5.0,
//                  offset: new Offset(3.0, 5.0)
//              ),
//            ]
//        )
//    );
//
//    void showHomeScreen() {
//      Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(builder: (context) => new HomeScreen()),
//      );
//    }
//
//    var doneButton = new FlatButton(
//      textColor: Colors.white,
//      padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
//      color: Colors.black,
//      onPressed: () => showHomeScreen(),
//      child: new Text('Done!',
//        style: new TextStyle(fontFamily: FontName.normalFont,
//            fontSize: 30.0,
//            color: Colors.white),
//      ),
//    );
//
//    var list = [
//      requestTextContainer,
//      firstNameContainer,
//      lastNameContainer,
//      passwordContainer,
//      doneButton
//    ];
//
//    var listView = new ListView.builder(
//        itemCount: list.length,
//        itemBuilder: (BuildContext context, int index) {
//          return new Container(
//              child: list[index]
//          );
//        });
//
//    var mainContainer = new Container(
//        height: double.infinity,
//        width: double.infinity,
//        decoration: backgroundImage,
//        child: new Container(
//          child: listView,
//        )
//    );
//
//    return new Scaffold(
//        appBar: new AppBar(
//          title: titleText,
//          backgroundColor: Colors.black,
//          centerTitle: true,
//
//        ),
//        body: mainContainer
//    );
//  }
//}

import 'dart:async';

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({ Key key }) : super(key: key);

  @override
  TextFormFieldDemoState createState() => new TextFormFieldDemoState();
}

class PersonData {
  String name = '';
  String password = '';
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
      decoration: new InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        labelStyle: new TextStyle(
          fontFamily: FontName.normalFont,
          fontSize: 25.0,
          color: Colors.black,
        ),
        hintStyle: new TextStyle(
          fontFamily: FontName.normalFont,
          fontSize: 20.0,
          color: Colors.black,
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
  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      showInSnackBar('Welcome, ${person.name}!');
      showHomeScreen();
    }
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty)
      return 'Full Name is required.';
    final RegExp nameExp = new RegExp(r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)", caseSensitive: false);
    if (!nameExp.hasMatch(value))
      return 'Please enter your full name.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    var password = 'Password';
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != password)
      return 'Wrong password ask Viki or Scott for the password';
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

  final labelStyle = new TextStyle(
    fontFamily: FontName.normalFont,
    fontSize: 25.0,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new TitleText(Localize.of(context).appTitle),
        backgroundColor: Colors.black,
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          onWillPop: _warnUserAboutInvalidData,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  style: new TextStyle(
                      fontFamily: FontName.normalFont,
                      fontSize: 25.0,
                      color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'First and Last name',
                    labelText: 'Name',
                    hintStyle: new TextStyle(
                      fontFamily: FontName.normalFont,
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    labelStyle: labelStyle,
                  ),
                  onSaved: (String value) { person.name = value; },
                  validator: _validateName,
                ),
                const SizedBox(height: 24.0),
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText: 'Ask Scott or Viki',
                  labelText: 'App Password',
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24.0),
                new FlatButton(
                  textColor: Colors.white,
                  padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
                  color: Colors.black,
                  onPressed: () => _handleSubmitted,
                  child: new Text('Done!',
                    style: new TextStyle(fontFamily: FontName.normalFont,
                        fontSize: 30.0,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
