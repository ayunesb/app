import 'dart:typed_data';
import 'dart:ui'
    as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paradigm_mex/theme/app_colors.dart';

class ImageHelper {
  static Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
      BuildContext context,
      String assetName,
      int icon_width,
      int icon_height) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        icon_width * devicePixelRatio; // where 32 is your SVG's original width
    double height = icon_height * devicePixelRatio; // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> createCustomMarkerBitmap(String title) async {
    Size size = Size(240, 240);
    TextSpan span = new TextSpan(
        style: new TextStyle(
          height: 1.2,
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
        text: title);

    TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowCirclePaint = Paint()..color = AppColor.primaryColorDark;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              size.width / 8, size.width / 2, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowCirclePaint);

    // TEXT BOX BACKGROUND
    Paint textBgBoxPaint = Paint()..color = AppColor.primaryColor;

    Rect rect = Rect.fromLTWH(
      0,
      0,
      tp.width + 35,
      50,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(20.0)),
      textBgBoxPaint,
    );

    //ADD TEXT WITH ALIGN TO CANVAS
    tp.paint(canvas, new Offset(20.0, 5.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    Picture p = recorder.endRecording();
    ByteData? pngBytes =
        await (await p.toImage(tp.width.toInt() + 40, tp.height.toInt() + 20))
            .toByteData(format: ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes!.buffer);

    return BitmapDescriptor.fromBytes(data);
  }
}
