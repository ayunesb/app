import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradigm_mex/controllers/SlideUpController.dart';
import 'package:paradigm_mex/providers/SlideUp_provider.dart';
import 'package:provider/provider.dart';

import '../../blocs/widgets/marker_bloc.dart';
import '../../models/property.dart';
import 'PropertyDetailsCard.dart';

class SlideUpWidget extends StatefulWidget {
  final SlideUpController controller;
  final List<Property> properties;

  SlideUpWidget({Key? key, required this.controller, required this.properties})
      : super(key: key);

  @override
  _SlideUpWidgetState createState() => _SlideUpWidgetState();
}

class _SlideUpWidgetState extends State<SlideUpWidget> {
  int _index = 0;
  PageController _pageController = PageController(viewportFraction: 0.98);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SlideUpProvider(),
      child: Consumer<SlideUpProvider>(
        builder: (context, provider, child) {
          widget.controller.providerContext = context;
          LatLng? position;
          return BlocListener<MarkerBloc, MarkerState>(
                  listener: (context, state) {
                    if (state is MarkerSelectedSuccess) {
                      position = state.property_location;
                      _pageController.jumpToPage(state.marker_position);
                    }
                  },
                  child: SizedBox(
                    height: 110,
                    width: 750, // card height
                    child: PageView.builder(
                      itemCount: widget.properties.length,
                      controller: _pageController,
                      onPageChanged: (int index) {
                        BlocProvider.of<MarkerBloc>(context).add(
                            PropertyCardSelectedEvent(LatLng(
                                position?.latitude ??
                                    0,
                                position?.longitude ??
                                    0)));
                        setState(() => _index = index);
                      },
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: PropertyDetailsCard(property: widget.properties[_index]),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
