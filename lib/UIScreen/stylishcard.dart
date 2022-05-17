
import 'package:flutter/material.dart';
import 'package:supercab_admin/Utils/constants.dart';

class StylishCard extends StatefulWidget {
  @override
  _StylishCardState createState() => _StylishCardState();
}

class _StylishCardState extends State<StylishCard> {


  Color color=Colors.white;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          height: 160,
          color: yellow,
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.text_format),
                  Icon(Icons.open_in_full),
                  Icon(
                    Icons.create,
                    color: Colors.green,
                  ),
                  Icon(Icons.format_align_center_outlined),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Font',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Size',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Color',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green),
                  ),
                  Text(
                    'Align',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                height: MediaQuery.of(context).size.height * 0.10,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,

                      decoration: BoxDecoration(
                          color: Colors.orangeAccent, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,

                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,

                      decoration: BoxDecoration(
                          color: Colors.pinkAccent, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.cyanAccent, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.purpleAccent, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.purple, shape: BoxShape.circle),
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.brown, shape: BoxShape.circle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
