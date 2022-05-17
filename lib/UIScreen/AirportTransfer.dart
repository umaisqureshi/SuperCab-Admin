import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/DataSource/Source.dart';
import 'package:supercab_admin/UIScreen/AirportTransferDetails.dart';
import 'package:supercab_admin/UIScreen/Airport_Details.dart';
import 'package:supercab_admin/UIScreen/CreatePost.dart';
import 'package:supercab_admin/Utils/constants.dart';


class AirportTransfer extends StatefulWidget {
  @override
  _AirportTransferState createState() => _AirportTransferState();
}

class _AirportTransferState extends State<AirportTransfer> {

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
                stream: FirebaseFirestore.instance.collection('airPortBooking').orderBy('timeStamp',descending: true).snapshots(),
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
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: ListView.builder(
                        itemBuilder: (context,index)
                        {

                          var from = list[index]['from'];
                          var airportIndex = list[index]['airport'];
                          var babySeat = list[index]['babySeat'];
                          var boosterSeat = list[index]['boosterSeat'];
                          var midNightPickUp = list[index]['midNightPickup'];
                          var time = list[index]['time'];
                          var cost = list[index]['tripCost'];
                          var date = list[index]['day'];
                          var vehicle = list[index]['vehicle'];
                          var transferType = list[index]['transferType'];
                          var bookingStatus = list[index]['bookingStatus'];
                          var airPortTransferType = list[index]['airportTransferType'];

                          String airport;

                          if(airPortTransferType == 'cityToAirport')
                          {
                            airport = airPortNamesList(context)[airportIndex].name;
                          }
                          else
                          {
                            airport = airPortNamesListForCity(context)[airportIndex].name;
                          }


                          return GestureDetector(
                            onTap: ()
                            {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>AirportDetails(bookingType: 'airPortBooking',bookingId: list[index].id,userId: list[index].data()['currentUserID'],)));
                            },
                            child: Container(
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
                                      Text('Booking Type : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Text(transferType, style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),
                                  SizedBox(height: 10,),

                                  airPortTransferType == 'cityToAirport'
                                      ? Text('From :  $from',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),)
                                      : Text('To :  $from',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                  SizedBox(height: 10,),

                                  Text('Airport:  $airport',maxLines: 3,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 17, color: Colors.white),),

                                  SizedBox(height: 10,),
                                  Row(
                                    children:
                                    [
                                      Text('Baby Seat : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Text(babySeat.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children:
                                    [
                                      Text('Booster Seat : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Text(boosterSeat.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children:
                                    [
                                      Text('MidNightPickUp : ', style: TextStyle(fontSize: 17, color: Colors.white),),
                                      SizedBox(width: 5,),
                                      Text(midNightPickUp.toString(), style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),
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
                                      Text(bookingStatus, style: TextStyle(fontSize: 17, color: Colors.white),),
                                    ],
                                  ),

                                ],
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
