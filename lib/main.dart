import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paradigm_mex/blocs/favorites/favorites_bloc.dart';
import 'package:paradigm_mex/blocs/filters/filters_bloc.dart';
import 'package:paradigm_mex/blocs/location/location_bloc.dart';
import 'package:paradigm_mex/blocs/terms_and_conditions/terms_settings_bloc.dart';
import 'package:paradigm_mex/blocs/units/units_change_bloc.dart';
import 'package:paradigm_mex/blocs/widgets/marker_bloc.dart';
import 'package:paradigm_mex/service/ad_service.dart';
import 'package:paradigm_mex/service/analytics_service.dart';
import 'package:paradigm_mex/service/database_service.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/service/image_storage_service.dart';
import 'package:paradigm_mex/service/local_storage.dart';
import 'package:paradigm_mex/theme/app_theme.dart';
import 'package:paradigm_mex/ui/pages/home.dart';
import 'package:paradigm_mex/ui/pages/web/web_home.dart';
import 'package:paradigm_mex/ui/widgets/property/property_detail.dart';

import 'blocs/ads/ad_bloc.dart';
import 'blocs/ads/ad_list_bloc.dart';
import 'blocs/currency/currency_change_bloc.dart';
import 'blocs/language/language_change_bloc.dart';
import 'blocs/property/property_bloc.dart';
import 'blocs/property/property_list_bloc.dart';
import 'blocs/reports/contact_report_bloc.dart';
import 'blocs/settings/settings_bloc.dart';
import 'blocs/user/user_settings_bloc.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'models/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//Initialize shared preference
  await LocalStorageService.getPrefs();
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AnalyticsServices analytics = AnalyticsServices();
  analytics.startApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static int propertyAdIndex = 0;
  MyApp({Key? key}) : super(key: key);
  static late List<AppSettings> settings;
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(
        theme: AppTheme().lightTheme().copyWith(
                sliderTheme: SliderThemeData(
              showValueIndicator: ShowValueIndicator.always,
              // activeTrackColor: Colors.amber,
            )),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        locale: Locale(GeneralServices.getLocale()),
        home: WebHomeWidget(),
      );
    } else {
      var generateRoutes = (settings) {
        // Handle '/'
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomeWidget());
        }
        var uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 2 &&
            uri.pathSegments.first == 'property') {
          var id = uri.pathSegments[1];
          try {
            return MaterialPageRoute(
                settings: RouteSettings(name: "/property/${id}"),
                fullscreenDialog: true,
                builder: (context) => HeroMode(
                    enabled: false,
                    child: HeroMode(
                        enabled: false, child: PropertyDetailWrapper(id))));
          } catch (e) {
            print('Error getting property ${id}: ${e}');
            return MaterialPageRoute(builder: (context) => HomeWidget());
          }
        } else {
          return MaterialPageRoute(builder: (context) => HomeWidget());
        }
      };
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguageBloc()..add(LanguageSelected()),
          ),
          BlocProvider(
            create: (context) => UnitsBloc()..add(UnitsSelected()),
          ),
          BlocProvider(
            create: (context) => CurrencyBloc()..add(CurrencySelected()),
          ),
          BlocProvider(
              create: (context) => PropertyListBloc(
                  databaseService: DatabaseService(),
                  imageStorage: ImageStorageService())
                ..add(PropertyListInitialEvent())),
          BlocProvider(
            create: (context) => FiltersBloc(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(),
            lazy: false,
          ),
          BlocProvider(
            create: (context) => LocationBloc(),
          ),
          BlocProvider(
            create: (context) => MarkerBloc(),
          ),
          BlocProvider(
            create: (context) => PropertyBloc(
                databaseService: DatabaseService(),
                imageStorage: ImageStorageService()),
          ),
          BlocProvider(
              create: (context) => AdBloc()
                ..add(AdInitialEvent())),
          BlocProvider(
              create: (context) => AdListBloc(adService: AdService())),
          BlocProvider(
            create: (context) => UserBloc()..add(UserInitialEvent()),
          ),
          BlocProvider(
            create: (context) => SettingsBloc()..add(SettingsInitialEvent()),
          ),
          BlocProvider(
            create: (context) => TermsBloc()..add(TermsInitialEvent()),
          ),
          BlocProvider(
            create: (context) => ContactReportBloc(databaseService: DatabaseService(),),
          ),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
        if (state is SettingsLoadSuccessState) {
          settings = state.allSettings;
        }
        return MaterialApp(
          onGenerateRoute: generateRoutes,
          // routes: {
          //   '/': (context) => HomeWidget(),
          //   '/property': (context) => PropertyDetailWrapper("0"),
          // },
          theme: AppTheme().lightTheme().copyWith(
                  sliderTheme: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                // activeTrackColor: Colors.amber,
              )),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          locale: Locale(GeneralServices.getLocale()),
          home: const HomeWidget(),
        );}),
      );
    }
  }
}
