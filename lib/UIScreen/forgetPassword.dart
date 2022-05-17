import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:supercab_admin/Utils/firebaseCredentials.dart';


class ResetPassword extends StatefulWidget
{

  static const String resetPasswordRoute = 'ResetPasswordScreen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
{

  String _email = '';
  final auth= FirebaseCredentials().auth;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(36.0),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/icons/bg_shade.png',
                  ))),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children:
            [

              SizedBox(height: 40,),

              Text(
                'RESET PASSWORD',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),

              SizedBox(height: 40,),

              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 2)
                    ]),
                child: TextField(
                  onChanged: (value)
                  {
                    setState(()
                    {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      contentPadding: EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 20.0),
                      hintText: "Email",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.transparent),
                      )
                  ),
                ),
              ),

              // Spacer(flex: 1,),

              SizedBox(height: 100,),

              Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  height: 60,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textColor: Colors.black,
                    color: yellow,
                    child: Text(
                      'RESET PASSWORD LINK',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: ()
                    {
                      auth.sendPasswordResetEmail(email: _email).then((value)
                      {
                        Navigator.of(context).pop();
                      });
                    },
                  )),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back,color: yellow,)),
                  Text(
                    'back',
                    style: TextStyle(color: yellow),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
