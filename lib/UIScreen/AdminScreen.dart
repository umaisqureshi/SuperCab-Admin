import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shortid/shortid.dart';
import 'package:supercab_admin/UIScreen/AirportTransfer.dart';
import 'package:supercab_admin/UIScreen/AirportTransferDetails.dart';
import 'package:supercab_admin/UIScreen/CreatePost.dart';
import 'package:supercab_admin/UIScreen/Details.dart';
import 'package:supercab_admin/UIScreen/ExtraServicesDetails.dart';
import 'package:supercab_admin/UIScreen/HourlyTransfer.dart';
import 'package:supercab_admin/UIScreen/HourlyTransferDetails.dart';
import 'package:supercab_admin/UIScreen/LocalTransfer.dart';
import 'package:supercab_admin/UIScreen/PreBooking.dart';
import 'package:supercab_admin/UIScreen/drawer.dart';
import 'package:supercab_admin/UIScreen/prebooking_Details.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:supercab_admin/Utils/model/NotificationModel.dart';
import 'package:google_sign_in/google_sign_in.dart';




class AdminPanelHome extends StatefulWidget {
  @override
  _AdminPanelHomeState createState() => _AdminPanelHomeState();
}

class _AdminPanelHomeState extends State<AdminPanelHome> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future onSelectNotification(String payload) {
    NotificationModel model = NotificationModel.fromJson(json.decode(payload));
    if(model.type == 'booknow')
      {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return Details(bookingType: model.type, bookingId: model.id, userId: model.userId);
        }));
      }
    if(model.type == 'prebooking')
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return PreBookingDetails(bookingType: model.type, bookingId: model.id, userId: model.userId);
      }));
    }
    if(model.type == 'hourlyBooking')
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return HourlyTransferDetails(bookingType: model.type, bookingId: model.id, userId: model.userId);
      }));
    }
    if(model.type == 'airPortBooking')
    {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return AirportTransferDetails(bookingType: model.type, bookingId: model.id, userId: model.userId);
      }));
    }
    if(model.type == 'ExtraServices')
    {
      //print('Collection : '+model.type);
      //print('ID : '+model.id);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ServicesDetails(bookingType: model.type, bookingId: model.id, userId: model.userId);
      }));
    }
  }

  showNotification(NotificationModel model) async {
    var android = AndroidNotificationDetails(
        'SB', 'Super_Cab ', 'SuperCab',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, model.title, model.body, platform,
        payload: json.encode(model.toJson()));
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOs = IOSInitializationSettings();

    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var notification = NotificationModel(
            title: message['notification']['title'],
            body: message['notification']['body'],
            userId: message['data']['uid'],
            id: message['data']['id'],
            type: message['data']['type']);

        showNotification(notification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        var notification = NotificationModel(
            title: message['notification']['title'],
            body: message['notification']['body'],
            userId: message['data']['uid'],
            id: message['data']['id'],
            type: message['data']['type']);

        onSelectNotification(jsonEncode(notification.toJson()));
        },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        var notification = NotificationModel(
            title: message['notification']['title'],
            body: message['notification']['body'],
            userId: message['data']['uid'],
            id: message['data']['id'],
            type: message['data']['type']);

        onSelectNotification(jsonEncode(notification.toJson()));
      },
    );

    _firebaseMessaging.subscribeToTopic("superCab");

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 4,
        child: SafeArea(
          top: true,
          child: Scaffold(
            key: _scaffoldKey,
            //resizeToAvoidBottomPadding: false,
            drawer: SideDrawer(),
            appBar: AppBar(
              title: Text('Super Cab',style: TextStyle(color: yellow),),
              centerTitle: true,
              elevation: 0.0,
              actions:
              [
                // IconButton(icon: Icon(Icons.notification_important,color: Colors.white,),
                //     onPressed: sendEmail
                // ),
              ],
              leading: IconButton(
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
                icon: Icon(Icons.menu),
                color: yellow,
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: yellow,
                  isScrollable: true,
                  indicatorWeight: 2,
                  tabs:
                  [
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.car_rental, size: 15, color: yellow),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Local Transfer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.transfer_within_a_station_sharp,
                              size: 15, color: yellow),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'PreBooking',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.transfer_within_a_station_sharp,
                              size: 15, color: yellow),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Hourly Transfer',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        children: [
                          Icon(Icons.local_airport, size: 15, color: yellow),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Airport',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.black,
            ),
            body: TabBarView(children:
            [
              LocalTransfer(),
              PreBooking(),
              HourlyTransfer(),
              AirportTransfer(),
            ]),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ?? false;
  }

}







