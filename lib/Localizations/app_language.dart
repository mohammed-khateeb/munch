import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ;
  Future fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    print("/////////////////${prefs.getString("langId")}");
    print(
        'prefs.getString(language_code) : ${prefs.getString('language_code')}');
    if (prefs.getString('language_code') == null) {
      _appLocale = const Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code')!);
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await prefs.setString("langId", "2");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = Locale("en");
      await prefs.setString("langId", "1");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', '');
    }
    notifyListeners();
  }
}
