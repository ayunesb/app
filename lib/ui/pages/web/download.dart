import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/splash.png',
                  fit: BoxFit.cover, height: 250, width: double.infinity),
              Flexible(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          alignment: Alignment.center,
                          width: 380,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset('assets/svg/logo_shield.svg'),
                              SizedBox(
                                height: 24.0,
                              ),
                              InkWell(
                                  onTap: () => {
                                        launch(
                                            'https://firebasestorage.googleapis.com/v0/b/paradigm-mx.appspot.com/o/deploy%2Fapp-release.apk?alt=media&token=c423ef79-ff41-4fb7-9914-c9e373b9e11a')
                                      },
                                  child: Image.asset(
                                      'assets/images/google-play.png'))
                            ],
                          ))))
            ]),
      ),
    );
  }
}
