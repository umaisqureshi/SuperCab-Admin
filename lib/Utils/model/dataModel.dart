import 'package:flutter/cupertino.dart';

class PostDataModel
{
  String description;
  String date;
  String time;
  String imageUrl;
  double fontsSize;
  String colorCode;
  bool isItalic;
  bool isBold;
  String fontFamily;

  
  PostDataModel({
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.imageUrl,
    @required this.isItalic,
    @required this.isBold,
    @required this.fontsSize,
    @required this.colorCode,
    @required this.fontFamily
  });
  
  Map<String,dynamic> toMap()
  {
    return 
    {
      'description' : this.description,
      'date' : this.date,
      'time' : this.time,
      'imageUrl' : this.imageUrl,
      'isItalic' : this.isItalic,
      'isBold' : this.isBold,
      'fontsSize' : this.fontsSize,
      'colorCode' : this.colorCode,
      'fontFamily' : this.fontFamily
    };
  }
  
}