import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradigm_mex/controllers/SlideUpController.dart';
import 'package:paradigm_mex/generated/l10n.dart';
import 'package:paradigm_mex/providers/SlideUp_provider.dart';
import 'package:paradigm_mex/ui/widgets/property/property_common.dart';
import 'package:paradigm_mex/ui/widgets/property/property_detail.dart';
import 'package:provider/provider.dart';

import '../../blocs/ads/ad_bloc.dart';
import '../../blocs/ads/ad_list_bloc.dart';
import '../../blocs/widgets/marker_bloc.dart';
import '../../models/ad.dart';
import '../../models/property.dart';
import '../../service/general_services.dart';
import '../widgets/AdDialog.dart';

enum CardSize { small, large }

class PropertyDetailsCard extends StatefulWidget {
  final Property property;
  final CardSize size;

  PropertyDetailsCard({Key? key, required this.property, this.size = CardSize.large}) : super(key: key);

  @override
  _PropertyDetailsCardState createState() =>
      _PropertyDetailsCardState(property: this.property, size: this.size);
}
class _PropertyDetailsCardState extends State<PropertyDetailsCard> {
  final Property property;
  final CardSize size;


  _PropertyDetailsCardState({required this.property, required this.size}) : super();
  List<Ad> mainAds = <Ad>[];
  static int mainAdIndex = 0;
  Ad? ad;
  @override
  Widget build(BuildContext context) {

    String streetAddress = '';
    streetAddress +=
        property.houseNumber.isNotEmpty ? (property.houseNumber + ' ') : '';
    streetAddress += property.streetAddress.isNotEmpty
        ? (property.streetAddress + ', ')
        : '';
    streetAddress +=
        property.village.isNotEmpty ? (property.village + ', ') : '';
    streetAddress +=
        property.colonia.isNotEmpty ? (property.colonia + ', ') : '';
    streetAddress +=
        property.province.isNotEmpty ? (property.province + ', ') : '';
    streetAddress += property.country;



    return BlocBuilder<AdListBloc, AdListState>(builder: (context, state) {

      if (state is AdListLoadSuccessState) {
        List<Ad> ads = state.adList.list;
        mainAds = ads
            .where((oneAd) => (oneAd.size == AdSize.large))
            .toList();

      }
      if(ad == null) {
        ad = mainAds[mainAdIndex];
      }
      return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                property.propertyImages?.list?.first.url ?? '',
                width: size == CardSize.small ? 80 : 100,
                fit: BoxFit.cover,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: size == CardSize.small ? 80 : 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ); //do something
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: size == CardSize.small ? 80 : 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            GeneralServices.getCurrencyStr(
                                property.currentPrice,
                                property.currentPriceUSD),
                            style: TextStyle(fontSize: size == CardSize.small ? 14 : 16),
                          ),
                          if (property.regularPrice > 0.0)
                            Text(
                              '   (' +
                                  GeneralServices.getCurrencyStr(
                                      property.regularPrice,
                                      property.regularPriceUSD) +
                                  ')',
                              style: TextStyle(fontSize: size == CardSize.small ? 12 : 14),
                            ),
                          Spacer(),
                          FavoriteButton(property, () => {setState(() => {})})
                        ],
                      ),
                  ),
                  Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(property.propertyName.isNotEmpty ?
                                  property.propertyName : '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: size == CardSize.small ? 16 : 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              streetAddress,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Wrap(children: [
                            RichText(
                                text: TextSpan(children: <InlineSpan>[
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Icon(Icons.bed,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Inter',
                                ),
                                text: property.bedrooms.toString() + (size == CardSize.small ? '' : ' ' + S.of(context).bed),
                              ),
                            ])),
                            RichText(
                                text: TextSpan(children: <InlineSpan>[
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 0),
                                  child: Icon(Icons.shower_outlined,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Inter',
                                ),
                                text: property.bathrooms.toString() + (size == CardSize.small ? '' : ' ' + S.of(context).bath),
                              ),
                            ])),
                            RichText(
                                text: TextSpan(children: <InlineSpan>[
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 2),
                                  child: Icon(Icons.aspect_ratio,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Inter',
                                ),
                                text: GeneralServices.getSquareFootage(property.meters),
                              ),
                            ]))
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PropertyDetail(property, () => {setState(() => {})})),
          );


          if(ad != null) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return (ad != null) ? AdDialog(ad!) : Container();
              },
            );
            mainAdIndex = (mainAdIndex >= mainAds.length - 1) ? 0 : mainAdIndex + 1;
            ad = mainAds[mainAdIndex];
          }
        },
      ),
    );

    });
  }
}
