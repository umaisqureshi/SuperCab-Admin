
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supercab_admin/Utils/constants.dart';




class Services extends StatefulWidget {

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          // height: 750,
          // width: MediaQuery.of(context).size.width,
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
                            "All Services",
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('ExtraServices').snapshots(),
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
                              height: 520,
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              child: ListView.builder(
                                itemBuilder: (context,index)
                                {

                                  var email = list[index]['email'];
                                  var name = list[index]['name'];
                                  var phone = list[index]['phone'];
                                  var date = list[index]['day'];
                                  var time = list[index]['time'];
                                  var comment = list[index]['information'];
                                  var isLimo = list[index]['Limo'];
                                  var isBus = list[index]['Bus'];
                                  var isWedding = list[index]['Wedding'];
                                  var isTour = list[index]['Tours'];
                                  var request = list[index]['requestStatus'];


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
                                },
                                itemCount: list.length,
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
        )
    );

  }

}




