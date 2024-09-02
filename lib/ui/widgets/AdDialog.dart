import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../blocs/reports/contact_report_bloc.dart';
import '../../blocs/user/user_settings_bloc.dart';
import '../../models/ad.dart';
import '../../models/contact_report.dart';
import '../../models/user.dart';
import '../../service/analytics_service.dart';

class AdDialog extends StatelessWidget {
  final Ad ad;

  AdDialog(this.ad);

  double width = 300;
  double height = 300;

  @override
  Widget build(BuildContext context) {
    switch (ad.size) {
      case AdSize.small:
        height = 100;
        width = 300;
        break;
      case AdSize.medium:
        height = 320;
        width = 480;
        break;
      case AdSize.large:
        height = 320;
        width = 480;
        break;
    }

    // Restrict to max dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    height = height > screenHeight ? screenHeight : height;
    width = width > screenWidth ? screenWidth : width;

    _reportContact(context) async {
      ContactReport report = ContactReport();
      report.action = 'click';
      report.date = DateTime.now();
      report.adId = ad.id;
      User user = GeneralServices.getUser();
      report.phone = user.phone;
      report.email = user.email;
      report.userName = user.name;


      BlocProvider.of<ContactReportBloc>(context)
          .add(ContactReportAddEvent(contactReport: report));
    }

    var adImage = Image(
      image: CachedNetworkImageProvider(ad.url),
      fit: BoxFit.cover,
      width: width,
    );
    AnalyticsServices analytics = AnalyticsServices();
    return Container(
        height: height,
        width: width,
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              // Get available height and width of the build area of this widget. Make a choice depending on the size.
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                height: height,
                width: width,
                child: Stack(children: [
                  Container(
                      height: double.infinity,
                      width: double.infinity,
                      //margin: EdgeInsets. all(10),
                      child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                        User user = User();
                        if (state is UserLoadedSuccess) {
                          user = state.user;
                        } else if (state is UserUpdatedSuccess) {
                          user = state.user;
                        }
                        return InkWell(
                            onTap: () async => {
                                  _reportContact(context),
                                  analytics.logEvent('hunt_ad_click',
                                      {'user.name': user.name, 'user_phone': user.phone, 'user.email': user.email}),
                                  if (ad.url.isNotEmptyAndNotNull)
                                    {
                                      if (await canLaunchUrl(Uri.parse(ad.to)))
                                        {await launchUrl(Uri.parse(ad.to))}
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Failed to launch link')))
                                        }
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Failed to launch link')))
                                    },
                                  Navigator.pop(context)
                                },
                            child: adImage);
                      })),
                  Positioned(
                      top: 0,
                      left: 0,
                      width: width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(40, 40),
                                  backgroundColor: Color.fromRGBO(0, 0, 0, .5),
                                  foregroundColor:
                                      Color.fromRGBO(255, 255, 255, .6),
                                  shape: CircleBorder(
                                      side: BorderSide(
                                    width: 40,
                                    color: Color.fromRGBO(0, 0, 0, .5),
                                  ))),
                              child: const Icon(Icons.close),
                            ),
                          ])),
                ]),
              );
            },
          ),
        ));
  }
}
