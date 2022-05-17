import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shortid/shortid.dart';
import 'package:supercab_admin/Utils/firebaseCredentials.dart';
import 'package:supercab_admin/Utils/model/PromoCodeModel.dart';
import 'package:supercab_admin/utils/constants.dart';
import 'package:http/http.dart';


class DialogModel extends StatefulWidget {
  @override
  _DialogModelState createState() => _DialogModelState();
}
class _DialogModelState extends State<DialogModel> {

  PromoCodeModel model;

  int expiryDate;
  String today = 'Today';

  final commentController = TextEditingController();
  final discountController = TextEditingController();
  final totalRidesController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String promoCode;

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now();
    var dateFormat = new DateFormat('MMM d,yyyy');

    expiryDate = dateAndTime.millisecondsSinceEpoch;

    today = expiryDate.toString();
  }

  bool verifyForm()
  {
    final form = formKey.currentState;
    if(form.validate())
      {
        return true;
      }
    return false;
  }

  @override
  void initState() {
    super.initState();

    promoCode = shortid.generate();

    print('***************');
    print('Short ID : ' + promoCode.toString());
    print('***************');

    getCurrentDateAndTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
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
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            //color: yellow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Promo Code",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Promo Code : ${promoCode.toString()}',style: TextStyle(color: yellow),),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(left: 10,right: 10, top: 20,bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '% Discount',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 150,

                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: discountController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                hintText: 'discount',
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              validator: (value)
                              {
                                return value.isEmpty ? 'Required' : null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiry Date',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                builder:
                                    (BuildContext context, Widget child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors.black,
                                        onPrimary: yellow,
                                        surface: yellow,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child,
                                  );
                                },
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2125),
                              ).then((date) {
                                String selectedDate = DateFormat('MMM dd,yyyy').format(date);
                                setState(() {
                                  expiryDate = date.millisecondsSinceEpoch;
                                });
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width/2.5,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white, width: 1)
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      DateFormat('MMM dd,yyyy').format(DateTime.fromMillisecondsSinceEpoch(expiryDate))
                                          ?? 'Not Selected',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Rides',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: totalRidesController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          hintText: 'rides',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value)
                        {
                          return value.isEmpty ? 'Required' : null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: commentController,
                    maxLines: 5,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: 'Additional Comments',
                      hintStyle: TextStyle(color: white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
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
                          if(verifyForm())
                          {

                            model = PromoCodeModel(
                                promoCode: promoCode,
                                discount: int.parse(discountController.text),
                                expiryDate: expiryDate,
                                totalRides: int.parse(totalRidesController.text),
                                comment: commentController.text.trim()
                            );

                            FirebaseCredentials().firestore.collection('PromoCodes').doc(model.promoCode).set(
                                {
                                  'promoCode' : model.promoCode,
                                  'discount' : model.discount,
                                  'expiryDate' : model.expiryDate,
                                  'totalRides' : model.totalRides,
                                  'comment' : model.comment
                                }).then((value)
                            {
                              callOnFcmApiSendPushNotifications(model.promoCode);
                              Navigator.of(context).pop(null);
                            });

                          }
                        },
                        child: Text(
                          "Send",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
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
                          Navigator.of(context).pop(null);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        color: yellow,
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
    );
  }

  callOnFcmApiSendPushNotifications(id) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  final data = {
    "notification": {
      "body": "New Discount From SuperCab",
      "title": "New Booking"
    },
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "status": "done",
      "id": id,
      "type" : 'promoCode'
    },
    "to": "\/topics\/superCabUser",
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
    'key=AAAAongebhA:APA91bH23Z8cjcfpQM4w7Aez1q6Dy5h3R2dr_V-jlj8NK7wU0VRT1X57wvpkO5bgP0KM2kTYOMwrk4b9pnVpWBv65jG72Z1K9uYpikoe7mb5KTdx_MsfA2DmsSWmxFAFuAhkWV6RvXCH'
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


class PromoCodeDataModal extends ModalRoute<PromoCodeModel> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor {
    return Colors.white.withOpacity(0);
  }

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        minimum: EdgeInsets.only(top: 40),
        child: Scaffold(
          //resizeToAvoidBottomPadding: true,
          body: DialogModel(
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    Animation<Offset> offsetAnimation = animation.drive(tween);
    // You can add your own animations for the overlay content
    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
