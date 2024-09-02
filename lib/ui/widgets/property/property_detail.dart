import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;
import 'package:paradigm_mex/blocs/ads/ad_list_bloc.dart';
import 'package:paradigm_mex/blocs/property/property_bloc.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/general_services.dart';
import 'package:paradigm_mex/ui/widgets/property/property_common.dart';
import 'package:paradigm_mex/ui/widgets/property/property_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/reports/contact_report_bloc.dart';
import '../../../blocs/settings/settings_bloc.dart';
import '../../../blocs/user/user_settings_bloc.dart';
import '../../../models/ad.dart';
import '../../../models/contact_report.dart';
import '../../../models/settings.dart';
import '../../../models/user.dart';
import '../../../service/analytics_service.dart';
import '../AdDialog.dart';
import '../StreetViewWidget.dart';
import '../TitleAccordionWidget.dart';
class PropertyDetail extends StatelessWidget {
  late Property property;
  late Function() onChange;
  late bool adShowed = false;
  static int propertyAdIndex = 0;
  PropertyDetail(this.property, this.onChange) : super();

  int mainAdIndex = 0;
  List<AppSettings> settings = [];
  String phoneNumber = "+5298425467545";
  @override
  Widget build(BuildContext context) {
    Future _share(Property property) async {
      await Share.share(
        'I thought you might be interested in this property:' +
            property.fullAddress +
            '\n' +
            'Download the Hunt app and click here:' +
            'http://paradigm-mx.web.app/#/property/${property.id}',
        subject: 'Check out this great property!',
      );
    }

    BlocProvider.of<AdListBloc>(context)
        .add(AdListFilteredLoadEvent(active: true, type: AdType.all));


    double y = MediaQuery.of(context).size.height * 0.0218;

    return BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
      if (state is SettingsLoadSuccessState) {
        settings = state.allSettings;
        AppSettings? agentPhone =  AppSettings.getSetting(settings, SettingsType.agentPhone);
        if(agentPhone != null){
          phoneNumber = agentPhone.value;
        }
      } return BlocBuilder<AdListBloc, AdListState>(builder: (context, state) {
      List<Ad> embeddedAds = <Ad>[];
      List<Ad> mainPropertyAds = <Ad>[];
      List<Ad> mainAds = <Ad>[];
      if (state is AdListLoadSuccessState) {
        List<Ad> ads = state.adList.list;
        embeddedAds = ads
            .where((oneAd) => (oneAd.size == AdSize.small))
            .toList();
        mainPropertyAds = ads
            .where((oneAd) => (oneAd.size == AdSize.medium))
            .toList();

        mainAds = ads
            .where((oneAd) => (oneAd.size == AdSize.large))
            .toList();

        if (!adShowed && mainPropertyAds.isNotEmpty) {
          propertyAdIndex = (propertyAdIndex >= mainPropertyAds.length-1) ? 0: propertyAdIndex +1;
          mainAdIndex = (mainAdIndex >= mainAds.length-1) ? 0 :mainAdIndex +1 ;

          adShowed = true;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AdDialog(mainPropertyAds.elementAt(propertyAdIndex));
                    },
                  ));
        }
      }

      return Container(
          child: Scaffold(
              body: SafeArea(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
            Expanded(
                child: ListView(children: [
              Stack(children: [
                ImageRow(images: property.propertyImages),
                Positioned(
                    top: y,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(40, 40),
                                  primary: Color.fromRGBO(0, 0, 0, .5),
                                  shape: CircleBorder(
                                      side: BorderSide(
                                    width: 40,
                                    color: Color.fromRGBO(0, 0, 0, .5),
                                  ))),
                              child: const Icon(Icons.close),
                            ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FavoriteButton(property, onChange),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      splashRadius: 0.2,
                                      splashColor: Colors.black,
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.black,
                                        size: 19.0,
                                        semanticLabel: 'Share',
                                      ),
                                      onPressed: () {
                                        _share(property);
                                      },
                                    ))
                              ])
                        ])),
              ]),
              PriceRow(property: this.property),
              AddressRow(property: property),
              AmenitiesRow(property: property),
              DescriptionRow(property: property),
              ContactPanel(property: property, phoneNumber: phoneNumber),
              AmenitiesWidget(property),
              MapWidget(property),
            ])),
            AdWidget(embeddedAds),
          ]))));
    });});
  }
}

class ImageRow extends StatelessWidget {
  static const imageHeight = 250.0;
  static const imageWidth = 84.0;
  static const padding = 4.0;
  late final PropertyImageList images;

  ImageRow({PropertyImageList? images}) : super() {
    this.images = images ?? PropertyImageList([]);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: imageHeight,
        child: InkWell(
            onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PropertyGallery(images)),
                  )
                },
            child: PageView.builder(
                itemCount: images.list.length,
                pageSnapping: true,
                itemBuilder: (context, pagePosition) {
                  return Container(
                      height: imageHeight,
                      //margin: EdgeInsets. all(10),
                      child: Image.network(
                        images.list[pagePosition].url!,
                        fit: BoxFit.cover,
                        height: imageHeight,
                        width: width,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text('Error loading image: ${error}'),
                          ); //do something
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ));
                })));
  }
}

class PriceRow extends StatelessWidget {
  static const padding = 4.0;
  final Property property;

  const PriceRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 55.0,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.fromLTRB(padding, 0, 8 * padding, 0),
                  child: Text(
                    S.of(context).huntPrice +
                        ': ' +
                        GeneralServices.getCurrencyStr(
                            this.property.currentPrice,
                            this.property.currentPriceUSD),
                    style: TextStyle(fontSize: 14),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.fromLTRB(padding, 0, 8 * padding, 0),
                  child: Text(
                    S.of(context).regularPrice +
                        ': ' +
                        GeneralServices.getCurrencyStr(
                            this.property.regularPrice,
                            this.property.regularPriceUSD),
                    style: TextStyle(fontSize: 14),
                  )),
            ],
          )
        ]));
  }
}

class AddressRow extends StatelessWidget {
  static const width = 340.0;
  static const padding = 4.0;
  final Property property;

  const AddressRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    String streetAddress = '';
    streetAddress += this.property.houseNumber.isNotEmpty
        ? (this.property.houseNumber + ' ')
        : '';
    streetAddress += this.property.streetAddress.isNotEmpty
        ? (this.property.streetAddress + ', ')
        : '';
    streetAddress +=
        this.property.village.isNotEmpty ? (this.property.village + ', ') : '';
    streetAddress +=
        this.property.colonia.isNotEmpty ? (this.property.colonia + ', ') : '';
    streetAddress += this.property.province.isNotEmpty
        ? (this.property.province + ', ')
        : '';
    streetAddress += this.property.country;
    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 0, 0, padding),
      child: Column(children: [
        if (this.property.propertyName.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                this.property.propertyName,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(streetAddress,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                  )),
            ),
          ],
        ),
      ]),
    );
  }
}

class AmenitiesRow extends StatelessWidget {
  static const width = 340.0;
  static const padding = 4.0;
  final Property property;

  const AmenitiesRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(padding, 0, 0, 20),
        child: IntrinsicHeight(
          child: Row(children: <Widget>[
            RichText(
              text: TextSpan(
                children: <InlineSpan>[
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.bed,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text: ' ${this.property.bedrooms.toString()} ' +
                        S.of(context).bed,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1,
              width: 20,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.shower,
                        size: 12,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text:
                        ' ${this.property.bathrooms.toString()} ${S.of(context).bath}',
                  ),
                ],
              ),
            ),
            VerticalDivider(
              thickness: 1,
              width: 20,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 4.0),
                        child: Icon(Icons.aspect_ratio,
                            size: 12,
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Inter',
                    ),
                    text: GeneralServices.getSquareFootage(property.meters),
                  ),
                ],
              ),
            ),
            if (property.yearBuilt > 0)
              VerticalDivider(
                thickness: 1,
                width: 20,
                color: Color.fromRGBO(219, 219, 219, 1.0),
              ),
            if (property.yearBuilt > 0)
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'Inter',
                  ),
                  text: property.yearBuilt.toString(),
                ),
              ),
            VerticalDivider(
              thickness: 1,
              width: 20,
              color: Color.fromRGBO(219, 219, 219, 1.0),
            ),
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(3),
              color: Color.fromRGBO(248, 248, 248, 1.0),
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      // TODO change color based on status?
                      child: Icon(Icons.circle,
                          size: 6, color: Color.fromRGBO(255, 198, 50, 1.0)),
                    ),
                    TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(80, 80, 80, 1.0),
                          fontFamily: 'Inter',
                        ),
                        text: " " +
                            ((GeneralServices.getLocale() == "en"
                                    ? this.property.status?.enLabel
                                    : this.property.status?.esLabel) ??
                                "")),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

class DescriptionRow extends StatelessWidget {
  static const width = 340.0;
  static const padding = 4.0;
  final Property property;

  const DescriptionRow({required this.property}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 0, 0, padding),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleAccordionWidget(
                      title: S.of(context).description,
                      contain: Text(
                          (GeneralServices.getLocale() == "en"
                              ? this.property.enDescription
                              : this.property.esDescription),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ))),
                ],
              ),
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TitleAccordionWidget(
                        expanded: false,
                        title: S.of(context).neighborhood,
                        contain: this.property.neighborhoodLink.isEmpty
                            ? Text(
                                (GeneralServices.getLocale() == "en"
                                    ? this.property.enNeighborhoodDescription
                                    : this.property.esNeighborhoodDescription),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ))
                            : GestureDetector(
                                child: Text(S.of(context).click_to_see_video,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue)),
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      this.property.neighborhoodLink));
                                  // do what you need to do when "Click here" gets clicked
                                })),
                  ],
                ),
              )),
            ],
          ),
        ),
        if (this.property.enLegalDocuments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleAccordionWidget(
                          expanded: false,
                          title: S.of(context).legal_doc,
                          contain: Text(
                              (GeneralServices.getLocale() == "en"
                                  ? this.property.enLegalDocuments
                                  : this.property.esLegalDocuments),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Inter',
                              ))),
                    ],
                  ),
                )),
              ],
            ),
          ),
      ]),
    );
  }
}

enum ShareType { sms, phone, whatsapp }

class ContactItem extends StatelessWidget {
  final Icon icon;
  final ShareType type;
  late void Function() _callback = () => {};
  final String phoneNumber;
  final Property property;

  ContactItem({required this.icon, required this.type, required this.property, required this.phoneNumber})
      : super();

  @override
  Widget build(BuildContext context) {
    Future<void> _makePhoneCall() async {
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

    String msgEN = "I am interested in the property ${property.propertyName} at " +
        "${property.houseNumber} ${property.streetAddress}, in ${property.village}." +
        " Could you please contact me to know more about it?";

    String msgES = "Estoy interesado en la propiedad ${property.propertyName} en " +
        "${property.houseNumber} ${property.streetAddress}, en ${property.village}." +
        " Por favor, podría contactarme para saber más de ella?";
    _openWhatsApp() async {
      try {
        Uri url = Uri.parse("whatsapp://send?phone=${phoneNumber}" +
            "&text=${Uri.encodeComponent(GeneralServices.getLocale() == "en" ? msgEN : msgES)}");
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(GeneralServices.getLocale() == "en"
                  ? "WhatsApp no installed"
                  : "WhatsApp no instalado")));
        }
      } on FormatException catch (e) {
        print('Error creating URI: ${e.toString()}');
      } on PlatformException catch (e) {
        print('Error launching WhatsApp: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(GeneralServices.getLocale() == "en"
                ? "Error sending WhatsApp message"
                : "Error mandando mensaje WhatsApp")));
      }
    }

    _openSMS() async {
      final separator = Platform.isIOS ? '&' : '?';
      try {
        Uri uri = Uri.parse(
            'sms://${phoneNumber}${separator}body=${Uri.encodeComponent(GeneralServices.getLocale() == "en" ? msgEN : msgES)}');
        await launchUrl(uri);
      } on FormatException catch (e) {
        print('Error creating URI: ${e.toString()}');
      } on PlatformException catch (e) {
        print('Error launching SMS: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(GeneralServices.getLocale() == "en"
                ? "Error sending SMS"
                : "Error mandando SMS")));
      }
    }

    String title = "";
    switch (this.type) {
      case (ShareType.whatsapp):
        {
          title = S.of(context).whatsapp;
          _callback = _openWhatsApp;
          break;
        }
      case (ShareType.sms):
        {
          title = S.of(context).sms;
          _callback = _openSMS;
          break;
        }
      case (ShareType.phone):
        {
          title = S.of(context).call;
          _callback = _makePhoneCall;
          break;
        }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          splashColor: Colors.black,
          icon: this.icon,
          onPressed: () {
            _callback();
          },
        ),
        Text(title),
      ],
    );
  }
}

class ContactPanel extends StatelessWidget {
  final Property property;
  final String phoneNumber;

  const ContactPanel({required this.property, required this.phoneNumber}) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 11, 8, 11),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/lola.png'),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).contact_us,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ContactItem(
                                    icon: const Icon(
                                      FontAwesomeIcons.whatsapp,
                                    ),
                                    type: ShareType.whatsapp,
                                    property: property,
                                    phoneNumber: phoneNumber),
                                ContactItem(
                                    icon: const Icon(
                                      Icons.message_outlined,
                                    ),
                                    type: ShareType.sms,
                                    property: property,
                                    phoneNumber:phoneNumber),
                                ContactItem(
                                    icon: const Icon(
                                      Icons.phone_outlined,
                                    ),
                                    type: ShareType.phone,
                                    property: property,
                                    phoneNumber: phoneNumber),
                              ])
                        ])))
          ],
        ));
  }
}

class AmenitiesWidget extends StatelessWidget {
  final Property property;

  AmenitiesWidget(this.property);

  @override
  Widget build(BuildContext context) {
    List<Widget> amenities = property.amenities
        .map((e) => Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(239, 255, 254, 1),
                ),
                child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      'assets/svg/${e.name.replaceAll(RegExp(r' '), '_').toLowerCase()}.svg',
                    )),
              ),
              Text(
                ((GeneralServices.getLocale() == "en" ? e.enLabel : e.esLabel)),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              ),
            ]))
        .toList();

    return AccordionWidget(
        icon: const Icon(Icons.star_outlined, size: 17),
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: amenities,
        ),
        title: S.of(context).AMENITIES,
        expanded: true);
  }
}

class AdWidget extends StatelessWidget {
  final List<Ad> ads;

  AdWidget(this.ads);
  AnalyticsServices analytics = AnalyticsServices();

  _reportContact(context, Ad ad) async {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.height;
    double height = 50;

    List<Widget> adImages = ads.map((ad) {
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
      return Container(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
              onTap: () async => {
                    _reportContact(context, ad),
                    if (ad.url.isNotEmptyAndNotNull)
                      {
                        if (await canLaunchUrl(Uri.parse(ad.to)))
                          {await launchUrl(Uri.parse(ad.to))}
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to launch link')))
                          }
                      }
                    else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to launch link')))
                      },
                    Navigator.pop(context)
                  },
              child: Image(
                image: CachedNetworkImageProvider(ad.url),
                fit: BoxFit.cover,
                width: width,
              )));
    }).toList();

    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      User user = User();
      if (state is UserLoadedSuccess) {
        user = state.user;
      } else if (state is UserUpdatedSuccess) {
        user = state.user;
      }
      return CarouselSlider(
          items: adImages,
          options: CarouselOptions(
            height: height,
            // aspectRatio: 16/9,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 10),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            // enlargeFactor: 0.3,
            onPageChanged: (page, reason) => {
              analytics.logEvent('ad_show', {
                'user_name': user.name,
                'user_phone': user.phone,
                'user_email': user.email,
                'ad_id': ads[page].id
              })
            },
            scrollDirection: Axis.horizontal,
          ));
    });
  }
}

class MapWidget extends StatelessWidget {
  final Property property;

  MapWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return AccordionWidget(
        icon: const Icon(Icons.maps_home_work, size: 17),
        child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(children: [
              Container(
                  height: 200,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(property.location!.latitude,
                            property.location!.longitude),
                        zoom: 15.0),
                    markers: {
                      Marker(
                          markerId: MarkerId(property.id),
                          position: LatLng(property.location!.latitude,
                              property.location!.longitude))
                    },
                    myLocationEnabled: false,
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 14, 0, 16),
                  child: SizedBox.fromSize(
                      size: Size(double.infinity, 41),
                      child: OutlinedButton(
                          onPressed: () => {openMaps(property)},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(color: Colors.red))),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                return Colors.white;
                              }),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                return Colors.black;
                              })),
                          child: Text(S.of(context).directions,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ))))),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 6, 0, 8),
                  child: SizedBox.fromSize(
                      size: Size(double.infinity, 41),
                      child: OutlinedButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyStreetViewWidget(property)),
                                )
                              },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(color: Colors.red))),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                return Colors.white;
                              }),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                return Colors.black;
                              })),
                          child: Text("Street View",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ))))),
            ])),
        title: S.of(context).MAP,
        expanded: true);
  }
}

class AccordionWidget extends StatefulWidget {
  final Widget child;
  final String title;
  late bool expanded;
  final Icon icon;

  AccordionWidget(
      {required this.child,
      required this.title,
      this.expanded = true,
      required this.icon});

  @override
  _AccordionState createState() => _AccordionState(
      child: this.child,
      title: this.title,
      expanded: this.expanded,
      icon: this.icon);
}

class _AccordionState extends State<AccordionWidget> {
  late bool expanded;
  final Widget child;
  final String title;
  final Icon icon;

  _AccordionState(
      {required this.child,
      required this.title,
      this.expanded = true,
      required this.icon});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              horizontalTitleGap: 4,
              minLeadingWidth: 20,
              visualDensity: VisualDensity.compact,
              leading: icon,
              title: Text(
                this.title,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          body: child,
          isExpanded: expanded,
          canTapOnHeader: true,
        ),
      ],
      dividerColor: Colors.grey,
      expansionCallback: (panelIndex, isExpanded) {
        expanded = !expanded;
        setState(() {});
      },
    );
  }
}

class PropertyDetailWrapper extends StatefulWidget {
  final String propertyId;

  PropertyDetailWrapper(this.propertyId) : super();

  @override
  _PropertyDetailWrapperState createState() {
    return _PropertyDetailWrapperState(this.propertyId);
  }
}

class _PropertyDetailWrapperState extends State<PropertyDetailWrapper> {
  final String propertyId;
  late Property _property;

  _PropertyDetailWrapperState(this.propertyId) : super();

  @override
  void initState() {
    BlocProvider.of<PropertyBloc>(context).add(PropertyInitialEvent());
    BlocProvider.of<PropertyBloc>(context)
        .add(PropertyLoadingEvent(propertyId: propertyId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyBloc, PropertyState>(builder: (context, state) {
      if (state is PropertyLoadSuccessState) {
        _property = state.property;
        return PropertyDetail(_property, () => {});
      } else {
        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      }
    });
  }
}

openMaps(Property property) async {
  final availableMaps = await mapLauncher.MapLauncher.installedMaps;
  availableMaps.first.showMarker(
      coords: new mapLauncher.Coords(
          property.location!.latitude, property.location!.longitude),
      title: property.fullAddress);
}
