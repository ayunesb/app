// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get favorite {
    return Intl.message(
      'Favorite',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explore {
    return Intl.message(
      'Explore',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_title {
    return Intl.message(
      'Continue',
      name: 'continue_title',
      desc: '',
      args: [],
    );
  }

  /// `Select your preferred language`
  String get preferred_language_title {
    return Intl.message(
      'Select your preferred language',
      name: 'preferred_language_title',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Language`
  String get preferred_language {
    return Intl.message(
      'Preferred Language',
      name: 'preferred_language',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get units {
    return Intl.message(
      'Units',
      name: 'units',
      desc: '',
      args: [],
    );
  }

  /// `Metric`
  String get metric {
    return Intl.message(
      'Metric',
      name: 'metric',
      desc: '',
      args: [],
    );
  }

  /// `Imperial`
  String get imperial {
    return Intl.message(
      'Imperial',
      name: 'imperial',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `MXN`
  String get mxn {
    return Intl.message(
      'MXN',
      name: 'mxn',
      desc: '',
      args: [],
    );
  }

  /// `USD`
  String get usd {
    return Intl.message(
      'USD',
      name: 'usd',
      desc: '',
      args: [],
    );
  }

  /// `User Information`
  String get user_settings_title {
    return Intl.message(
      'User Information',
      name: 'user_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `bed`
  String get bed {
    return Intl.message(
      'bed',
      name: 'bed',
      desc: '',
      args: [],
    );
  }

  /// `bath`
  String get bath {
    return Intl.message(
      'bath',
      name: 'bath',
      desc: '',
      args: [],
    );
  }

  /// `PRICE`
  String get price {
    return Intl.message(
      'PRICE',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `CONTACT US`
  String get contact_us {
    return Intl.message(
      'CONTACT US',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp`
  String get whatsapp {
    return Intl.message(
      'WhatsApp',
      name: 'whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get sms {
    return Intl.message(
      'SMS',
      name: 'sms',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message(
      'Directions',
      name: 'directions',
      desc: '',
      args: [],
    );
  }

  /// `Amenities`
  String get amenities {
    return Intl.message(
      'Amenities',
      name: 'amenities',
      desc: '',
      args: [],
    );
  }

  /// `COMODIDADES`
  String get AMENITIES {
    return Intl.message(
      'COMODIDADES',
      name: 'AMENITIES',
      desc: '',
      args: [],
    );
  }

  /// `MAP`
  String get MAP {
    return Intl.message(
      'MAP',
      name: 'MAP',
      desc: '',
      args: [],
    );
  }

  /// `Any`
  String get any {
    return Intl.message(
      'Any',
      name: 'any',
      desc: '',
      args: [],
    );
  }

  /// `Bedrooms`
  String get bedrooms {
    return Intl.message(
      'Bedrooms',
      name: 'bedrooms',
      desc: '',
      args: [],
    );
  }

  /// `Bathrooms`
  String get bathrooms {
    return Intl.message(
      'Bathrooms',
      name: 'bathrooms',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price_title {
    return Intl.message(
      'Price',
      name: 'price_title',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `No matching results`
  String get no_matching_results {
    return Intl.message(
      'No matching results',
      name: 'no_matching_results',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Neighborhood`
  String get neighborhood {
    return Intl.message(
      'Neighborhood',
      name: 'neighborhood',
      desc: '',
      args: [],
    );
  }

  /// `Legal doc`
  String get legal_doc {
    return Intl.message(
      'Legal doc',
      name: 'legal_doc',
      desc: '',
      args: [],
    );
  }

  /// `Click here to see a video`
  String get click_to_see_video {
    return Intl.message(
      'Click here to see a video',
      name: 'click_to_see_video',
      desc: '',
      args: [],
    );
  }

  /// `Hunt Price`
  String get huntPrice {
    return Intl.message(
      'Hunt Price',
      name: 'huntPrice',
      desc: '',
      args: [],
    );
  }

  /// `Regular Price`
  String get regularPrice {
    return Intl.message(
      'Regular Price',
      name: 'regularPrice',
      desc: '',
      args: [],
    );
  }

  /// `Promoted`
  String get promoted_title {
    return Intl.message(
      'Promoted',
      name: 'promoted_title',
      desc: '',
      args: [],
    );
  }

  /// `I thought you might be interested in this property:`
  String get share_pre_msg {
    return Intl.message(
      'I thought you might be interested in this property:',
      name: 'share_pre_msg',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get share_post_msg {
    return Intl.message(
      '',
      name: 'share_post_msg',
      desc: '',
      args: [],
    );
  }

  /// `Check out this great property!`
  String get share_subject {
    return Intl.message(
      'Check out this great property!',
      name: 'share_subject',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_settings_title {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `I have read and accepted`
  String get terms_pre_msg {
    return Intl.message(
      'I have read and accepted',
      name: 'terms_pre_msg',
      desc: '',
      args: [],
    );
  }

  /// `terms and conditions`
  String get terms_post_msg {
    return Intl.message(
      'terms and conditions',
      name: 'terms_post_msg',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
