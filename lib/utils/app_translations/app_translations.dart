import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../models/app_config_model.dart';
import '../filehelper.dart';
import '../services/shared_pref_service.dart';

class AppTranslations {
  Locale? locale;
  static Map<dynamic, dynamic>? _localisedValues;

  AppTranslations(Locale locale) {
    this.locale = locale;
    _localisedValues = null;
  }

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  static Future<AppTranslations> load(Locale locale) async {
    print('>>> FETCH REMOTE LANG');
    //Load language start
    SharedPrefService.isLoadingLanguage.value = true;

    AppTranslations appTranslations = AppTranslations(locale);
    String? jsonContents;
    var remoteLang;
    try {
      remoteLang = AppConfig.language?.firstWhere((element) {
        var lang = getCorrectLang(locale.languageCode.toLowerCase());

        return element.code!.toLowerCase() == lang;
      }).file;
    } catch (e) {
      print(e);
    }

    print(remoteLang);
    if (remoteLang == null) {
      jsonContents = "";
    } else {
      try {
        var url = Uri.parse(remoteLang);
        var bodyRaw = (await http.get(url)).bodyBytes;
        jsonContents = Utf8Decoder().convert(bodyRaw);
      } catch (e) {
        print(e);
      }
      // print("bodyRaw : $jsonContent");
    }

    //Load language finish
    SharedPrefService.isLoadingLanguage.value = false;

    print(locale.languageCode.toLowerCase());
    if (jsonContents == null || jsonContents == "") {
      var lang = getCorrectLang(locale.languageCode.toLowerCase());

      var content =
          await FileHelper.getFileData("assets/locale/localization_$lang.json");
      _localisedValues = json.decode(content);
      // print("Go in here 1");
    } else if (jsonContents.contains("html")) {
      var lang = getCorrectLang(locale.languageCode.toLowerCase());

      var content =
          await FileHelper.getFileData("assets/locale/localization_$lang.json");
      _localisedValues = json.decode(content);
    } else {
      // print("Go in here 2");
      _localisedValues = json.decode(jsonContents);
    }

    // print(content);

    // _localisedValues = json.decode(content);
    return appTranslations;
  }

  get currentLanguage => locale!.languageCode;

  static String getCorrectLang(String lang) {
    var tmpLang = lang;
    if (tmpLang == "cn") {
      tmpLang = "zh";
    } else if (lang == 'bm') {
      tmpLang = "ms";
    }
    return tmpLang;
  }

  String text(String key) {
    if (_localisedValues == null) {
      return ''; // Not ready yet
    } else {
      return _localisedValues![key] ?? "$key";
    }
  }
}
