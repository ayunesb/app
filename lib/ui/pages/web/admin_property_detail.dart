import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paradigm_mex/models/image.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/ui/pages/web/admin_header_footer.dart';

import '../../../blocs/property/property_list_bloc.dart';
import '../../../service/database_service.dart';
import 'admin_property_edit_form.dart';

class AdminPropertyDetail extends StatefulWidget {
  late Property property;
  final bool add;

  AdminPropertyDetail({Key? key, required this.property, this.add = false})
      : super(key: key) {
    this.property = this.property;
  }

  @override
  State createState() => _AdminPropertyDetailState(property);
}

class _AdminPropertyDetailState extends State {
  late Property property;
  bool _edit = false;

  _AdminPropertyDetailState(this.property);
  final moneyFormatter =
      NumberFormat.currency(name: '', locale: 'es_mx', symbol: '\$');

  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    double imageDimension = 100;

    List<Widget> images = [];

    PropertyImageList? imageList = property.propertyImages != null
        ? property.propertyImages
        : PropertyImageList([]);
    for (int i = 0; i < imageList!.list.length; i++) {
      PropertyImage img = imageList.list[i];
      print('33333333333333333333${imageList.list.length}');
      images.add(Container(
          height: imageDimension,
          //margin: EdgeInsets. all(10),
          child: InkWell(
            onTap: () => {},
            child: Stack(children: [
              Image.network(
                img.url!,
                fit: BoxFit.cover,
                height: imageDimension,
                width: imageDimension,
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
              ),
            ]),
          )));
    }
    ;

    String amenitiesStr = "";
    bool first = true;
    for (PropertyEnum amenity in property.amenities) {
      if (first) {
        first = false;
      } else {
        amenitiesStr += ', ';
      }
      amenitiesStr += amenity.enLabel;
    }

    var headerStyle = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'Inter');
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            AdminHeader(),
            Container(
                width: 1090,
                alignment: Alignment.topCenter,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 170, vertical: 30),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(
                                        splashColor: Colors.black,
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Text('Single Property',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                          )),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () async {

                                                Property updatedProperty = await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AdminPropertyEditForm(
                                                        property: property,
                                                        add: false);
                                                  },
                                                ).whenComplete(() {
                                                  setState(() {
                                                    print('1111111111111111111111111111${property.propertyImages?.list.length}');
                                                    property = property;
                                                  });
                                                });
                                                setState(() {
                                                  print('22222222222222222222222222:${updatedProperty.propertyImages?.list.length}');
                                                  property = updatedProperty;
                                                });
                                              },
                                          child: Text("EDIT")),
                                    ]),
                              ]),
                          ConstrainedBox(
                              constraints: BoxConstraints.expand(
                                  width: MediaQuery.of(context).size.width,
                                  height: 3200),
                              child: Column(children: [
                                SizedBox(
                                  height: 24.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('LOCATION INFO',
                                        textAlign: TextAlign.left,
                                        style: headerStyle)),
                                Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(.33),
                                    1: FractionColumnWidth(.66)
                                  },
                                  children: [
                                    _createRow(
                                        'Property Name', property.propertyName),
                                    _createRow('Street Address',
                                        property.streetAddress),
                                    _createRow(
                                        'Unit Number', property.houseNumber),
                                    _createRow(
                                        'Postal Code/Zip', property.postalCode),
                                    _createRow('City', property.village),
                                    _createRow('Province', property.province),
                                    _createRow('Country', property.country),
                                    _createRow(
                                        'Neighborhood', property.colonia),
                                    _createRow('DB Status', property.dbStatus),
                                    _createRow('Promoted', property.promoted! ? "Yes" : "No"),
                                  ],
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('LISTING INFO',
                                        textAlign: TextAlign.left,
                                        style: headerStyle)),
                                Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(.33),
                                    1: FractionColumnWidth(.66)
                                  },
                                  children: [
                                    _createRow(
                                        'Hunt Price MXN',
                                        moneyFormatter
                                            .format(property.currentPrice)),
                                    _createRow(
                                        'Regular Price MXN',
                                        moneyFormatter
                                            .format(property.regularPrice)),
                                    _createRow(
                                        'Hunt Price USD',
                                        moneyFormatter
                                            .format(property.currentPriceUSD)),
                                    _createRow(
                                        'Regular Price USD',
                                        moneyFormatter
                                            .format(property.regularPriceUSD)),
                                    _createRow('Type', property.type),
                                    _createRow(
                                        'Status', property.status != null ? property.status!.enLabel : ''),
                                    _createRow('Bedrooms',
                                        property.bedrooms.toString()),
                                    _createRow('Bathrooms',
                                        property.bathrooms.toString()),
                                    _createRow('Size',
                                        property.meters.toString() + ' sq/m'),
                                    _createRow('Year Built',
                                        property.yearBuilt.toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('DESCRIPTION',
                                        textAlign: TextAlign.left,
                                        style: headerStyle)),
                                Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(.33),
                                    1: FractionColumnWidth(.66)
                                  },
                                  children: [
                                    _createRow('Description (EN)',
                                        property.enDescription),
                                    _createRow('Description (SP)',
                                        property.esDescription),
                                    _createRow('Neighborhood Description (EN)',
                                        property.enNeighborhoodDescription),
                                    _createRow('Neighborhood Description (ES)',
                                        property.esNeighborhoodDescription),
                                    _createRow('Legal Documents (EN)',
                                        property.enLegalDocuments),
                                    _createRow('Legal Documents (ES)',
                                        property.esLegalDocuments),
                                  ],
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Amenities',
                                        textAlign: TextAlign.left,
                                        style: headerStyle)),
                                Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(.33),
                                    1: FractionColumnWidth(.66)
                                  },
                                  children: [
                                    _createRow(
                                        'Selected Amenities', amenitiesStr),
                                  ],
                                ),
                                SizedBox(
                                  height: 24.0,
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('IMAGES',
                                        textAlign: TextAlign.left,
                                        style: headerStyle)),
                                Expanded(
                                    child: GridView.count(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 8,
                                  childAspectRatio: 1.0,
                                  padding: const EdgeInsets.all(4.0),
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  children: images,
                                )),
                              ]))
                        ])))),
          ]),
        )));
  }

  @override
  void initState() {
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

class PropertyForm extends StatefulWidget {
  const PropertyForm({Key? key}) : super(key: key);

  @override
  _PropertyFormState createState() {
    return _PropertyFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class _PropertyFormState extends State<PropertyForm> {
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
