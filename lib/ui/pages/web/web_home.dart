import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/blocs/settings/settings_bloc.dart';
import 'package:paradigm_mex/service/ad_service.dart';
import 'package:paradigm_mex/service/analytics_service.dart';
import 'package:paradigm_mex/ui/pages/web/login_page.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/ads/ad_list_bloc.dart';
import '../../../blocs/filters/filters_bloc.dart';
import '../../../blocs/property/property_list_bloc.dart';
import '../../../blocs/reports/contact_report_bloc.dart';
import '../../../blocs/reports/contact_report_list_bloc.dart';
import '../../../service/database_service.dart';
import '../../../service/image_storage_service.dart';
import 'admin_ad_list.dart';
import 'admin_header_footer.dart';
import 'admin_property_list.dart';
import 'admin_report_list.dart';
import 'admin_settings.dart';

class WebHomeWidget extends StatefulWidget {
  const WebHomeWidget({Key? key}) : super(key: key);

  @override
  State createState() => _WebHomeState();
}

class _WebHomeState extends State {
  AnalyticsServices analytics = AnalyticsServices();

  @override
  Widget build(BuildContext context) {
    analytics.logScreen((WebHomeWidget).toString(), "Web Home");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => FiltersBloc()
            ..add(FiltersInitialEvent(context)),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => PropertyListBloc(
              databaseService: DatabaseService(),
              imageStorage: ImageStorageService())
            ..add(PropertyListInitialEvent(active: ActiveType.all)),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AdListBloc(
              adService: AdService())
            ..add(AdListInitialEvent()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => AdBloc(),
        ),
        BlocProvider(
          create: (context) =>
              ContactReportBloc(databaseService: DatabaseService()),
        ),
        BlocProvider(
          create: (context) =>
              ReportListBloc(databaseService: DatabaseService()),
        ),
        BlocProvider(
          create: (context) =>
              SettingsBloc(),
        ),
      ],
      child: MaterialApp(
        initialRoute: 'login_screen',
        routes: {
          'property_list': (context) =>
              Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AdminHeader(),
                        Container(
                            color: Color.fromRGBO(22, 28, 34, 1),
                            height: (MediaQuery.of(context).size.height - 64),
                            child: DefaultTabController(
                              length: 4,
                              child: Scaffold(
                                appBar: PreferredSize(
                                  preferredSize: Size.fromHeight(
                                      48.0), // here the desired height
                                  child: AppBar(
                                    bottom: const TabBar(
                                      tabs: [
                                        Tab(text: 'Properties'),
                                        Tab(text: 'Ads'),
                                        Tab(text: 'Reports'),
                                        Tab(text: 'Settings'),
                                      ],
                                    ),
                                  ),
                                ),
                                body: TabBarView(
                                  children: [
                                    AdminPropertyList(),
                                    AdminAdList(),
                                    AdminReportList(),
                                    AdminSettingsDetail()
                                  ],
                                ),
                              ),
                            )),
                      ])),
          '/': (context) => LoginScreen(),
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
