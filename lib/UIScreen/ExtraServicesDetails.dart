import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/DataSource/Source.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart';


class ServicesDetails extends StatefulWidget {

  String bookingType;
  String bookingId;
  String userId;

  ServicesDetails({@required this.bookingType,@required this.bookingId,@required this.userId});

  @override
  _ServicesDetailsState createState() => _ServicesDetailsState();
}

class _ServicesDetailsState extends State<ServicesDetails> {


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: double.infinity,
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
                            "Services Details",
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

                            var email = data['email'];
                            var name = data['name'];
                            var phone = data['phone'];
                            var date = data['day'];
                            var time = data['time'];
                            var comment = data['information'];
                            var isLimo = data['Limo'];
                            var isBus = data['Bus'];
                            var isWedding = data['Wedding'];
                            var isTour = data['Tours'];
                            var request = data['requestStatus'];


                            return Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.white, width: 1)),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [

                                  Row(
                                    children:
                                    [
                                      Text('Name : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Text(name, style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text('Phone Number :  $phone',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Email :  $email',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Stretch Limo :  ${isLimo ? 'Yes' : 'No'}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Bus :  ${isBus ? 'Yes' : 'No'}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Wedding :  ${isWedding ? 'Yes' : 'No'}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Tour :  ${isTour ? 'Yes' : 'No'}',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
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
                                  Text('Information :  $comment',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                  Text('Request Status :  $request',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),
                                  SizedBox(height: 10,),
                                ],
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

                              String message = 'Your Request Accepted!';
                              String status = 'Accepted';

                              FirebaseFirestore.instance.collection('ExtraServices').doc(widget.bookingId).update({'requestStatus' : status});

                              FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                callOnFcmApiSendPushNotifications(status,message,value.data()['token']);
                              });

                            }
                        ),

                        RaisedButton(
                            color: yellow,
                            child: Text('Decline',style: TextStyle(fontWeight: FontWeight.bold),),
                            onPressed: ()
                            {
                              String message = 'Your Request Canceled!';
                              String status = 'Declined';

                              FirebaseFirestore.instance.collection('ExtraServices').doc(widget.bookingId).update({'requestStatus' : status});

                              FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                callOnFcmApiSendPushNotifications(status,message,value.data()['token']);
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

  callOnFcmApiSendPushNotifications(status,message,token) async {
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
      },
      "to": token,
    };

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

