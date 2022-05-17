import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:supercab_admin/UIScreen/stylishcard.dart';
import 'package:supercab_admin/Utils/constants.dart';
import 'package:supercab_admin/Utils/model/dataModel.dart';
import 'package:supercab_admin/Utils/model/textStylemodel.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  final descriptionController = TextEditingController();
  //Color textColor = white;
  int textColor = 0xffFFFFFF;
  double font_Size = 16;
  String font_Style = "Normal";

  //hhhh
  String font_FamilyStyle = "Montserrat";

  bool isCorrect;
  File sampleImage;
  String imageUrl;

  bool isItalic = false;
  bool isBold = false;
  bool isNormal = true;
  bool isBoldStyle = false;


  bool isMontserrat = false;
  bool isfontFamilySelection = false;
  bool isPacifico = true;
  bool isRobotoCondensed = false;

  double height = 160;

  var getList = [
    TextStyleModel(name: "Font", icon: Icons.text_format, isChecked: false),
    TextStyleModel(name: "Size", icon: (Icons.open_in_full), isChecked: false),
    TextStyleModel(name: "Color", icon: (Icons.create), isChecked: false),
    TextStyleModel(name: "Bold", icon: (Icons.done), isChecked: false),
  ];

  // final List<Color> colorList = <Color>[
  //
  //     //Colors.red,
  //   Colors.grey,
  //   Colors.orangeAccent,
  //   Colors.lightBlueAccent,
  //   Colors.pinkAccent,
  //   Colors.cyanAccent,
  //   Colors.green,
  //   Colors.deepPurple,
  //   Colors.purpleAccent,
  //   Colors.indigo,
  //   Colors.orange,
  //   Colors.purple,
  //   //Colors.brown
  // ];

  final List<int> colorList = <int>[
    0xffFF5733,
    0xff808080,
    0xffee9a00,
    0xffadd8e6,
    0xffda8388,
    0xff00FFFF,
    0xff008000,
    0xff3a243b,
    0xff800080,
    0xff4b0082,
    0xffFFA500,
    0xff800080,
    0xffA52A2A
  ];

  final List<double> fontSizeList = [14, 16, 18, 20, 22];
  final List<String> fontStyleList = ["Italic", "Bold", "Normal"];
  final List<String> fontFamilyList = ["Montserrat", "Pacifico", "RobotoCondensed"];

  bool isSize = false;
  bool isColor = true;

  void getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  Future<void> uploadStatusImage() async {
    var ref = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('Post Images');

    var timeKey = DateTime.now();

    firebase_storage.StorageUploadTask storageUploadTask =
        ref.child(timeKey.toString() + 'jpg').putFile(sampleImage);
    imageUrl = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('Image Url ----> ' + imageUrl);
  }

  void saveToFireStore() async {
    await uploadStatusImage();
    saveToFireStoreWithDescription();
  }

  void saveToFireStoreWithDescription() {
    String description = descriptionController.text;

    var dateAndTime = DateTime.now();
    var date = DateFormat('MMM d, yyyy').format(dateAndTime);
    var time = DateFormat('EEEE, hh: mm aaa').format(dateAndTime);

    print('Text Color' + textColor.toString());
    print('font Family : ' + font_FamilyStyle);

    PostDataModel postDataModel = PostDataModel(
        description: description,
        date: date,
        time: time,
        imageUrl: imageUrl,
        isItalic: isItalic,
        isBold: isBold,
        fontsSize: font_Size,
        fontFamily: font_FamilyStyle,
        colorCode: textColor.toString());

    FirebaseFirestore.instance
        .collection('Posts')
        .add(postDataModel.toMap())
        .then((value) {
      print('Post Id ---> : ' + value.id);
    }).then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
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
                      Center(
                        child: Text(
                          "Create Post",
                          style: TextStyle(color: white, fontSize: 17),
                        ),
                      ),
                      SizedBox()
                    ],
                  ),
                ),

                SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: sampleImage == null
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 1)),
                            height: 220,
                            child: Text(
                              'Pick Image',
                              style: TextStyle(color: white),
                            ),
                            alignment: Alignment.center,
                          )
                        : Image.file(
                            sampleImage,
                            fit: BoxFit.cover,
                            height: 220,
                            width: 350,
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  validator: (input) {
                    if (input.isEmpty)
                      return 'Required Field';
                    else
                      return null;
                  },
                  style: TextStyle(
                    color: Color(textColor),
                    fontSize: font_Size,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    fontWeight:
                        isBoldStyle ? FontWeight.bold : FontWeight.normal,
                    fontFamily: font_FamilyStyle,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: white),
                    filled: true,
                    fillColor: white.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: white, width: 2),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //  children:
                //  [
                //    Row(
                //      children: [
                //        Theme(
                //          data: ThemeData(unselectedWidgetColor: yellow),
                //          child: Checkbox(value: isItalic,
                //              checkColor: Colors.black,
                //              activeColor: yellow,
                //              focusColor: yellow,
                //              hoverColor: yellow,
                //              onChanged: (value)
                //              {
                //                setState(() {
                //                  isItalic = value;
                //                });
                //              }),
                //        ),
                //        SizedBox(width: 10,),
                //        Text('Italic',style: TextStyle(color: Colors.white),),
                //      ],
                //    ),
                //
                //    Row(
                //      children: [
                //        Theme(
                //          data: ThemeData(unselectedWidgetColor: yellow),
                //          child: Checkbox(value: isBold,
                //              checkColor: Colors.black,
                //              activeColor: yellow,
                //              focusColor: yellow,
                //              hoverColor: yellow,
                //              onChanged: (value)
                //              {
                //                setState(() {
                //                  isBold = value;
                //                });
                //              }),
                //        ),
                //        SizedBox(width: 10,),
                //        Text('Bold',style: TextStyle(color: Colors.white),),
                //      ],
                //    ),
                //  ],
                // ),
                SizedBox(
                  height: 20,
                ),
                customizeDescription(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    color: yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      saveToFireStore();
                    },
                    child: Text(
                      'Post',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget customizeDescription() {
    return Center(
      child: Card(
        child: Container(
          color: yellow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: getList
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          setState(() {
                            e.isChecked = true;

                            if (e.name == "Size") {
                              isSize = true;
                              isColor = false;
                              isBold = false;
                              isfontFamilySelection=false;
                            } else if (e.name == "Color") {
                              isSize = false;
                              isColor = true;
                              isBold = false;
                              isfontFamilySelection=false;

                            } else if (e.name == "Bold") {
                              isSize = false;
                              isColor = false;
                              isBold = true;
                              isfontFamilySelection=false;

                            }
                            else if (e.name == "Font") {
                              isSize = false;
                              isColor = false;
                              isBold = false;
                              isfontFamilySelection=true;

                            }

                            getList
                                .where((element) => element != e)
                                .forEach((ele) {
                              ele.isChecked = false;
                            });
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              e.icon,
                              color: e.isChecked ? Colors.white : Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              e.name,
                              style: TextStyle(
                                  color:
                                      e.isChecked ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                // height: MediaQuery.of(context).size.height * 0.10,
                child: isColor
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 20.0),
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: colorList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    textColor = colorList[index];
                                    //print(textColor.value.toString());
                                  });
                                },
                                child: Container(
                                  // width: MediaQuery.of(context).size.width * 0.2,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Color(colorList[index]),
                                      shape: BoxShape.circle),
                                ),
                              );
                            }),
                      )
                    : isSize
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: fontSizeList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        font_Size = fontSizeList[index];
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          fontSizeList[index].toString(),
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  );
                                }),
                          )
                        : isBold
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 20.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fontStyleList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            font_Style = fontStyleList[index];
                                            if (font_Style == "Normal") {
                                              isItalic = false;
                                              isBoldStyle = false;
                                              isNormal = true;
                                            } else if (font_Style == "Italic") {
                                              isItalic = true;
                                              //isBoldStyle = false;
                                              //isNormal = ;
                                            } else if (font_Style == "Bold") {
                                              //isItalic = true;
                                              isBoldStyle = true;
                                              //isNormal = ;
                                            }
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              fontStyleList[index].toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      );
                                    }),
                              )
                            : isfontFamilySelection
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 20.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: fontFamilyList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                font_FamilyStyle =
                                                    fontFamilyList[index];
                                                if (font_FamilyStyle ==
                                                    "Pacifico") {
                                                  isPacifico = true;
                                                  isRobotoCondensed = false;
                                                  isMontserrat = false;
                                                } else if (font_FamilyStyle ==
                                                    "Montserrat") {
                                                  isMontserrat = true;
                                                  //isBoldStyle = false;
                                                  //isNormal = ;
                                                } else if (font_FamilyStyle ==
                                                    "RobotoCondensed") {
                                                  //isItalic = true;
                                                  isRobotoCondensed = true;
                                                  //isNormal = ;
                                                }
                                              });
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: Text(
                                                  'Text',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: fontFamilyList[index]),
                                                )),
                                          );
                                        }),
                                  )
                                : SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
