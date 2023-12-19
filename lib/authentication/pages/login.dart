import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:microhabits/authentication/helper/helper.dart';
import 'package:microhabits/authentication/pages/register.dart';
import 'package:microhabits/authentication/services/authservice.dart';

import 'package:microhabits/authentication/widgets/widgets.dart';
import 'package:microhabits/bottomnav.dart';
import 'package:microhabits/frontpage.dart';
import 'package:microhabits/homepage.dart';

import '../services/databseservice.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 150),
                          Image.asset("images/hustle.jfif"),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFFee7b64),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xFFee7b64),
                                  )),
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "password must be at least 6 characters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              }),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFee7b64),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  Login();
                                },
                                child: const Text("Sign In")),
                          ),
                          SizedBox(height: 10),
                          Text.rich(TextSpan(
                              text: "Don't have an account?",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage());
                                      }),
                              ])),
                        ],
                      )),
                ),
              ));
  }

  Login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginUser(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          // saving the values to our shared preferences
          await Helperfunctions.saveUserLoggedInStatus(true);
          await Helperfunctions.saveUserEmailSF(email);
          await Helperfunctions.saveUserNameSF(snapshot.docs[0]['fullname']);
          nextScreenReplace(context, const WelcomeScreen());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
