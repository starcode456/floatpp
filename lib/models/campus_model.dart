import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CampusModel {
  String userId;
  List<CampusUser> campusUsers;
  CampusModel({
    @required this.userId,
    @required this.campusUsers,
  });

  CampusModel copyWith({
    String userId,
    List<CampusUser> campusUsers,
  }) {
    return CampusModel(
      userId: userId ?? this.userId,
      campusUsers: campusUsers ?? this.campusUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'campusUsers': campusUsers?.map((x) => x.toMap())?.toList(),
    };
  }

  factory CampusModel.fromMap(Map<String, dynamic> map) {
    return CampusModel(
      userId: map['userId'],
      campusUsers: List<CampusUser>.from(
          map['campusUsers']?.map((x) => CampusUser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CampusModel.fromJson(String source) =>
      CampusModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CampusModel(userId: $userId, campusUsers: $campusUsers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CampusModel &&
        other.userId == userId &&
        listEquals(other.campusUsers, campusUsers);
  }

  @override
  int get hashCode => userId.hashCode ^ campusUsers.hashCode;
}

///
///
///
class CampusUser {
  String userId;
  String userImage;
  String userName;
  CampusUser(
      {@required this.userId,
      @required this.userImage,
      @required this.userName});

  CampusUser copyWith({String userId, String userImage, String userName}) {
    return CampusUser(
        userId: userId ?? this.userId,
        userImage: userImage ?? this.userImage,
        userName: userName ?? this.userName);
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'userImage': userImage, 'userName': userName};
  }

  factory CampusUser.fromMap(Map<String, dynamic> map) {
    return CampusUser(
        userId: map['userId'],
        userImage: map['userImage'],
        userName: map['userName'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CampusUser.fromJson(String source) =>
      CampusUser.fromMap(json.decode(source));

  @override
  String toString() => 'CampusUser(userId: $userId, userImage: $userImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CampusUser &&
        other.userId == userId &&
        other.userImage == userImage;
  }

  @override
  int get hashCode => userId.hashCode ^ userImage.hashCode;
}
