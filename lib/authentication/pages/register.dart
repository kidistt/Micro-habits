import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:microhabits/authentication/helper/helper.dart';
import 'package:microhabits/authentication/pages/login.dart';
import 'package:microhabits/authentication/services/authservice.dart';
import 'package:microhabits/authentication/widgets/widgets.dart';
import 'package:microhabits/homepage.dart';

import '../services/authservice.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullname = "";
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
                        const SizedBox(height: 20),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "FullName",
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFFee7b64),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                fullname = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "name canot be empty";
                              }
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Email",
                            prefixIcon: const Icon(
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
                        const SizedBox(height: 15),
                        TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "password",
                                prefixIcon: const Icon(
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
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                Register();
                              },
                              child: const Text("Sign Up")),
                        ),
                        SizedBox(height: 10),
                        Text.rich(TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Sign In",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const LoginPage());
                                    }),
                            ])),
                      ],
                    )),
              ),
            ),
    );
  }

  Register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUser(fullname, email, password)
          .then((value) async {
        if (value == true) {
          await Helperfunctions.saveUserLoggedInStatus(true);
          await Helperfunctions.saveUserEmailSF(email);
          await Helperfunctions.saveUserNameSF(fullname);
          nextScreenReplace(context, const HomePage());
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
