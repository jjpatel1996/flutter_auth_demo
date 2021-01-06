import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'home.dart';

final FirebaseAuth _fauth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCntrl = TextEditingController();
  final TextEditingController _passwordCntrl = TextEditingController();
  bool _registerSuccess;
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 110, bottom: 60),
                          child: Text(
                            'Flutter Authentication',
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _emailCntrl,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              labelText: "Email",
                              errorText: '',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) return '';
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _passwordCntrl,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(height: 0),
                              labelText: "Password",
                              errorText: '',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (String value) {
                              if (value.isEmpty) return '';
                              return null;
                            },
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 45.0,
                          width: 240.0,
                          child: Material(
                            shape: StadiumBorder(),
                            textStyle: Theme.of(context).textTheme.button,
                            elevation: 2.0,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Login",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _signInWithEmailAndPassword(context);
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(50))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Register",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _register();

                                        Navigator.pushReplacementNamed(
                                            context, "/home");
                                      }
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          _registerSuccess == null
                                              ? ''
                                              : (_registerSuccess
                                                  ? 'Successfully registered ' +
                                                      _userEmail
                                                  : 'Registration failed'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '---- OR ----',
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: SignInButton(
                            Buttons.Google,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () => _signInWithGoogle(context),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 3),
                        ),
                      ],
                    ),
                  )),
            );
          }),
        ));
  }

  @override
  void dispose() {
    _emailCntrl.dispose();
    _passwordCntrl.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final User user = (await _fauth.signInWithEmailAndPassword(
        email: _emailCntrl.text,
        password: _passwordCntrl.text,
      ))
          .user;

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "${user.email} signed in",
          textAlign: TextAlign.center,
        ),
      ));

      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to sign in with Email & Password",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _fauth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential =
            await _fauth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Sign In ${user.displayName} with Google",
          textAlign: TextAlign.center,
        ),
      ));

      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {
      print(e);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to sign in with Google: $e",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void _register() async {
    final User user = (await _fauth.createUserWithEmailAndPassword(
      email: _emailCntrl.text,
      password: _passwordCntrl.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _registerSuccess = true;
        _userEmail = user.email;
      });

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          "${user.email} successfully register",
          textAlign: TextAlign.center,
        ),
      ));

       Navigator.pushReplacementNamed(context, "/home");

    } else {
      _registerSuccess = false;
    }
  }
}
