import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminHeader extends StatefulWidget {
  const AdminHeader({Key? key}) : super(key: key);

  @override
  State createState() => _AdminHeaderState();
}

class _AdminHeaderState extends State {
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
                color: Color.fromRGBO(22, 28, 34, 1),
                height: 64,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 14, 30, 14),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/logo_shield.svg',
                                color: Colors.white,
                                height: 38,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "HUNT",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              )
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  try {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushNamed(
                                        context, 'login_screen');
                                  } catch (e) {
                                    print(e);
                                  }
                                  setState(() {
                                    isLoggedIn = false;
                                  });
                                },
                              ),
                              new InkResponse(
                                  onTap: () async {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushNamed(
                                          context, 'login_screen');
                                    } catch (e) {
                                      print(e);
                                    }
                                    setState(() {
                                      isLoggedIn = false;
                                    });
                                  },
                                    child: Text("SIGN OUT",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                        )),
                                  ),
                            ])
                      ]),
                ));
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
