import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../blocs/ads/ad_bloc.dart';
import '../../../models/ad.dart';
import '../../../service/database_service.dart';
import '../../../service/image_storage_service.dart';
import '../../widgets/property/property_list.dart';

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

class AdminAdEditForm extends StatefulWidget {
  final String adId;
  final bool add;

  AdminAdEditForm({Key? key, required this.adId, this.add = false})
      : super(key: key) {}

  @override
  State createState() => _AdminAdEditFormState(adId, add);
}

class _AdminAdEditFormState extends State {
  final String adId;
  bool add = false;

  _AdminAdEditFormState(this.adId, this.add) {}

  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Ad ad;
    double padding = 24.0;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) {
              if (this.add) {
                return AdBloc()..add(AdNewEvent());
              } else {
                return AdBloc()..add(AdLoadingEvent(adId: adId, add: this.add));
              }
            },
          ),
        ],
        child: Dialog(
            insetPadding: EdgeInsets.all(16),
            child: Stack(children: [
              Scaffold(
                  backgroundColor: Colors.white,
                  body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Center(child: SingleChildScrollView(child:
                          BlocBuilder<AdBloc, AdState>(
                              builder: (context, state) {
                        if (state is AdLoadSuccessState) {
                          ad = state.ad!;
                          return getAdForm(ad, context);
                        } else if (state is AdNewState) {
                          this.add = true;

                          ad = state.ad!;
                          return getAdForm(ad, context);
                        } else if (state is AdLoadFailureState) {
                          return Text('Error loading ad: ${state.err}');
                        } else {
                          return Center(
                            child: LoadingIndicator(
                              key: UniqueKey(),
                            ),
                          );
                        }
                      }))))),
              if (loading)
                const Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.black),
                ),
              if (loading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ])));
  }


  getAdForm(Ad ad, BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width - 32;
    double horizontalSpace = 18;
    double verticalSpace = 24.0;
    double padding = 24.0;
    double columnWidth =
        (fullWidth - (2 * horizontalSpace) - (2.0 * padding) - (2.0 * 18)) / 3;
    return Column(
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
                              ? 'Add New Ad'
                              : 'Edit Ad',
                          textAlign: TextAlign.left,
                          style: header700),
                    ),
                    Form(
                        key: _formKey,
                        onChanged: () => {},
                        child: Column(
                          children: [
                            listingInfoCard(
                                horizontalSpace,
                                columnWidth,
                                verticalSpace,
                                ad),
                            SizedBox(
                              height: verticalSpace,
                            ),
                            ImagesCard(
                                ad: ad,
                                verticalSpace:
                                verticalSpace,
                                columnWidth: 100),
                            SizedBox(
                              height: verticalSpace,
                            ),
                            Row(children: [
                              OutlinedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (this.add) {
                                    print(
                                        '~~~~~~~~~~~~~~~~~~ 1:SAVE AND CLOSE');
                                    BlocProvider.of<
                                        AdBloc>(
                                        context)
                                        .add(AdAddEvent(
                                        ad: ad, createNew: false, createDuplicate: false));
                                  } else {
                                    BlocProvider.of<
                                        AdBloc>(
                                        context)
                                        .add(
                                        AdUpdateEvent(
                                            ad: ad));
                                  }
                                  setState(() {
                                    loading = false;
                                  });

                                  Navigator.pop(context);
                                },
                                style: OutlinedButton
                                    .styleFrom(
                                    minimumSize:
                                    Size(220, 48),
                                    backgroundColor:
                                    Color
                                        .fromRGBO(
                                        0,
                                        99,
                                        152,
                                        1.0),
                                    foregroundColor:
                                    Colors.white,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .all(Radius
                                          .circular(
                                          5)),
                                    )),
                                child: const Text(
                                    'SAVE & CLOSE',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily:
                                        'Inter')),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                style: buttonStyle,
                                child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily:
                                        'Inter')),
                              ),
                            ])
                          ],
                        ))
                  ]))),
        ]);
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

  List<DropdownMenuItem<AdType>> _typeList = [
    DropdownMenuItem(child: Text('Main Page'), value: AdType.main),
    DropdownMenuItem(child: Text('Property Page'), value: AdType.property)
  ];

  List<DropdownMenuItem<AdSize>> _sizeList = [
    DropdownMenuItem(child: Text('250 x 250'), value: AdSize.large),
    DropdownMenuItem(child: Text('100 x 300'), value: AdSize.medium),
    DropdownMenuItem(child: Text('50 x 300'), value: AdSize.small)
  ];

  Widget listingInfoCard(spaceBetween, columnWidth, verticalSpace, Ad ad) {
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
                        child: Text('AD INFO',
                            textAlign: TextAlign.left, style: headerStyle)),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue: ad.name,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Ad Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter ad name';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                ad.name = value.toString();
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: TextFormField(
                            initialValue: ad.to,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Ad Link",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter link url';
                              }
                              return null;
                            },
                            onChanged: (Object? value) {
                              setState(() {
                                ad.to = value.toString();
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: Row(children: [
                            Checkbox(
                              checkColor: Colors.white,
                              value: ad.active,
                              onChanged: (bool? value) {
                                setState(() {
                                  ad.active = value!;
                                });
                              },
                            ),
                            Text('Active')
                          ])),
                    ]),
                    SizedBox(
                      height: verticalSpace,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          width: columnWidth,
                          child: DropdownButtonFormField(
                            value: ad.type,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Type",
                            ),
                            items: _typeList,
                            onChanged: (Object? value) {
                              setState(() {
                                ad.type = value as AdType;
                              });
                            },
                          )),
                      SizedBox(
                        width: spaceBetween,
                      ),
                      SizedBox(
                          width: columnWidth,
                          child: DropdownButtonFormField(
                            value: ad.size,
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: "Size",
                            ),
                            items: _sizeList,
                            onChanged: (Object? value) {
                              setState(() {
                                ad.size = value as AdSize;
                              });
                            },
                          )),
                    ]),
                  ],
                )));
  }
}

class ImagesCard extends StatefulWidget {
  Ad ad;
  double verticalSpace;
  double columnWidth;

  ImagesCard(
      {required this.ad,
      required this.verticalSpace,
      required this.columnWidth})
      : super();

  @override
  State createState() => _ImagesCardState(
      ad: ad, verticalSpace: verticalSpace, columnWidth: columnWidth);
}

class _ImagesCardState extends State with TickerProviderStateMixin {
  Ad ad;
  double verticalSpace;
  double columnWidth;
  DatabaseService _databaseService = DatabaseService();
  ImageStorageService _imageStorageService = ImageStorageService();

  _ImagesCardState(
      {required this.ad,
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

  double imageDimension = 180;
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

            _imageStorageService
                .uploadAdImageData(
                    ad.id, Uint8List.fromList(imageBytes), ev.name)
                .then((url) {
              ad.url = url;
            },
                    onError: (e) =>
                        print('Error adding image to DB:' + e.toString()));

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

  void addImageToUI(Ad ad) {
    Widget widg = Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.all(1),
            child: Stack(fit: StackFit.expand, children: [
              Image.network(
                ad.url,
                fit: BoxFit.fitHeight,
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
                        ad.url = '';
                        setState(() {});
                      },
                      icon: Icon(Icons.close))),
            ])));
    images.add(DraggableGridItem(child: widg, isDraggable: true));
  }

  @override
  Widget build(BuildContext context) {
    images = [];
    if(ad.url.isNotEmptyAndNotNull) addImageToUI(ad);

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
                    child: Text('IMAGE',
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
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    PlatformFile file = result.files.first;

                                    String url = await _imageStorageService
                                        .uploadAdImageData(
                                            ad.id,
                                            Uint8List.fromList(file.bytes!),
                                            file.name);
                                    if (url != null) {
                                      ad.url = url;
                                      addImageToUI(ad);
                                    }
                                    ;

                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
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
                        // on drag
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
