import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class Localize {
  Localize(this.locale);

  final Locale locale;

  static Localize of(BuildContext context) {
    return Localizations.of<Localize>(context, Localize);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Scott and Viki',
      'welcomeMessage': 'Welcome to Scott and Vikis wedding App',
      'takeAPhoto': 'Take A Photo'
    }
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]['appTitle'];
  }
  String get welcomeMessage {
    return _localizedValues[locale.languageCode]['welcomeMessage'];
  }
  String get takeAPhoto {
    return _localizedValues[locale.languageCode]['takeAPhoto'];
  }
}

class LocalizeDelegate extends LocalizationsDelegate<Localize> {
  const LocalizeDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<Localize> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<Localize>(new Localize(locale));
  }

  @override
  bool shouldReload(LocalizeDelegate old) => false;
}