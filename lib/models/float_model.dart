import 'package:cloud_firestore/cloud_firestore.dart';

class FloatModel {
  int words;
  int wordsCompleted;
  int wordstoday;
  int lastwords;
  int rivalwords;
  int average;
  int points;
  bool isBook;
  int rivalpoints;
  Timestamp due;
  String title;
  int notificationId;
  String owner;
  bool canupdate;
  String opponent;
  String rivalfloat;
  int state;
  Timestamp lastupdated;
  List<String> resourceId;

  FloatModel(
      {this.words,
      this.opponent,
      this.rivalfloat,
      this.wordstoday,
      this.lastwords,
      this.rivalwords,
      this.average,
      this.points,
      this.canupdate,
      this.rivalpoints,
      this.state,
      this.wordsCompleted,
      this.lastupdated,
      this.due,
      this.title,
      this.notificationId,
      this.owner,
      this.resourceId,
      this.isBook
      });

  FloatModel.fromJson(Map<String, dynamic> json) {
    words = json['words']?? 0;
    points = json['points'] ?? 0;
    lastwords = json['lastwords'] ?? 0;
    wordstoday = json['wordstoday']?? 0;
    rivalwords = json['rivalwords']??0;
    rivalpoints = json['rivalpoints']?? 0;
    average =  json['average'] ?? 0;
    canupdate = json['canupdate'] ?? false;
    wordsCompleted = json['wordsCompleted'] ??0;
    lastupdated = json['lastupdated'];
    isBook = json['book'] ?? false;
    due = json['due'];
    title = json['title'];
    notificationId = json['notificationId'];
    owner = json['owner'];
    opponent = json['opponent'] ?? null;
    rivalfloat = json['rivalfloat'] ?? null;
    state = json['state'] ?? null;
    resourceId =List.castFrom(json['resourceId']??[]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['words'] = this.words;
    data['points'] = this.points;
    data['wordstoday'] = this.wordstoday;
    data['lastwords'] = this.lastwords;
    data['rivalpoints'] = this.points;
    data['rivalwords'] = this.rivalwords;
    data['average'] = this.average;
    data['book'] = this.isBook;
    data['wordsCompleted'] = this.wordsCompleted;
    data['due'] = this.due;
    data['canupdate'] = this.canupdate;
    data['title'] = this.title;
    data['lastupdated'] = this.lastupdated;
    data['notificationId'] = this.notificationId;
    data['owner'] = this.owner;
    data['opponent'] = this.opponent;
    data['rivalfloat'] = this.rivalfloat;
    data['state'] = this.state;
    data['resourceId'] = this.resourceId;
    return data;
  }
}
