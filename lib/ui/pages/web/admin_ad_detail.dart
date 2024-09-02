
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../blocs/ads/ad_list_bloc.dart';
import '../../../models/ad.dart';
import '../../widgets/property/property_list.dart';
import 'admin_ad_edit_form.dart';
import 'admin_header_footer.dart';

class AdminAdDetail extends StatefulWidget {
  late String adId;
  final bool add;

  AdminAdDetail({Key? key, required this.adId, this.add = false})
      : super(key: key) {}

  @override
  State createState() => _AdminAdDetailState(adId);
}

class _AdminAdDetailState extends State {
  final String adId;
  late Ad ad;

  _AdminAdDetailState(this.adId);

  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    double imageHeight = 180;
    double imageWidth = 300;

    var headerStyle = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'Inter');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child:
            BlocBuilder<AdBloc, AdState>(builder: (context, state) {
          if (state is AdLoadSuccessState) {
            ad = state.ad!;

            switch (ad.size) {
              case AdSize.small:
                imageHeight = 50;
                break;
              case AdSize.medium:
                imageHeight = 100;
                break;
              case AdSize.large:
                imageHeight = 250;
                imageWidth = 250;
                break;
            }


            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                AdminHeader(),
                Container(
                    width: 1090,
                    alignment: Alignment.topCenter,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 170, vertical: 30),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          IconButton(
                                            splashColor: Colors.black,
                                            icon: const Icon(Icons.arrow_back),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          Text('Single Ad',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.black,
                                                fontFamily: 'Inter',
                                              )),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          OutlinedButton(
                                              onPressed: () => {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return


                                                          AdminAdEditForm(
                                                            adId: ad.id,
                                                            add: false);
                                                      },
                                                    ).whenComplete(() {
                                                      BlocProvider.of<
                                                                  AdListBloc>(
                                                              context)
                                                          .add(
                                                              AdListInitialEvent(
                                                                  active:
                                                                      true));
                                                      setState(() {});
                                                    })
                                                  },
                                              child: Text("EDIT")),
                                        ]),
                                  ]),
                              ConstrainedBox(
                                  constraints: BoxConstraints.expand(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height),
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('AGENT INFO',
                                            textAlign: TextAlign.left,
                                            style: headerStyle)),
                                    Table(columnWidths: {
                                      0: FractionColumnWidth(.33),
                                      1: FractionColumnWidth(.66)
                                    }, children: [
                                      _createRow('Ad Name', ad.name),
                                      TableRow(children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Text('Image:',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Inter'))),
                                        Container(
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.all(2.0),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 0),
                                              child: CachedNetworkImage(
                                                imageUrl: ad.url,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                    Container(
                                                      width: imageWidth,
                                                      height: imageHeight,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                        CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                    error) =>
                                                    Image.asset(
                                                        'assets/images/defaultProperty.png'),
                                              ),
                                            )),
                                      ]),
                                      _createRow('Link', ad.to),
                                      _createRow('Active', ad.active ? 'Active' : 'Inactive'),
                                      _createRow('Updated', ad.type.name),
                                      _createRow('Updated', ad.size.name),
                                      _createRow('Updated', ad.updatedAt.toString()),

                                    ]),
                                    SizedBox(
                                      height: 24.0,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('STATUS INFO',
                                            textAlign: TextAlign.left,
                                            style: headerStyle)),
                                    Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(.33),
                                        1: FractionColumnWidth(.66)
                                      },
                                      children: [
                                        _createRow('Active',
                                            ad.active ? 'Yes' : 'No'),
                                      ],
                                    ),
                                  ])))
                            ])))),
              ]),
            );
          } else if (state is AdLoadFailureState) {
            return Text('Error loading ad: ${state.err}');
          } else {
            return Center(
              child: LoadingIndicator(
                key: UniqueKey(),
              ),
            );
          }
        })));
  }

  @override
  void initState() {
    BlocProvider.of<AdBloc>(context)
        .add(AdLoadingEvent(adId: adId));
    isLoggedIn = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }

    super.initState();
  }
}

TableRow _createRow(final String label, final String value) {
  var textStyle = TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w400, fontFamily: 'Inter');
  return TableRow(children: [
    Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(label + ':', style: textStyle)),
    Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(value, style: textStyle))
  ]);
}

class AdForm extends StatefulWidget {
  const AdForm({Key? key}) : super(key: key);

  @override
  _AdFormState createState() {
    return _AdFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class _AdFormState extends State<AdForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}
