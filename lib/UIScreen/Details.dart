import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:http/http.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';




class Details extends StatefulWidget {

  String bookingType;
  String bookingId;
  String userId;

  Details({@required this.bookingType,@required this.bookingId,@required this.userId});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  final nameController = TextEditingController();
  final commentController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final arrivalTimeController = TextEditingController();

  String userEmail;

  final formKey = GlobalKey<FormState>();

  bool validateForm()
  {
    final key = formKey.currentState;
    if(key.validate())
      {
        return true;
      }
    return false;
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     GoogleSignInAccount user = await _googleSignIn.signIn();
  //     GoogleSignInAuthentication googleSignInAuthentication = await user.authentication;
  //     print(googleSignInAuthentication.accessToken);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  GoogleSignIn googleSignIn = GoogleSignIn();

  sendEmail() async
  {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print('**********' + googleUser.email.toString() + '*************');

    String username = 'nadeemszd867897@gmail.com';
    String password = 'admin password';

    final smtpServer = gmailRelaySaslXoauth2(googleUser.email, googleAuth.accessToken);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Nadeem')
      ..recipients.add('m.nadeem.szd@gmail.com') // ahsanrazapk92@gmail.com
     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
     // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Mail from SuperCab :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Alert</h1>\n<p>Hi! your booking get response</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.' + e.toString());
      // for (var p in e.problems) {
      //   print('Problem: ${p.code}: ${p.msg}');
      // }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: 750,
          width: MediaQuery.of(context).size.width,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: white)),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                size: 12,
                                color: white,
                              ),
                            ),
                          ),
                          Text(
                            "Booking Details",
                            style: TextStyle(color: white, fontSize: 17),
                          ),
                          Visibility(
                            visible: false,
                            child: Icon(Icons.ac_unit_rounded),
                          )
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> querySnapshot)
                        {
                          if(querySnapshot.hasError)
                          {
                            return Center(child: Text('Some Error'));
                          }
                          if(querySnapshot.connectionState == ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else
                          {

                            final data = querySnapshot.data;

                            var from = data['from'];
                            var to = data['to'];
                            var time = data['time'];
                            var cost = data['tripCost'];
                            var date = data['day'];
                            var vehicle = data['vehicle'];
                            var transferType = data['transferType'];
                            var email = data['email'];
                            var phone = data['phone'];
                            var comments = data['comments'];
                            var name = data['name'];

                            userEmail = email;

                            return Container(
                              //height: 465,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                  [

                                    Row(
                                      children:
                                      [
                                        Text('Booking Type : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(transferType, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Text('Name :  $name',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Text('Email :  $email',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('Phone Number : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(phone, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                    Text('From :  $from',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Text('To :  $to',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),

                                    Row(
                                      children:
                                      [
                                        Text('Total Cost : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(cost.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children:
                                      [
                                        Text('Date : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(date, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      children:
                                      [
                                        Text('Time : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(time, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),
                                    Row(
                                      children:
                                      [
                                        Text('Vehicle : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                        SizedBox(width: 5,),
                                        Text(vehicle, style: TextStyle(fontSize: 17, color: Colors.white),),
                                      ],
                                    ),

                                    SizedBox(height: 10,),
                                    Text('Comments : $comments',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(width: 5,),

                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                      [
                        RaisedButton(
                          color: yellow,
                          child: Text('Accept',style: TextStyle(fontWeight: FontWeight.bold),),
                          onPressed: ()
                            {
                              showGeneralDialog(
                                barrierLabel: "Label",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 500),
                                context: context,
                                pageBuilder: (context, anim1, anim2) {
                                  return SafeArea(
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Material(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 400,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: yellow,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Form(
                                              key: formKey,
                                              child: ListView(
                                                primary: true,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Booking Response",
                                                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextFormField(
                                                      controller: nameController,
                                                      autofocus: true,
                                                      decoration: InputDecoration(hintText: "Name"),
                                                      validator: (value)
                                                      {
                                                        return value.isEmpty ? 'required' : null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextFormField(
                                                      controller: phoneNumberController,
                                                      decoration: InputDecoration(
                                                        hintText: "Contact No",
                                                      ),
                                                      validator: (value)
                                                      {
                                                        return value.isEmpty ? 'required' : null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextFormField(
                                                      controller: vehicleNumberController,
                                                      decoration: InputDecoration(
                                                        hintText: "Vehicle Number",
                                                      ),
                                                      validator: (value)
                                                      {
                                                        return value.isEmpty ? 'required' : null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextFormField(
                                                      controller: arrivalTimeController,
                                                      decoration: InputDecoration(
                                                        hintText: "Arrival Time",
                                                      ),
                                                      validator: (value)
                                                      {
                                                        return value.isEmpty ? 'required' : null;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child: TextFormField(
                                                      controller: commentController,
                                                      decoration: InputDecoration(
                                                        hintText: "Message",
                                                      ),
                                                      validator: (value)
                                                      {
                                                        return value.isEmpty ? 'required' : null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      ButtonTheme(
                                                        minWidth: 100,
                                                        height: 45,
                                                        child: RaisedButton(
                                                          onPressed: ()
                                                          {
                                                            if(validateForm())
                                                            {
                                                              String driverName = nameController.text;
                                                              String driverContact = phoneNumberController.text;
                                                              String comment = commentController.text;
                                                              String vehicleNumber = vehicleNumberController.text;
                                                              String arrivalTime = arrivalTimeController.text;

                                                              //print('User Token Id : '+widget.userId);
                                                              String message = 'Your Ride Accepted...';
                                                              String status = 'Accepted';

                                                              FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).update({'bookingStatus' : status});

                                                              FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                                                callOnFcmApiSendPushNotifications(driverName,vehicleNumber,driverContact,arrivalTime,comment,status,message,value.data()['token']);
                                                              }).then((value)
                                                              {
                                                                //sendEmail(userEmail);
                                                                Navigator.of(context).pop();
                                                              });
                                                            }
                                                          },
                                                          child: Text(
                                                            "Send",
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          color: Colors.black,
                                                          elevation: 12.0,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: new BorderRadius.circular(25.0),
                                                          ),
                                                        ),
                                                      ),
                                                      ButtonTheme(
                                                        minWidth: 100,
                                                        height: 45,
                                                        child: RaisedButton(
                                                          onPressed: ()
                                                          {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          color: Colors.black,
                                                          elevation: 12.0,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: new BorderRadius.circular(25.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder: (context, anim1, anim2, child) {
                                  return SlideTransition(
                                    position:
                                    Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                                    child: child,
                                  );
                                },
                              );

                            }
                          ),

                        RaisedButton(
                          color: yellow,
                          child: Text('Decline',style: TextStyle(fontWeight: FontWeight.bold),),
                          onPressed: ()
                          {

                            //sendEmail();
                            String message = 'Your Ride Canceled!';
                            String status = 'Declined';

                            FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).update({'bookingStatus' : status});

                            FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                              callOnFcmApiSendPushNotifications('','','','','',status,message,value.data()['token']);
                            });
                          }
                        ),

                      ],
                    ),

                    SizedBox(
                      height: 40,
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
    );

  }

  callOnFcmApiSendPushNotifications(name,vehicleNumber,contact,arrivalTime,comment,status,message,token) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "Response : $message",
        "title": "SuperCab"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "id" : widget.bookingId,
        "type" : widget.bookingType,
        "uid" : widget.userId,
        "bookingStatus" : status,
        "driverName" : name,
        "driverContact" : contact,
        "drivervehicleNumber" : vehicleNumber,
        "arrivalTime" : arrivalTime,
        "comment" : comment
      },
      "to": token,
    };

    //print('token Value :  ' + token.toString());

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAsJCTwtE:APA91bGjxrSX65kLJfnUzGh1kqJNX6yY4m0obVxFUpicSyNI5Q04Xt1d2pTLwVSsTXXqNzEuQNsBOIvk634RFI4M9_f4XQlEAa7PXchZ5xDiM74MHI3mu0SW1PraYi8YrijOzR2tenIs'
      // 'key=YOUR_SERVER_KEY'
    };

    try {
      final response = await post(postUrl,
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print('CFM Succeed');
        Navigator.of(context).pop();
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

}




