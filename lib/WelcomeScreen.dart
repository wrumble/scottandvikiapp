import 'package:flutter/material.dart';
import 'package:scott_and_viki/Constants/FontNames.dart';
import 'package:scott_and_viki/Text/TitleText.dart';
import 'Localisations.dart';
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
    print("here");
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
    print(value);
    if (value.isEmpty)
      return 'Full Name is required.';
    final RegExp nameExp = new RegExp(r"^([a-zA-Z]{2,}\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)", caseSensitive: false);
    if (!nameExp.hasMatch(value))
      return 'Please enter your full name.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    print(value);
    print(passwordField.value);
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new Text("Welcome",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: FontName.titleFont,
                    fontSize: 40.0,
                    color: Colors.black,
                  ),
                ),
                new Text("Please enter you information",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: FontName.normalFont,
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
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
                  padding: new EdgeInsets.only(top: 16.0, bottom: 8.0),
                  color: Colors.black,
                  onPressed: () => _handleSubmitted(),
                  child: new Text('Done!',
                    style: new TextStyle(fontFamily: FontName.normalFont,
                        fontSize: 30.0,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
