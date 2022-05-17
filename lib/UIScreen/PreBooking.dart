import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:supercab_admin/UIScreen/Local_Details.dart';
import 'package:supercab_admin/UIScreen/PreBookingDetails.dart';



class PreBooking extends StatefulWidget {
  @override
  _PreBookingState createState() => _PreBookingState();
}

class _PreBookingState extends State<PreBooking> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            child: Container(
              alignment: Alignment.center,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('prebooking').orderBy('timeStamp',descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot)
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
                    final list = querySnapshot.data.docs;
                    return Container(
                      //height: 465,
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemBuilder: (context,index)
                        {
                          //final data = querySnapshot.data;
                          var babySeat = list[index]['babySeat'];
                          var boosterSeat = list[index]['boosterSeat'];
                          var midNightPickUp = list[index]['midNightPickup'];
                         // var flightNumber = list[index]['flightnumber'];
                          var from = list[index]['from'];
                          var to = list[index]['to'];
                          var time = list[index]['time'];
                          var cost = list[index]['tripcost'];
                          var date = list[index]['day'];
                          var vehicle = list[index]['vehicle'];
                          var transferType = list[index]['transferType'];
                          var email = list[index]['email'];
                          var phone = list[index]['phone'];
                          var comments = list[index]['comments'];
                          var name = list[index]['name'];
                          var bookingStatus = list[index]['bookingStatus'];

                          return GestureDetector(
                            onTap: ()
                            {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PreBookingItemDetails(bookingType: 'prebooking',bookingId: list[index].id,userId: list[index].data()['currentUserID'],)));
                            },
                            child: Container(
                              //height: 465,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              margin: EdgeInsets.symmetric(horizontal: 0),
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
                                        Text('PreBooking', style: TextStyle(fontSize: 17, color: Colors.white),),
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
                                    Text('Baby Seat : $babySeat',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),
                                    Text('Booster Seat : $boosterSeat',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),
                                    Text('MidNight Pickup : $midNightPickUp',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

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
                                    Text('Comments : $comments',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(height: 10,),
                                    Text('Booking Status : $bookingStatus',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                    SizedBox(width: 5,),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: list.length,
                      ),
                    );
                  }
                },
              ),
            ),
          )),
    );
  }
}
