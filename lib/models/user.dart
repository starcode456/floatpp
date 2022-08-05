import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_utils/time_parse.dart';

class UserModel {
  String userId;
  String documentID;
  num appVersionLocal;
  String email;
  String uni;
  String fullname;
  String profilepic;
  int gamesplayed;
  int gameswon;
  int points;
  bool isActive;
  bool isNotificationsEnabled;
  List<String> devTokens;
  DateTime timestampRegister;
  String timestampRegisterStr;
  DateTime timestampLastLogin;
  String timestampLastLoginStr;
  List<String> recentusers; 

  UserModel({
    this.appVersionLocal,
    this.userId,
    this.documentID,
    this.email,
    this.uni,
    this.gamesplayed,
    this.gameswon,
    this.recentusers,
    this.points,
    this.fullname,
    this.profilepic,
    this.isActive,
    this.devTokens,
    this.timestampRegister,
    this.isNotificationsEnabled,
    this.timestampRegisterStr,
    this.timestampLastLoginStr,
    this.timestampLastLogin,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gameswon'] = this.gameswon;
    data['recentusers'] = this.recentusers;
    data['timestampLastLogin'] = this.timestampLastLogin;
    data['timestampRegister'] = this.timestampRegister;
    data['points'] = this.points;
    data['profilepic'] = this?.profilepic;
    data['isNotificationsEnabled'] = this.isNotificationsEnabled;
    data['gamesplayed'] = this.gamesplayed;
    data['devTokens'] = this.devTokens;
    data['userId'] = this.userId;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['uni'] = this.uni;
    data['appVersionLocal'] = this.appVersionLocal;
    return data;
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    if (data != null) {
      return UserModel(
        documentID: doc.id,
        appVersionLocal: data['appVersionLocal'] ?? 0,
        userId: data['userId'] ?? '',
        gamesplayed: data['gamesplayed'] ?? 0,
        gameswon: data['gameswon'] ?? 0,
        points: data['points'] ?? 0,
        email: data['email'] ?? '',
        uni: data['uni'] ?? '',
        fullname: data['fullname'] ?? '',
        profilepic: data['profilepic'] ?? null,
        isActive: data['isActive'] ?? true,
        isNotificationsEnabled: data['isNotificationsEnabled'] ?? true,
        timestampRegisterStr:
            TimeParse.formatTimeToString(data['timestampRegister']),
        timestampLastLoginStr:
            TimeParse.formatTimeToString(data['timestampLastLogin']),
        devTokens: getListStringsFromDynamic(data['devTokens']),
        recentusers: getListStringsFromDynamic(data['recentusers']),
        timestampRegister: TimeParse.parseTime(data['timestampRegister']),
        timestampLastLogin: TimeParse.parseTime(data['timestampLastLogin']),
      );
    } else {
      return null;
    }
    
  }

  static List<dynamic> getListStringsFromDynamic(List data) {
    List<String> list = [];
    if (data != null) {
      data.forEach((val) {
        list.add(val.toString());
      });
    }
    return list;
  }
}

class UserRegister {
  String email;
  String password;
  String fullname;

  UserRegister({this.email = '', this.password = '', this.fullname = ''});
}
