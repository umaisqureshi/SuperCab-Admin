import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/DataSource/Source.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:supercab_admin/DataSource/hourlyInvoice.dart';


class HourlyDetails extends StatefulWidget {

  String bookingType;
  String bookingId;
  String userId;

  HourlyDetails({@required this.bookingType,@required this.bookingId,@required this.userId});

  @override
  _HourlyDetailsState createState() => _HourlyDetailsState();
}

class _HourlyDetailsState extends State<HourlyDetails> {


  final nameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final commentController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final arrivalTimeController = TextEditingController();
  bool isInvoiceRequired = false;

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
                            "Details",
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
                            final data = querySnapshot.data.data();

                            var cityIndex = data['city'];
                            var hours = data['hours'];
                            var time = data['time'];
                            var cost = data['tripcost'];
                            var date = data['day'];
                            var vehicle = data['vehicle'];
                            var transferType = data['transferType'];
                            var email = data['email'];
                            var phone = data['phone'];
                            var name = data['name'];
                            var bookingStatus = data['bookingStatus'];
                            var invoicesStatus = data['invoiceStatus'];
                            var invoiceNumber = data['invoiceNumber'];

                            bool isBusinessCheckPresent = data['isBusinessCheck'];
                            var businessName ='',businessContact='',billingAddress='',state='',country='',businessPhone='',businessEmail = '';
                            if(isBusinessCheckPresent == false)
                            {
                              businessName = data['businessName'];
                              businessContact = data['businessContactName'];
                              billingAddress = data['billingAddress'];
                              state = data['state'];
                              country = data['country'];
                              businessPhone = data['businessPhone'];
                              businessEmail = data['businessEmail'];
                            }

                            String city = cityNamesList(context)[cityIndex].name;

                            if(bookingStatus == 'Accepted')
                            {
                              if(invoicesStatus == "Not Send")
                              {
                                isInvoiceRequired = true;
                              }
                            }

                            return Container(
                              child: Column(
                                children:
                                [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
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
                                              Text(phone.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                            ],
                                          ),

                                          SizedBox(height: 10,),

                                          Text('City :  $city',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                          SizedBox(height: 10,),

                                          Text('Hours :  $hours',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                          SizedBox(height: 10,),

                                          Row(
                                            children:
                                            [
                                              Text('Total Cost : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                              SizedBox(width: 5,),
                                              Text('\$ '+cost.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
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

                                          Row(
                                            children:
                                            [
                                              Text('Booking Status : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                              SizedBox(width: 5,),
                                              Text(bookingStatus, style: TextStyle(fontSize: 17, color: white),),
                                            ],
                                          ),

                                          SizedBox(width: 10,),

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  bookingStatus == 'Pending'
                                      ? Row(
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
                                                                      hintText: "vehicleNumber",
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
                                                                            String drivervehicleNumber = vehicleNumberController.text;
                                                                            String comment = commentController.text;
                                                                            String driverContact = phoneNumberController.text;
                                                                            String arrivalTime = arrivalTimeController.text;

                                                                            //print('User Token Id : '+widget.userId);
                                                                            String message = 'Your Ride Accepted...';
                                                                            String status = 'Accepted';

                                                                            FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).update({'bookingStatus' : status});

                                                                            FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                                                              callOnFcmApiSendPushNotifications(driverName,driverContact,arrivalTime,drivervehicleNumber,comment,status,message,value.data()['token']);
                                                                            }).then((value)
                                                                            {
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

                                            //print('User Token Id : '+widget.userId);
                                            // String message = 'Your Ride Accepted...';
                                            // String status = 'Accepted';
                                            //
                                            // FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).update({'bookingStatus' : status});
                                            //
                                            // FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                            //   callOnFcmApiSendPushNotifications(status,message,value.data()['token']);
                                            // });

                                          }
                                      ),

                                      RaisedButton(
                                          color: yellow,
                                          child: Text('Decline',style: TextStyle(fontWeight: FontWeight.bold),),
                                          onPressed: ()
                                          {
                                            String message = 'Your Ride Canceled!';
                                            String status = 'Declined';

                                            FirebaseFirestore.instance.collection(widget.bookingType).doc(widget.bookingId).update({'bookingStatus' : status});

                                            FirebaseFirestore.instance.collection('token').doc(widget.userId).get().then((value) {
                                              callOnFcmApiSendPushNotifications('','','','','',status,message,value.data()['token']);
                                            });
                                          }
                                      ),

                                    ],
                                  ) : SizedBox(),
                                  isInvoiceRequired
                                      ? Center(
                                    child: RaisedButton(
                                        color: yellow,
                                        child: Text('Check Invoice',style: TextStyle(fontWeight: FontWeight.bold),),
                                        onPressed: ()
                                        {

                                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>InvoiceScreenHourlyTransfer(
                                            passengerName: name,
                                            passengerEmail: email,
                                            phoneNumber: phone,
                                            bookingType: transferType,
                                            date: date,
                                            time: time,
                                            hours: hours.toString(),
                                            city: city,
                                            bookingId: widget.bookingId,
                                            vehicle: vehicle,
                                            cost: cost.toString(),
                                            invoiceNumber: invoiceNumber,

                                            // new code
                                            isBusinessCheck: isBusinessCheckPresent,
                                            businessName: businessName,
                                            businessContact: businessContact,
                                            billingAddress: billingAddress,
                                            state: state,
                                            country: country,
                                            businessPhone: businessPhone,
                                            businessEmail: businessEmail,

                                          ))
                                          );

                                        }
                                    ),
                                  )
                                      : SizedBox(),

                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    SizedBox(
                      height: 40,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }

  callOnFcmApiSendPushNotifications(name,contact,arrivalTime,vehicleNumber,comment,status,message,token) async {
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

