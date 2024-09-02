import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.black87),
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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool showSpinner = false;
  String errorMsg = "";
  @override
  Widget build(BuildContext context) {
    double width =  MediaQuery.of(context).size.width;
    double height =  MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/splash.png',
                  fit: BoxFit.cover, height: double.infinity, width: width * .40),
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
                                height: 32.0,
                              ),
                              Text('Admin Sign In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 32)),
                              SizedBox(
                                height: 32.0,
                              ),
                              TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.left,
                                  onChanged: (value) {
                                    email = value;
                                    //Do something with the user input.
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Email',
                                  )),
                              SizedBox(
                                height: 8.0,
                              ),
                              TextField(
                                  obscureText: true,
                                  textAlign: TextAlign.left,
                                  onChanged: (value) {
                                    password = value;
                                    //Do something with the user input.
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Password')),
                              SizedBox(
                                height: 24.0,
                              ),
                              RoundedButton(
                                  colour: Color.fromRGBO(0, 99, 152, 1.0),
                                  title: 'SIGN IN',
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      final user = await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: email, password: password);
                                      if (user != null) {
                                        Navigator.pushNamed(
                                            context, 'property_list');
                                      } else {
                                        setState(() {
                                          errorMsg = "Login Failed";
                                        });
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      String message = '';
                                      switch (e.code) {
                                        case ('user-not-found'):
                                          {
                                            message = "Invalid user";
                                            break;
                                          }
                                        case ('wrong-password'):
                                          {
                                            message = "Invalid password";
                                            break;
                                          }
                                        default:
                                          {
                                            message =
                                                'Login failed (${e.code})';
                                          }
                                      }
                                      setState(() {
                                        errorMsg = message;
                                      });
                                      print(e);
                                    } catch (e) {
                                      setState(() {
                                        errorMsg = e.toString();
                                      });
                                      print(e);
                                    }

                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }),
                              SizedBox(
                                height: 24.0,
                              ),
                              Text(errorMsg),
                            ],
                          ))))
            ]),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.colour, required this.title, required this.onPressed});
  final Color colour;
  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(5.0),
        child: MaterialButton(
          onPressed: onPressed,
          //Go to login screen.
          minWidth: double.infinity,
          height: 48.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
