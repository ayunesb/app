import 'package:intl/intl.dart';
import 'package:paradigm_mex/constants/app_strings.dart';

import '../models/user.dart';
import 'local_storage.dart';

class GeneralServices {
  //
  static bool firstTimeOnApp() {
    return LocalStorageService.prefs?.getBool(AppStrings.firstTimeOnApp) ??
        true;
  }

  static firstTimeCompleted() async {
    await LocalStorageService.prefs?.setBool(AppStrings.firstTimeOnApp, false);
  }

  //Locale
  static String getLocale() {
    return LocalStorageService.prefs?.getString(AppStrings.appLocale) ?? "en";
  }

  static Future<bool> setLocale(language) async {
    return LocalStorageService.prefs!.setString(AppStrings.appLocale, language);
  }

  // Units
  static String getUnits() {
    return LocalStorageService.prefs?.getString(AppStrings.units) ?? "metric";
  }

  static Future<bool> setUnits(units) async {
    return LocalStorageService.prefs!.setString(AppStrings.units, units);
  }

  static String getSquareFootage(meters) {
    final _formatter = NumberFormat('#,##,###');
    final String unit = GeneralServices.getUnits() == "metric" ? ' m²' : ' ft²';
    return _formatter.format(GeneralServices.getUnits() == "metric"
            ? meters
            : (meters * 10.76391041671)) +
        unit;
  }

  // Currency
  static String getCurrency() {
    return LocalStorageService.prefs?.getString(AppStrings.currency) ?? "mxn";
  }

  static Future<bool> setCurrency(currency) async {
    return LocalStorageService.prefs!.setString(AppStrings.currency, currency);
  }

  static String getCurrencyStr(currencyMXN, currencyUSD) {
    final _formatter = NumberFormat.currency(
      name: '',
      locale: GeneralServices.getCurrency() == "mxn" ? 'es_mx' : 'en_us²',
    );

    return '\$' +
        _formatter.format(
            GeneralServices.getCurrency() == "mxn" ? currencyMXN : currencyUSD);
  }

  // Currency
  static bool getTerms() {
    return LocalStorageService.prefs?.getBool(AppStrings.termsAccepted) ?? false;
  }

  static Future<bool> setTerms(bool accepted) async {
    return LocalStorageService.prefs!.setBool(AppStrings.termsAccepted, accepted);
  }

  // Currency
  static User getUser() {
    User user = User();
    user.name = LocalStorageService.prefs?.getString(AppStrings.userName) ?? "";
    user.email = LocalStorageService.prefs?.getString(AppStrings.userEmail) ?? "";
    user.phone = LocalStorageService.prefs?.getString(AppStrings.userPhone) ?? "";

    return user;
  }

  static Future<bool> setUser(User user) async {
    bool success = true;
    success &= await LocalStorageService.prefs!.setString(AppStrings.userName, user.name);
    success &= await LocalStorageService.prefs!.setString(AppStrings.userEmail, user.email);
    success &= await LocalStorageService.prefs!.setString(AppStrings.userPhone, user.phone);
    return success;
  }



  //Favorites
  static List<String> getFavoritePropertyIds() {
    List<String> favoriteIds =
        LocalStorageService.prefs?.getStringList(AppStrings.favoritesKey) ?? [];

    return favoriteIds;
  }

  static Future<bool> setFavoritePropertyIds(
      List<String> favoritePropertyIds) async {
    return LocalStorageService.prefs!
        .setStringList(AppStrings.favoritesKey, favoritePropertyIds);
  }

  static Future<bool> setFavoritePropertyId(String favoriteId) async {
    List<String> favorites = getFavoritePropertyIds();
    if (favorites.contains(favoriteId)) {
      return true;
    }

    favorites.add(favoriteId);
    bool setStringList = await LocalStorageService.prefs!
        .setStringList(AppStrings.favoritesKey, favorites);
    getFavoritePropertyIds();
    return setStringList;
  }

  static Future<bool> removeFavoritePropertyId(String favoriteId) async {
    List<String> favorites = getFavoritePropertyIds();
    if (favorites.contains(favoriteId)) {
      favorites.remove(favoriteId);
      bool result = await LocalStorageService.prefs!
          .setStringList(AppStrings.favoritesKey, favorites);
      getFavoritePropertyIds();
      return result;
    }
    getFavoritePropertyIds();
    return true;
  }
}
