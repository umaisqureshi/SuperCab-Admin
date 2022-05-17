import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/UIScreen/AdminScreen.dart';
import 'package:supercab_admin/UIScreen/forgetPassword.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:supercab_admin/Utils/firebaseCredentials.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isPassVisible = false;
  bool status = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: new DecorationImage(
          fit: BoxFit.cover,
          image: new AssetImage("assets/icons/background.png"),
        )),
        child: Container(
          decoration: BoxDecoration(
              image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage("assets/icons/bg_shade.png"),
          )),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  SizedBox(
                    height: 90,
                  ),
                  Image.asset(
                    'assets/icons/mainLogo.png',
                    height: 200,
                    //width: 200,
                  ),
                  Spacer(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: emailController,
                            validator: (input) {
                              if (input.isEmpty)
                                return 'Required Field';
                              else
                                return null;
                            },
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: white),
                              filled: true,
                              fillColor: white.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: white, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, right: 10, left: 10),
                          child: TextFormField(
                            obscureText: isPassVisible ? false : true,
                            validator: (input) {
                              if (input.isEmpty)
                                return 'Required Field';
                              else
                                return null;
                            },
                            controller: passController,
                            style: TextStyle(color: white),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: isPassVisible
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPassVisible = !isPassVisible;
                                        });
                                      },
                                      child: Icon(Icons.visibility_off,
                                          color: white))
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPassVisible = !isPassVisible;
                                        });
                                      },
                                      child:
                                          Icon(Icons.visibility, color: white)),
                              hintStyle: TextStyle(color: white),
                              filled: true,
                              fillColor: white.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: status
                        ? CircularProgressIndicator() //ProgressIndicatorWidget()
                        : Container(
                            height: 50,
                            width: double.infinity,
                            child: RaisedButton(
                              color: yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                loginUser();
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ResetPassword()));
                        },
                        child: Text(
                          'I forgot my Password',
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //         onTap: () =>
                  //             SocialAuthentication.signUpFacebook(context),
                  //         child: SvgPicture.asset(
                  //           "assets/icons/loginFB.svg",
                  //           height: 65,
                  //         )),
                  //     SizedBox(
                  //       width: 20,
                  //     ),
                  //     GestureDetector(
                  //         onTap: () =>
                  //             SocialAuthentication.signUpGoogle(context),
                  //         child: Image.asset(
                  //           'assets/icons/google.png',
                  //           height: 60,
                  //         ))
                  //   ],
                  // ),
                  Flexible(
                    child: Container(),
                  ),
                  // Center(
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: RichText(
                  //       text: TextSpan(
                  //         text: " Don't have an account",
                  //         style: TextStyle(color: white),
                  //         children: <TextSpan>[
                  //           TextSpan(
                  //             text: ' SIGN UP ',
                  //             style: TextStyle(color: yellow),
                  //             recognizer: TapGestureRecognizer()
                  //               ..onTap = () =>
                  //                   Navigator.pushNamed(context, '/signUp'),
                  //           ),
                  //           TextSpan(
                  //               text: 'here?',
                  //               style: TextStyle(color: white, fontSize: 15))
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          status = true;
        });
        print(emailController.text);
        print(passController.text);
        await FirebaseCredentials()
            .auth
            .signInWithEmailAndPassword(
                email: emailController.text.trim(), password: passController.text.trim())
            .then((value) async {
            String uid = value.user.uid;
            bool userExists = (await FirebaseFirestore.instance.collection('user').doc(uid).get()).exists;
            if(userExists){
              FirebaseAuth.instance.signOut();
              setState(() {
                status = false;
              });
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  'You are not admin.',
                  style: TextStyle(color: white),
                ),
              ));
            }else{
              Navigator.pushReplacementNamed(context, '/home');
            }



          // print('Current User : ' + value.user.displayName);

          // user.userEmail = value.user.email;
          // user.userName = value.user.displayName;
          // user.currentUserId = value.user.uid;

          // print('User UID : '+user.currentUserId);


          print(3);
        }).catchError((error) {
          setState(() {
            status = false;
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Email or password is incorrect',
              style: TextStyle(color: white),
            ),
          ));
        });
      } on SocketException catch (_) {
        setState(() {
          status = false;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Check your Internet Connection',
            style: TextStyle(color: white),
          ),
        ));
      }
    }
  }
}
