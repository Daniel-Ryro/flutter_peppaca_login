import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const localeCommon = "common";
const localeSignIn = "sigin";
const localeCategory = "category";
const localeSubCategory = "subcategory";
const localeSubSubCategory = "subsubcategory";

Map<String, Map<String, dynamic>> localizedStrings = {};

class LocaleManager {
  String loadedLocale;

  LocaleManager(this.loadedLocale);

  String getCurrentLocale() {
    return loadedLocale;
  }

  Future<bool> load(String languageCode, String localeGroup) async {
    if ((loadedLocale == languageCode) &&
        (localizedStrings.containsKey(localeGroup))) {
      return false; // match with preloaded language
    }

    print("$loadedLocale $languageCode");
    print((localizedStrings.containsKey(localeGroup)));
    print("load localeGroup $localeGroup");

    // avoid unintentionally reload
    loadedLocale = languageCode;

    print(localeGroup);

    final jsonString = await rootBundle
        .loadString('assets/translations/$languageCode/$localeGroup.json');

    print(jsonString);

    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    localizedStrings[localeGroup] = jsonMap;

    print(localizedStrings[localeGroup]);

    return true;
  }

  String translate(String localeGroup, String key) {
    return localizedStrings[localeGroup]?[key] ?? key;
  }

  String commonTrans(String key) {
    print(key);
    print(translate(localeCommon, key));
    return translate(localeCommon, key);
  }
}

LocaleManager localeManager = LocaleManager("");
