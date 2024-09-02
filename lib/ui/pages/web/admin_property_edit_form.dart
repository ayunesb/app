import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:intl/intl.dart';
import 'package:paradigm_mex/models/property.dart';
import 'package:paradigm_mex/service/image_storage_service.dart';
import 'package:paradigm_mex/service/property_types_service.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../models/image.dart';
import '../../../service/amenitites_service.dart';
import '../../../service/database_service.dart';
import '../../../service/property_status_service.dart';

PropertyImageList imageList = PropertyImageList([]);
Map<String, Uint8List> newImages = {};
String message = "";
String getExtension(String path) {
  return path.substring(path.lastIndexOf(".") + 1);
}

const kTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black87, fontStyle: FontStyle.italic),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(98, 0, 238, 1.0), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ));

var buttonStyle = OutlinedButton.styleFrom(
    minimumSize: Size(220, 48),
    backgroundColor: Colors.white,
    primary: Color.fromRGBO(0, 99, 152, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ));

var headerStyle =
    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'Inter');

var header700 = TextStyle(
    fontSize: 32,
    color: Colors.black,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700);

List<String> provinces = [
  "Aguascalientes",
  "Baja California",
  "Baja California Sur",
  "Campeche",
  "Chiapas",
  "Chihuahua",
  "Coahuila",
  "Colima",
  "Mexico City",
  "Durango",
  "Guanajuato",
  "Guerrero",
  "Hidalgo",
  "Jalisco",
  "México",
  "Michoacán",
  "Morelos",
  "Nayarit",
  "Nuevo León",
  "Oaxaca",
  "Puebla",
  "Querétaro",
  "Quintana Roo",
  "San Luis Potosí",
  "Sinaloa",
  "Sonora",
  "Tabasco",
  "Tamaulipas",
  "Tlaxcala",
  "Veracruz",
  "Yucatán",
  "Zacatecas"
];

List<DropdownMenuItem<String>> provinceList = provinces.map((e) {
  return DropdownMenuItem(child: Text(e), value: e);
}).toList();

List<String> countries = ["Mexico"];

List<DropdownMenuItem<String>> countryList = countries.map((e) {
  return DropdownMenuItem(child: Text(e), value: e);
}).toList();

class AdminPropertyEditForm extends StatefulWidget {
  late Property property;
  final bool add;

  AdminPropertyEditForm({Key? key, required this.property, this.add = false})
      : super(key: key) {}

  @override
  State createState() => _AdminPropertyEditFormState(property, add);
}

class _AdminPropertyEditFormState extends State {
  late Property property;
  late PropertyEnum? _propertyStatus;
  late PropertyEnum? _propertyType;
  final bool add;
  late PropertyStatusService _propertyStatusService;
  late PropertyTypesService _propertyTypesService;

  _AdminPropertyEditFormState(this.property, this.add) {
    _propertyStatusService = PropertyStatusService();
    _propertyTypesService = PropertyTypesService();
  }

  final moneyFormatter =
      NumberFormat.currency(name: '', locale: 'es_mx', symbol: '\$');
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  late DatabaseService _databaseService = DatabaseService();
  ImageStorageService _imageStorageService = ImageStorageService();
  bool loading = false;
  List<DropdownMenuItem<PropertyEnum>> _typesList = [];
  List<DropdownMenuItem<PropertyEnum>> _statusList = [];

  @override
  Widget build(BuildContext context) {
    message = '';
    double fullWidth = MediaQuery.of(context).size.width - 32;
    double horizontalSpace = 18;
    double verticalSpace = 24.0;
    double padding = 24.0;
    double columnWidth =
        (fullWidth - (2 * horizontalSpace) - (2.0 * padding) - (2.0 * 18)) / 3;
    return Dialog(
        insetPadding: EdgeInsets.all(16),
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Center(
                      child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: fullWidth,
                              alignment: Alignment.topCenter,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        splashColor: Colors.black,
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          this.add
                                              ? 'Add New Property'
                                              : 'Edit Property',
                                          textAlign: TextAlign.left,
                                          style: header700),
                                    ),
                                    Form(
                                        key: _formKey,
                                        onChanged: () => {},
                                        child: Column(
                                          children: [
                                            buttons(),
                                            locationInfoCard(horizontalSpace,
                                                columnWidth, verticalSpace),
                                            listingInfoCard(horizontalSpace,
                                                columnWidth, verticalSpace),
                                            descriptionCard(horizontalSpace,
                                                columnWidth, verticalSpace),
                                            AmenitiesCard(
                                                property: property,
                                                onChange: (List<PropertyEnum>
                                                        amenities) =>
                                                    {
                                                      setState(() {
                                                        property.amenities =
                                                            amenities;
                                                      })
                                                    },
                                                verticalSpace: verticalSpace,
                                                columnWidth: columnWidth),
                                            ImagesCard(
                                                property: property,
                                                verticalSpace: verticalSpace,
                                                columnWidth: 100),
                                            SizedBox(
                                              height: verticalSpace,
                                            ),
                                            Text(message),
                                            SizedBox(
                                              height: verticalSpace,
                                            ),
                                            buttons(),
                                            SizedBox(
                                              height: verticalSpace,
                                            ),
                                          ],
                                        ))
                                  ]))),
                        ]),
                  )))),
          if (loading)
            const Opacity(
              opacity: 0.5,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ]));
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

    if (this.add) {
      // set default values
      property.country = countries[0];
      property.province = "Quintana Roo";
      property.dbStatus = ActiveType.in_progress.name;
    }

    _propertyTypesService.getAllPropertyTypes().then((allTypes) {
      _typesList = [];
      allTypes.remove(allTypes.first);

      _typesList = allTypes.map((e) {
        return DropdownMenuItem(child: Text(e.enLabel), value: e);
      }).toList();

      _propertyType = _typesList[0].value;
      if (this.add) {
        property.type = _typesList[0].value!.name;
      }

      if (property.type.isNotEmpty) {
        for (PropertyEnum type in allTypes) {
          if (type.name == property.type) {
            _propertyType = type;
          }
        }
      }

      setState(() {});
    });

    _propertyStatusService.getAllPropertyStatuses().then((allStatuses) {
      _statusList = [];
      _statusList = allStatuses.map((e) {
        return DropdownMenuItem(child: Text(e.enLabel), value: e);
      }).toList();

      _propertyStatus = _statusList[0].value;
      if (this.add) {
        property.status = _statusList[0].value;
        property.statusId = _statusList[0].value!.name;
      }

      if (property.status != null) {
        for (PropertyEnum status in allStatuses) {
          if (status.name == property.status!.name) {
            _propertyStatus = status;
          }
        }
      }
      setState(() {});
    });

    super.initState();
  }

  Widget listingInfoCard(spaceBetween, columnWidth, verticalSpace) {
    List<String> dbStatuses = ActiveType.values.map((e) => e.name).toList();
    dbStatuses.remove(dbStatuses.first);

    List<DropdownMenuItem<String>> dbStatusList = dbStatuses.map((e) {
      return DropdownMenuItem(child: Text(e), value: e);
    }).toList();

    return // Listing
        Card(
            color: Color.fromRGBO(243, 245, 246, 1.0),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('LISTING INFO',
                            textAlign: TextAlign.left, style: headerStyle)),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: columnWidth,
                            child: DropdownButtonFormField(
                              value: property.dbStatus.isNotEmpty
                                  ? property.dbStatus
                                  : ActiveType.in_progress.name,
                              decoration: kTextFieldDecoration.copyWith(
                                hintText: "DB Status",
                              ),
                              items: dbStatusList,
                              onChanged: (Object? value) {
                                setState(() {
                                  property.dbStatus = value.toString();
                                });
                              },
                            )),
                        SizedBox(
                          width: 19.0,
                        ),
                        SizedBox(
                            width: columnWidth,
                            child: Row(children: [
                              Checkbox(
                                checkColor: Colors.white,
                                value: property.promoted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    property.promoted = value!;
                                  });
                                },
                              ),
                              Text('Promoted')
                            ])),
                      ],
                    ),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.currentPrice > 0 ? property.currentPrice : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Hunt Price MXN",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Hunt price in MXN';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.currentPrice = (value != null &&
                                        value.toString().isNotEmptyAndNotNull)
                                    ? double.parse(value
                                        .toString()
                                        .replaceAll(RegExp('[ ,%\$-]'), ''))
                                    : 0.0;
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.regularPrice > 0 ? property.regularPrice : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Regular Price MXN",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the regular price in MXN';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.regularPrice = (value != null &&
                                        value.toString().isNotEmptyAndNotNull)
                                    ? double.parse(value
                                        .toString()
                                        .replaceAll(RegExp('[ ,%\$-]'), ''))
                                    : 0;
                              });
                            },
                          )),
                    ]),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.currentPriceUSD > 0 ? property.currentPriceUSD : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Hunt Price USD",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Hunt price in USD';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.currentPriceUSD = (value != null &&
                                        value.toString().isNotEmptyAndNotNull)
                                    ? double.parse(value
                                        .toString()
                                        .replaceAll(RegExp('[ ,%\$-]'), ''))
                                    : 0;
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.regularPriceUSD > 0 ? property.regularPriceUSD : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Regular Price USD",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the regular price in USD';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.regularPriceUSD = (value != null &&
                                        value.toString().isNotEmptyAndNotNull)
                                    ? double.parse(value
                                        .toString()
                                        .replaceAll(RegExp('[ ,%\$-]'), ''))
                                    : 0;
                              });
                            },
                          )),
                    ]),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      //Type

                      _typesList.isNotEmpty
                          ? SizedBox(
                              width: columnWidth,
                              child: DropdownButtonFormField(
                                value: _propertyType,
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: "Type",
                                ),
                                items: _typesList,
                                onChanged: (Object? value) {
                                  setState(() {
                                    property.type =
                                        (value as PropertyEnum).name;
                                  });
                                },
                              ))
                          : Text(''),

                      // Status
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: _statusList.isNotEmpty
                            ? DropdownButtonFormField(
                                value: _propertyStatus,
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: "Status",
                                ),
                                items: _statusList,
                                onChanged: (Object? value) {
                                  setState(() {
                                    property.status = value as PropertyEnum;
                                    property.statusId = value.name;
                                    if (property.status!.name == "sold") {
                                      property.dbStatus =
                                          ActiveType.deleted.name;
                                    }
                                  });
                                },
                              )
                            : Text(''),
                      )
                    ]),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.bedrooms > 0 ? property.bedrooms : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Bedrooms",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter bedrooms';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.bedrooms = int.parse(value.toString());
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.bathrooms > 0 ? property.bathrooms : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Bathrooms",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter bathrooms';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.bathrooms =
                                    double.parse(value.toString());
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.meters > 0 ? property.meters : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Size",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter size';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.meters =
                                    double.parse(value.toString());
                              });
                            },
                          )),
                    ]),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(children: [
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue:
                                "${property.yearBuilt > 0 ? property.yearBuilt : ''}",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Year Built",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the year the property was built';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.yearBuilt = (value != null &&
                                        value.toString().isNotEmptyAndNotNull)
                                    ? int.parse(value.toString())
                                    : 0;
                              });
                            },
                          ))
                    ]),
                  ],
                )));
  }

  Widget locationInfoCard(spaceBetween, columnWidth, verticalSpace) {
    // LOCATION INFO
    return Card(
        color: Color.fromRGBO(243, 245, 246, 1.0),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: verticalSpace,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('LOCATION INFO',
                        textAlign: TextAlign.left, style: headerStyle)),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: ((columnWidth * 2.0) + spaceBetween),
                      child: TextFormField(
                        initialValue: property.propertyName.isNotEmpty
                            ? property.propertyName
                            : "",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Property Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name of the property';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            property.propertyName = value.toString();
                          });
                        },
                      )),
                ]),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: ((columnWidth * 2.0) + spaceBetween),
                      child: TextFormField(
                        initialValue: property.streetAddress.isNotEmpty
                            ? property.streetAddress
                            : "",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Street Address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter street address';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            property.streetAddress = value.toString();
                          });
                        },
                      )),
                  SizedBox(
                    width: spaceBetween,
                  ),
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue: property.houseNumber.isNotEmpty
                            ? property.houseNumber
                            : "",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Unit Number (optional)",
                        ),
                        onChanged: (Object? value) {
                          setState(() {
                            property.houseNumber = value.toString();
                          });
                        },
                      ))
                ]),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue: property.postalCode.isNotEmpty
                            ? property.postalCode
                            : "",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Postal Code",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter postal code';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            property.postalCode = value.toString();
                          });
                        },
                      )),
                  SizedBox(
                    width: 19.0,
                  ),
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue:
                            property.village.isNotEmpty ? property.village : "",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "City",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            property.village = value.toString();
                          });
                        },
                      )),
                  SizedBox(
                    width: spaceBetween,
                  ),
                  SizedBox(
                      width: columnWidth,
                      child: DropdownButtonFormField(
                        value: property.province.isNotEmpty
                            ? property.province
                            : "Yucatán",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Province",
                        ),
                        items: provinceList,
                        onChanged: (Object? value) {
                          setState(() {
                            property.province = value.toString();
                          });
                        },
                      ))
                ]),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: columnWidth,
                      child: DropdownButtonFormField(
                        value: property.country.isNotEmpty
                            ? property.country
                            : countries[0],
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Country",
                        ),
                        items: countryList,
                        onChanged: (Object? value) {
                          setState(() {
                            property.country = value.toString();
                          });
                        },
                      )),
                  SizedBox(
                    width: 19.0,
                  ),
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue: property.colonia,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Neighborhood",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter neighborhood';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            property.colonia = value.toString();
                          });
                        },
                      ))
                ]),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue:
                            "${property.location?.latitude != 0 ? property.location?.latitude : ''}",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Latitude",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter latitude';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            if (property.location == null) {
                              property.location = GeoPoint(0, 0);
                            }
                            property.location = GeoPoint(
                                double.parse(value.toString()),
                                property.location!.longitude);
                          });
                        },
                      )),
                  SizedBox(
                    width: 19.0,
                  ),
                  SizedBox(
                      width: columnWidth,
                      child: TextFormField(
                        initialValue:
                            "${property.location?.longitude != 0 ? property.location?.longitude : ''}",
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: "Longitude",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter longitude';
                          }
                          return null;
                        },
                        onChanged: (Object? value) {
                          setState(() {
                            if (property.location == null) {
                              property.location = GeoPoint(0, 0);
                            }
                            property.location = GeoPoint(
                                property.location!.latitude,
                                double.parse(value.toString()));
                          });
                        },
                      )),
                ]),
              ],
            )));
  }

  Widget descriptionCard(horizontalSpace, columnWidth, verticalSpace) {
    return // Description
        Card(
            color: Color.fromRGBO(243, 245, 246, 1.0),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('DESCRIPTION',
                          textAlign: TextAlign.left, style: headerStyle)),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.enDescription,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "English description",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter English Description';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.enDescription = value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.esDescription,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Spanish description",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Spanish description';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.esDescription = value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.enNeighborhoodDescription,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "English neighborhood description",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter English neighborhood description';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.enNeighborhoodDescription =
                                    value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.esNeighborhoodDescription,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Spanish neighborhood description",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Spanish neighborhood description';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.esNeighborhoodDescription =
                                    value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.neighborhoodLink.isNotEmpty
                                ? property.neighborhoodLink
                                : "",
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Link to the neighborhood video",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter link to neighborhood video';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.neighborhoodLink = value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.enLegalDocuments,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "English legal documents",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter English legal documents';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.enLegalDocuments = value.toString();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: verticalSpace,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: columnWidth * 2.0 + horizontalSpace,
                          child: TextFormField(
                            initialValue: property.esLegalDocuments,
                            minLines: 5,
                            maxLines: 10,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Spanish legal documents",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Spanish legal documents';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                property.esLegalDocuments = value.toString();
                              });
                            },
                          )),
                    ],
                  )
                ])));
  }

  Widget buttons() {
    return Row(children: [
      OutlinedButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });

          property.amenitiesIds = [];
          property.amenitiesIds = property.amenities.map((amenity) {
            return amenity.name;
          }).toList();
          property = await addOrEditProperty(property);
          setState(() {
            loading = false;
          });

          Navigator.pop(context, property);
        },
        style: OutlinedButton.styleFrom(
            minimumSize: Size(220, 48),
            backgroundColor: Color.fromRGBO(0, 99, 152, 1.0),
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            )),
        child: const Text('SAVE & CLOSE',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter')),
      ),
      SizedBox(
        width: 8.0,
      ),
      OutlinedButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });

          await addOrEditProperty(property);
          this.property = Property();
          setState(() {
            loading = false;
          });
        },
        style: buttonStyle,
        child: const Text('SAVE & ADD ANOTHER',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter')),
      ),
      SizedBox(
        width: 8.0,
      ),
      OutlinedButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });

          await addOrEditProperty(property);
          property.id = "";
          setState(() {
            loading = false;
          });
        },
        style: buttonStyle,
        child: const Text('SAVE & DUPLICATE',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter')),
      ),
      SizedBox(
        width: 8.0,
      ),
      OutlinedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        style: buttonStyle,
        child: const Text('CANCEL',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter')),
      ),
    ]);
  }

  Future<Property> addOrEditProperty(Property property) async {
    if (this.add) {
      String dbStatus = property.dbStatus;
      if (property.dbStatus != ActiveType.in_progress.name) {
        property.dbStatus = ActiveType.in_progress.name;
      }
      String id = await _databaseService.addProperty(property: property);
      property.id = id;
      message = "Added Property";

      if (dbStatus != ActiveType.in_progress.name) {
        property.dbStatus = dbStatus;
        bool success =
            await _databaseService.updateProperty(property: property);
        message = "Updated Property";
      }
    } else {
      bool success = await _databaseService.updateProperty(property: property);
    }

    //remove deleted images
    PropertyImageList imagesInDatabase =
        await _databaseService.getPropertyImages(property.id);
    imagesInDatabase.list.forEach((propertyImage) async {
      bool found = false;
      imageList.list.forEach((image) {
        found |= image.filePath == propertyImage.filePath;
      });
      if (!found) {
        await _imageStorageService.deleteImage(propertyImage);
        if (propertyImage.filePath.isNotEmptyAndNotNull) {
          await _databaseService
              .deletePropertyImage(propertyImage.filePath.toString());
        }
        else {
          print('+++++++++++++++++++ propertyImage:propertyId:${propertyImage.propertyId}:image id:${propertyImage.id}:path:${propertyImage.filePath.toString()}');
        }
      }
    });
    message = "Deleted images";

    // update images
    bool found = false;

    imageList.list.forEach((image) async {
      image.propertyId = property.id;
      bool success = await _databaseService.updatePropertyImage(image: image);
    });

    message = "Updated images";
    // add new images
    int order = imageList.list.length;

    print('----------------- 1');
    List<Future<dynamic>> futures = [];
    newImages.forEach((path, data) {
      futures.add(uploadNewImage(_imageStorageService, _databaseService,
          property, path, data, order++));
    });
    print('----------------- 3');
    newImages = {};

    var results = await Future.wait(futures);

    print('----------------- 4');
    message = "Added images";
    return property;
  }
}

uploadNewImage(
    ImageStorageService _imageStorageService,
    DatabaseService _databaseService,
    Property property,
    String path,
    Uint8List data,
    int order) async {
  print('----------------- 2');
  PropertyImage? propertyImage =
      await _imageStorageService.uploadImageData(property.id, data, path);
  if (propertyImage != null) {
    property.propertyImages?.list.add(propertyImage);
    print('----------------- 2.b');
    propertyImage.order = order;
    await _databaseService.addPropertyImage(propertyImage).then((value) {
      print('Added image to DB:' + propertyImage.filePath.toString());
    }, onError: (e) {
      print('Error adding image to DB:' + e.toString());
    });
  }
}

class ImagesCard extends StatefulWidget {
  Property property;
  double verticalSpace;
  double columnWidth;

  ImagesCard(
      {required this.property,
      required this.verticalSpace,
      required this.columnWidth})
      : super();

  @override
  State createState() => _ImagesCardState(
      property: property,
      verticalSpace: verticalSpace,
      columnWidth: columnWidth);
}

class _ImagesCardState extends State with TickerProviderStateMixin {
  Property property;
  double verticalSpace;
  double columnWidth;
  DatabaseService _databaseService = DatabaseService();
  ImageStorageService _imageStorageService = ImageStorageService();

  _ImagesCardState(
      {required this.property,
      required this.verticalSpace,
      required this.columnWidth}) {}

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    controller.repeat();
    super.initState();
  }

  @override
  dispose() {
    controller.dispose(); // you need this
    super.dispose();
  }

  double imageDimension = 100;
  late DropzoneViewController imageDropZoneController;
  String message2 = 'Drop something here';

  Widget imageDropZone(BuildContext context) => Builder(
        builder: (context) => DropzoneView(
          operation: DragOperation.move,
          onCreated: (ctrl) => imageDropZoneController = ctrl,
          //onLoaded: () => print('Zone 2 loaded'),
          //onError: (ev) => print('Zone 2 error: $ev'),
          onDrop: (ev) async {
            setState(() {
              loading = true;
            });
            final stream = imageDropZoneController.getFileStream(ev);
            List<int> imageBytes = [];

            List<List<int>> bytes = await stream.toList();
            for (List<int> byter in bytes) {
              imageBytes.addAll(byter);
            }

            newImages.putIfAbsent(
                ev.name, () => Uint8List.fromList(imageBytes));

            setState(() {
              loading = false;
            });
          },
          /*onDropMultiple: (ev) async {
            print('Zone 2 drop multiple: $ev');
          },*/
        ),
      );

  bool showDropZone = false;
  List<DraggableGridItem> images = [];

  bool loading = false;
  late AnimationController controller;

  void addNewImage(data, path) {
    Widget widg = Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.all(1),
            child: Stack(fit: StackFit.expand, children: [
              Image.memory(
                data,
                fit: BoxFit.cover,
                height: imageDimension,
                width: imageDimension,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text('Error loading image: ${error}'),
                  ); //do something
                },
              ),
              Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                      onPressed: () {
                        newImages.remove(path);
                        setState(() {});
                      },
                      icon: Icon(Icons.close))),
            ])));
    images.add(DraggableGridItem(child: widg, isDraggable: true));
  }

  void addExistingImage(PropertyImage propertyImage) {
    Widget widg = Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.all(1),
            child: Stack(fit: StackFit.expand, children: [
              Image.network(
                propertyImage.url!,
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
              Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                      onPressed: () {
                        imageList.list.remove(propertyImage);
                        for (int i = 0; i < imageList.list.length; i++) {
                          imageList.list[i].order = i;
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.close))),
            ])));
    images.add(DraggableGridItem(child: widg, isDraggable: true));
  }

  @override
  Widget build(BuildContext context) {
    if (property.propertyImages != null) {
      imageList = property.propertyImages!;
    }
    images = [];
    for (int i = 0; i < imageList.list.length; i++) {
      PropertyImage img = imageList.list[i];
      addExistingImage(img);
    }
    ;
    newImages.forEach((path, data) {
      addNewImage(data, path);
    });

    return Card(
        color: Color.fromRGBO(243, 245, 246, 1.0),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: verticalSpace,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('IMAGES',
                        textAlign: TextAlign.left, style: headerStyle)),
                SizedBox(
                  height: verticalSpace,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      width: 1,
                    )),
                    padding: EdgeInsets.all(20),
                    child: Align(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.image);

                                  if (result != null) {
                                    print('IMAGES:PICKER:0');
                                    result.files
                                        .forEach((PlatformFile file) async {
                                      print('IMAGES:PICKER:1');
                                      newImages.putIfAbsent(
                                          file.name, () => file.bytes!);
                                    });

                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    print('IMAGES:PICKER:NOPE');
                                    // User canceled the picker
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                    minimumSize: Size(220, 48),
                                    backgroundColor: Colors.white,
                                    primary: Color.fromRGBO(0, 99, 152, 1.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    )),
                                child: const Text('UPLOAD FROM COMPUTER...',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter')),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("OR",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter')),
                              SizedBox(
                                width: 8.0,
                              ),
                              OutlinedButton(
                                onPressed: () => {
                                  setState(() {
                                    showDropZone = !showDropZone;
                                  })
                                },
                                style: OutlinedButton.styleFrom(
                                    minimumSize: Size(220, 48),
                                    backgroundColor: Colors.white,
                                    primary: Color.fromRGBO(0, 99, 152, 1.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    )),
                                child: const Text('DRAG AND DROP',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter')),
                              ),
                            ]))),
                if (loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (showDropZone)
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.amber,
                        width: 1,
                      )),
                      height: 200,
                      child: Stack(children: [
                        imageDropZone(context),
                        Center(child: Text("Drag and drop an image here")),
                      ])),
                if (images.isNotEmpty)
                  Container(
                    child: DraggableGridViewBuilder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        childAspectRatio: 1,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                      children: images,
                      isOnlyLongPress: true,
                      dragCompletion: (List<DraggableGridItem> list,
                          int beforeIndex, int afterIndex) {
                        PropertyImage before = imageList.list[beforeIndex];
                        imageList.list.removeAt(beforeIndex);
                        imageList.list.insert(afterIndex, before);

                        for (int i = 0; i < imageList.list.length; i++) {
                          imageList.list[i].order = i;
                        }
                      },
                      dragFeedback: (List<DraggableGridItem> list, int index) {
                        return Container(
                          child: list[index].child,
                          width: 200,
                          height: 150,
                        );
                      },
                      dragPlaceHolder:
                          (List<DraggableGridItem> list, int index) {
                        return PlaceHolderWidget(
                          child: Container(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            )));
  }
}

class AmenitiesCard extends StatefulWidget {
  Property property;
  double verticalSpace;
  double columnWidth;
  final Function(List<PropertyEnum>) onChange;
  AmenitiesCard(
      {required this.property,
      required this.onChange,
      required this.verticalSpace,
      required this.columnWidth})
      : super();

  @override
  State createState() => _AmenitiesCardState(
      property: property,
      onChange: onChange,
      verticalSpace: verticalSpace,
      columnWidth: columnWidth);
}

class _AmenitiesCardState extends State {
  final Function(List<PropertyEnum>) onChange;
  Property property;
  double verticalSpace;
  double columnWidth;
  late AmenitiesService _amenitiesService;
  List<PropertyEnum> _allAmenitiesList = [];
  List<PropertyEnum> _propertyAmenitiesList = [];
  List<ListItem> _allItems = [];
  List<ListItem> _selected = [];

  _AmenitiesCardState(
      {required this.property,
      required this.onChange,
      required this.verticalSpace,
      required this.columnWidth}) {
    _amenitiesService = AmenitiesService();
    _propertyAmenitiesList = property.amenities;
  }
  @override
  void initState() {
    _amenitiesService.getAllAmenities().then((allAmenities) {
      setState(() {
        _allAmenitiesList = allAmenities;
        // remove any
        _allAmenitiesList.remove(_allAmenitiesList.first);
        _allItems = _allAmenitiesList.map((amenity) {
          return ListItem(title: amenity.enLabel, value: amenity);
        }).toList();
        _selected = _propertyAmenitiesList.map((propertyAmenity) {
          return ListItem(
              title: propertyAmenity.enLabel, value: propertyAmenity);
        }).toList();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromRGBO(243, 245, 246, 1.0),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: verticalSpace,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('AMENITIES',
                        textAlign: TextAlign.left, style: headerStyle)),
                SizedBox(
                  height: verticalSpace,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: SizedBox(
                              width: columnWidth,
                              height: 220,
                              child: ListView(
                                  shrinkWrap: true,
                                  children: _allItems.map((item) {
                                    return ListTile(
                                      visualDensity: VisualDensity.compact,
                                      dense: true,
                                      selected: item.selected,
                                      title: Text("${item.value.enLabel}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Inter')),
                                      onTap: () {
                                        item.selected = !item.selected;
                                        setState(() {});
                                      },
                                    );
                                  }).toList()))),
                      SizedBox(
                        height: verticalSpace,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                for (ListItem item in _allItems) {
                                  if (item.selected) {
                                    property.amenities.add(item.value);
                                    _selected.add(ListItem(
                                        title: item.title,
                                        value: item.value,
                                        selected: false));
                                    _allItems.remove(item);
                                    onChange(property.amenities);
                                  }
                                }
                                ;
                                setState(() {});
                              },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(220, 48),
                                  backgroundColor: Colors.white,
                                  primary: Color.fromRGBO(0, 99, 152, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              child: const Text('SELECT',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter')),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                for (ListItem item in _selected) {
                                  if (item.selected) {
                                    property.amenities.remove(item.value);
                                    onChange(property.amenities);
                                    _selected.remove(item);
                                    _allItems.add(ListItem(
                                        title: item.title,
                                        value: item.value,
                                        selected: false));
                                  }
                                }
                                ;
                                setState(() {});
                              },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(220, 48),
                                  backgroundColor: Colors.white,
                                  primary: Color.fromRGBO(0, 99, 152, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              child: const Text('UNSELECT',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter')),
                            )
                          ]),
                      SizedBox(
                        height: verticalSpace,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: SizedBox(
                              width: columnWidth,
                              height: 220,
                              child: ListView(
                                  shrinkWrap: true,
                                  children: _selected.map((item) {
                                    return ListTile(
                                      visualDensity: VisualDensity.compact,
                                      dense: true,
                                      selected: item.selected,
                                      title: Text("${item.value.enLabel}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Inter')),
                                      onTap: () {
                                        setState(() {
                                          item.selected = !item.selected;
                                        });
                                      },
                                    );
                                  }).toList()))),
                    ]),
              ],
            )));
  }
}

class ListItem {
  String title;
  PropertyEnum value;
  bool selected = false;

  ListItem({required this.title, required this.value, this.selected = false});
}
