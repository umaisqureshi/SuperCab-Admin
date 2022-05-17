import 'package:flutter/material.dart';


class NotificationModel
{
  String title;
  String body;
  String userId;
  String id;
  String type;

  NotificationModel({
    @required this.title,
    @required this.body,
    @required this.userId,
    @required this.id,
    @required this.type
});

  Map toJson() =>
      {
        'title' : title,
        'body' : body,
        'userId' : userId,
        'id' : id,
        'type' : type
      };

  NotificationModel.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        body = json['body'],
        userId = json['userId'],
        id = json['id'],
        type = json['type'];

}


