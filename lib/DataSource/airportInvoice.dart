import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mailer/mailer.dart' as mailer;

import 'package:supercab_admin/Utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceScreenAirportTransfer extends StatefulWidget {

  String passengerName;
  String passengerEmail;
  String phoneNumber;
  String date;
  String time;
  String airport;
  String from;
  String cost;
  String bookingType;
  String vehicle;
  String bookingId;
  bool isAirportToCity;
  var invoiceNumber;

  // String vehicleNumber;
  bool isBusinessCheck;
  var businessName,businessContact,billingAddress,state,country,businessPhone,businessEmail;

  InvoiceScreenAirportTransfer({
    @required this.passengerName,
    @required this.passengerEmail,
    @required this.phoneNumber,
    @required this.bookingType,
    @required this.date,
    @required this.time,
    @required this.from,
    @required this.airport,
    @required this.cost,
    @required this.vehicle,
    @required this.bookingId,
    @required this.isAirportToCity,
    @required this.invoiceNumber,

    //@required this.vehicleNumber,

    @required this.isBusinessCheck,
    @required this.businessName,
    @required this.businessContact,
    @required this.billingAddress,
    @required this.state,
    @required this.country,
    @required this.businessPhone,
    @required this.businessEmail,

  });

  @override
  _InvoiceScreenAirportTransferState createState() => _InvoiceScreenAirportTransferState();
}

class _InvoiceScreenAirportTransferState extends State<InvoiceScreenAirportTransfer> {


  Uint8List _imageFile;
  //var invoiceNumber = 0;
  String invoiceDate;

  int gstValue = 0;
  int remainingBill = 0;

  String termsAndConditionsLink = "https://supercab.com.au/support/terms-conditions/";

  ScreenshotController screenshotController = ScreenshotController();

  takeScreenShot()
  {
    _imageFile = null;
    screenshotController.capture().then((Uint8List image) async {
      print("Capture Done");
      setState(() {
        _imageFile = image;
      });
      final result = await ImageGallerySaver.saveImage(image).then((value)
      {
        print("File Saved to Gallery");

        File file = File(value['filePath'].toString().replaceAll("file://", ""));
        //print(value['filePath'].toString());
        sendEmail(file);
        //send(value['filePath'].toString().replaceAll("file://", ""));
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  sendEmail(path) async
  {
    try
    {
      // GoogleSignInAccount googleUser = await googleSignIn.signIn();
      // GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // print('**********' + googleUser.email.toString() + '*************');
      //final smtpServer = gmailRelaySaslXoauth2(email, accessToken);

      String username = 'SuperCabaus@gmail.com'; // 'nadeemszd867897@gmail.com';
      String password =  'Supercab123@'; //'************';

      final smtpServer = gmail(username, password);

      // Create our message.
      final message = mailer.Message()
        ..from = mailer.Address(username, widget.passengerName)
        ..recipients.add(widget.passengerEmail) // ahsanrazapk92@gmail.com
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
        ..attachments.add(mailer.FileAttachment(path))
        ..subject = 'New Mail from SuperCab :: 😀 :: ${DateTime.now()}'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = "<h1>Alert</h1>\n<p>Hi! your booking get response</p>";

      try {
        final sendReport = await mailer.send(message, smtpServer).then((value)
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Invoice email is sent to User',
              style: TextStyle(color: white),
            ),
          ));
          Navigator.of(context).pop();
        });
        print('Message sent: ' + sendReport.toString());
      } on mailer.MailerException catch (e) {
        print('Message not sent.' + e.toString());
        // for (var p in e.problems) {
        //   print('Problem: ${p.code}: ${p.msg}');
        // }
      }

    }
    catch(error)
    {
      print(error.toString());
    }

  }

  Future<void> send(path) async {

    final Email email = Email(
      body: 'SuperCab Billing Invoice',
      subject: 'SuperCab Invoice',
      recipients: [widget.passengerEmail],
      attachmentPaths: [path],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email).then((value)
      {
        print('Email is Sent');
        String status = 'Send';
        platformResponse = 'Invoice email sent to Passenger';

        FirebaseFirestore.instance.collection('airPortBooking').doc(widget.bookingId).update({'invoiceStatus' : status}).then((value)
        {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });

      });
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );

  }

  void getCurrentDateAndTime() {
    var dateAndTime = DateTime.now().toString();
    var date = DateTime.parse(dateAndTime);
    //var dateFormat = new DateFormat('MMM d,yyyy');
    invoiceDate = "${date.day}/${date.month}/${date.year}";
    //invoiceDate = dateFormat.format(dateAndTime);
  }

  void calculateGST()
  {
    int gstPercentage = 10;
    int bill = int.parse(widget.cost);
    gstValue = ((gstPercentage / 100) * bill).toInt();
    remainingBill = bill - gstValue;
    //print('****** GST Value : ' + gstValue.toString());
    //print('****** Total Bill : ' + remainingBill.toString());
  }

  @override
  void initState() {
    super.initState();

    getCurrentDateAndTime();
    // var rng = new Random();
    // invoiceNumber = rng.nextInt(900000) + 100000;
    //print('*********** Invoice Number : ' + invoiceNumber.toString());
    calculateGST();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: FlutterTicketWidget(
                  width: 350.0,
                  height: widget.isBusinessCheck ? 1050.0 : 1250,
                  isCornerRounded: true,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                          [
                            Container(
                              height : 120,
                              width: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/icons/mainLogo.png'),
                                  )
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children:
                                  [
                                    Text('Invoice No. ',style: TextStyle(color: Colors.grey),),
                                    SizedBox(width: 5,),
                                    Text('#' + widget.invoiceNumber.toString()),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children:
                                  [
                                    Text('Invoice Date.',style: TextStyle(color: Colors.grey),),
                                    SizedBox(width: 5,),
                                    Text(invoiceDate.toString()),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Container(
                                  padding: EdgeInsets.only(top: 5,bottom: 5,left: 5,right: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black,width: 0.5)
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Total Amount : ',style: TextStyle(color: Colors.grey),),
                                      Text('\$ ${widget.cost}')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'ESTEEM TRAVEL SERVICE PVT LTD',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [
                              Row(
                                children:
                                [
                                  Text('ACN - ',style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 2,),
                                  Text('645 713 355'),
                                ],
                              ),
                              SizedBox(height: 8,),

                              Row(
                                children:
                                [
                                  Text('EMAIL - ',style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 2,),
                                  Text('Support@Supercab.com.au'),
                                ],
                              ),
                              SizedBox(height: 8,),

                              Row(
                                children:
                                [
                                  Text('PH - ',style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 2,),
                                  Text('1300 734 442'),
                                ],
                              ),
                              SizedBox(height: 8,),

                              Row(
                                children:
                                [
                                  Text('WEB - ',style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 2,),
                                  Text('https://www.supercab.com.au'),
                                ],
                              ),
                              SizedBox(height: 8,),

                            ],
                          ),
                        ),

                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Bill To',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: EdgeInsets.only(left: 12,right: 12,top: 5,bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:
                                [

                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:
                                      [
                                        Text('Name',style: TextStyle(color: Colors.grey),),
                                        SizedBox(height: 2,),
                                        Text('${widget.passengerName}'),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:
                                      [
                                        Text('Phone No',style: TextStyle(color: Colors.grey),),
                                        SizedBox(height: 2,),
                                        Text(widget.phoneNumber.toString()),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 8,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  Text('Email',style: TextStyle(color: Colors.grey),),
                                  SizedBox(height: 2,),
                                  Text('${widget.passengerEmail}'),
                                ],
                              ),
                              SizedBox(height: 8,),
                              widget.isBusinessCheck == false
                                  ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:
                                    [
                                      widget.businessName == "" ? SizedBox() :
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text('Business Name',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 2,),
                                            Text('${widget.businessName}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children:
                                    [
                                      widget.businessContact == "" ? SizedBox() :
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text('Contact Name',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 2,),
                                            Text(widget.businessContact.toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:
                                    [
                                      widget.businessPhone == "" ? SizedBox() :
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text('Company Contact Number',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 2,),
                                            Text('${widget.businessPhone}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children:
                                    [
                                      widget.businessEmail == "" ? SizedBox() :
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text('Company Contact Email',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 2,),
                                            Text(widget.businessEmail.toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:
                                    [
                                      widget.billingAddress == "" ? SizedBox() :
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text('Billing Address',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 2,),
                                            Text('${widget.billingAddress}'),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              )
                                  : SizedBox()
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Booking Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              ticketDetailsWidget(
                                  'Passenger', widget.passengerName, 'Booking Type', widget.bookingType),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 33.0),
                                child: ticketDetailsWidget(
                                    'Date', widget.date, 'Time', widget.time),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  'Trip Details',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 0),
                                width: MediaQuery.of(context).size.width,
                                child: widget.isAirportToCity
                                    ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:
                                  [
                                    Container(
                                      //color: Colors.yellowAccent,
                                      height:100,
                                      width: 140,
                                      child: Text('From : ${widget.airport}',maxLines: 6,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w500),),
                                    ),
                                    SizedBox(width: 35,),
                                    Container(
                                      //color: Colors.green,
                                      height:100,
                                      width: 105,
                                      child: Text('To : ${widget.from}',maxLines: 6,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w500),),
                                    ),
                                  ],
                                )
                                    : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:
                                  [
                                    Container(
                                      //color: Colors.yellowAccent,
                                      height:100,
                                      width: 140,
                                      child: Text('From : ${widget.from}',maxLines: 6,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w500),),
                                    ),
                                    SizedBox(width: 35,),
                                    Container(
                                      //color: Colors.green,
                                      height:100,
                                      width: 105,
                                      child: Text('To : ${widget.airport}',maxLines: 6,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.w500),),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Text('Amount',style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                  [
                                    SizedBox(height: 4,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                      [
                                        Text('Bill Amount - ',style: TextStyle(color: Colors.grey),),
                                        Text('\$ '+remainingBill.toString())
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                      [
                                        Text('GST (10%) - ',style: TextStyle(color: Colors.grey),),
                                        Text('\$ '+gstValue.toString())
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    // Row(
                                    //   mainAxisSize: MainAxisSize.min,
                                    //   children:
                                    //   [
                                    //     Text('MyCash/Promo/Discount - ',style: TextStyle(color: Colors.grey),),
                                    //     Text('')
                                    //   ],
                                    // ),
                                    // SizedBox(height: 4,),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                      [
                                        Text('Total - ',style: TextStyle(color: Colors.grey),),
                                        Text('\$ ${widget.cost}')
                                      ],
                                    ),

                                  ],
                                ),
                              ),

                              SizedBox(height: 25,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:
                                [
                                  Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width * 0.45,
                                    decoration: BoxDecoration(
                                      //color: Colors.green,
                                        image: DecorationImage(
                                          image: AssetImage('assets/icons/safe_payment.png'),
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 120,
                                    width: 140,
                                    //color: Colors.green,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text('Terms & Conditions'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              children: <TextSpan>
                                              [
                                                TextSpan(text: "https://supercab.com.au/...",
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset: Offset(3.0, 3.0),
                                                          blurRadius: 2.0,
                                                          color: Color.fromARGB(35, 0, 0, 0),
                                                        ),
                                                        Shadow(
                                                          offset: Offset(3.0, 3.0),
                                                          blurRadius: 8.0,
                                                          color: Color.fromARGB(35, 0, 0, 35),
                                                        ),
                                                      ],
                                                    ),
                                                    recognizer: TapGestureRecognizer()..onTap = () async{
                                                      if(await canLaunch(termsAndConditionsLink))
                                                      {
                                                        await launch(termsAndConditionsLink);
                                                      }
                                                      else
                                                      {
                                                        throw 'Could not lauch $termsAndConditionsLink';
                                                      }
                                                    }
                                                )
                                              ]
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: 10,),


                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
                        //   child: Container(
                        //     width: 250.0,
                        //     height: 60.0,
                        //     decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //             image: AssetImage('assets/icons/barcode.png'),
                        //             fit: BoxFit.cover)),
                        //   ),
                        // ),
                        // Padding(
                        //   padding:
                        //   const EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
                        //   child: Text(
                        //     '9824 0972 1742 1298',
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // )

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              Center(
                child: SizedBox(
                  width: 300,
                  child: RaisedButton(
                    onPressed: () async
                    {
                      if(await Permission.storage.isGranted)
                      {
                        takeScreenShot();
                      }
                      else
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: yellow,
                                title: Center(child: Text('SuperCab',style: TextStyle(color: Colors.black),)),
                                content: Text('Storage Permission is Required',style: TextStyle(color: Colors.black),),
                                actions:
                                [
                                  FlatButton(
                                      onPressed: () async
                                      {
                                        await Permission.storage.request().isGranted;
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Allow',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                  ),
                                  FlatButton(
                                      onPressed: () async
                                      {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                  ),
                                ],
                              );
                            }
                        );
                      }
                    },
                    color: Colors.amber,
                    child: Text('Send',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc, String secondTitle, String secondDesc) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),


              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  child: Text(
                    firstDesc,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>
            [
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}