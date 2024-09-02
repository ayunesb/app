import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:paradigm_mex/blocs/favorites/favorites_bloc.dart';
import 'package:paradigm_mex/blocs/filters/filters_bloc.dart';
import 'package:paradigm_mex/blocs/language/language_change_bloc.dart';
import 'package:paradigm_mex/blocs/location/location_bloc.dart';
import 'package:paradigm_mex/blocs/property/property_list_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/theme/app_colors.dart';
import 'package:paradigm_mex/ui/pages/map/map.dart';
import 'package:paradigm_mex/ui/pages/settings/settings.dart';
import 'package:paradigm_mex/ui/widgets/property/property_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../blocs/settings/settings_bloc.dart';
import '../../controllers/SlideUpController.dart';
import '../../models/settings.dart';
import '../components/SlideUpWidget.dart';
import '../components/settings_selector.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State createState() => _HomeState();
}
class _HomeState extends State
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _currentIndex = 0;
  Location location = new Location();
  SlideUpController slideUpController = SlideUpController();

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      showLanguageSelector();
    });

    BlocProvider.of<SettingsBloc>(context)
        .add(SettingsInitialEvent());

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          // Start animation at begin
          slideUpController.toggle();
        } else if (status == AnimationStatus.dismissed) {
          // To hide widget, we need complete animation first
          slideUpController.toggle();
        }
      });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  List<AppSettings> settings = [];
  String phoneNumber = "+529842546755";
  @override
  Widget build(BuildContext context) {
    final List _children = [
      MapSample(animationController: _controller),
      PropertyListWidget(
          listType: ListType.FAVORITES, animationController: _controller),
      const SettingsPage()
    ];
    BlocProvider.of<FiltersBloc>(context).add(FiltersInitialEvent(context));
    BlocProvider.of<FavoritesBloc>(context).add(TypeViewSelectedEvent());
    BlocProvider.of<LocationBloc>(context).add(LocationLoad(context));
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
      if (state is SettingsLoadSuccessState) {
        settings = state.allSettings;
        AppSettings? agentPhone =  AppSettings.getSetting(settings, SettingsType.agentPhone);
        if(agentPhone != null){
          phoneNumber = agentPhone.value;
        }
      }
      return Stack(children: [
        Center(
          child: _children.elementAt(_currentIndex),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpeedDial(
                      backgroundColor: AppColor.fabBackgroundColor,
                      activeBackgroundColor: Colors.white,
                      activeForegroundColor: Colors.white70,
                      icon: Icons.forum_outlined,
                      activeIcon: Icons.close,
                      spaceBetweenChildren: 24,
                      children: [
                        SpeedDialChild(
                            child: const Icon(
                              FontAwesomeIcons.whatsapp,
                            ),
                            label: 'WhatsApp',
                            onTap: () {
                              _openWhatsApp(phoneNumber);
                            }),
                        SpeedDialChild(
                            child: const Icon(Icons.message_outlined),
                            label: 'SMS',
                            onTap: () {
                              _openSMS(phoneNumber);
                            }),
                        SpeedDialChild(
                            child: const Icon(Icons.phone_outlined),
                            label: 'Call',
                            onTap: () {
                              _makePhoneCall(phoneNumber);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              BlocBuilder<PropertyListBloc, PropertyListState>(
                builder: (context, state) {
                  if (state is PropertyListLoadSuccessState) {
                    return SlideTransition(
                      position: _offsetAnimation,
                      child: SlideUpWidget(
                        controller: slideUpController,
                        properties: state.propertyList.list,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        )
      ]);}),
      bottomNavigationBar: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: AppColor.bottomNavigationBackground,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (int index) {
              _controller.reverse();
              setState(() {
                _currentIndex = index;
              });
            },
            // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_on_outlined),
                label: S.of(context).explore,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border_outlined),
                label: S.of(context).favorite,
              ),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_applications_outlined),
                  label: S.of(context).settings)
            ],
          );
        },
      ),
    );
  }

  //
  showLanguageSelector() async {
    if (GeneralServices.getUser().name.isEmptyOrNull || GeneralServices.firstTimeOnApp()) {
      //choose language
      await showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AppLanguageSelector());
        },
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  // _openWhatsApp(String phoneNumber) async {
  //   var urlAndroid = "whatsapp://send?phone=" +
  //       phoneNumber +
  //       "&text=Contacta%20a%20un%20asesor%20para%20más%20información";
  //   var urlIOS =
  //       "https://wa.me/$phoneNumber?text=${Uri.parse("Contacta%20a%20un%20asesor%20para%20más%20información")}";
  //   if (Platform.isIOS) {
  //     // for iOS phone only
  //     if (await canLaunch(urlAndroid)) {
  //       await launch(urlIOS, forceSafariVC: false);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("WhatsApp not installed")));
  //     }
  //   } else {
  //     // android , web
  //     if (await canLaunch(urlAndroid)) {
  //       await launch(urlIOS);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("WhatsApp not installed")));
  //     }
  //   }
  // }
  //
  // _openSMS(String phoneNumber) async {
  //   // Android
  //   var uri =
  //       "sms:$phoneNumber?body=Contacta%20a%20un%20asesor%20para%20más%20información";
  //   if (await canLaunch(uri)) {
  //     await launch(uri);
  //   } else {
  //     // iOS
  //     var uri =
  //         'sms:$phoneNumber?body=Contacta%20a%20un%20asesor%20para%20más%20información';
  //     if (await canLaunch(uri)) {
  //       await launch(uri);
  //     } else {
  //       throw 'Could not launch $uri';
  //     }
  //   }
  // }
  String msgEN = "Please contact me about Hunt properties.";

  String msgES = "Por favor contácteme sobre propiedades Hunt";
  _openWhatsApp(String _phoneNumber) async {
    try {
      Uri url = Uri.parse("whatsapp://send?phone=${_phoneNumber}" +
          "&text=${Uri.encodeComponent(GeneralServices.getLocale() == "en" ? msgEN : msgES)}");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(GeneralServices.getLocale() == "en" ? "WhatsApp no installed" : "WhatsApp no instalado")));
      }
    } on FormatException catch (e) {
      print('Error creating URI: ${e.toString()}');
    } on PlatformException catch (e) {
      print('Error launching WhatsApp: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(GeneralServices.getLocale() == "en" ? "Error sending WhatsApp message" : "Error mandando mensaje WhatsApp")));
    }
  }

  _openSMS(String _phoneNumber) async {
    final separator = Platform.isIOS ? '&' : '?';
    try {
      Uri uri =
      Uri.parse('sms://${_phoneNumber}${separator}body=${Uri.encodeComponent(GeneralServices.getLocale() == "en" ? msgEN : msgES)}');
      await launchUrl(uri);
    } on FormatException catch (e) {
      print('Error creating URI: ${e.toString()}');
    } on PlatformException catch (e) {
      print('Error launching SMS: ${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(GeneralServices.getLocale() == "en" ? "Error sending SMS" : "Error mandando SMS")));
    }
  }
}
