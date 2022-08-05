import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CampusRequestModel {
  String requestId;
  String requesterId;
  String recieverId;
  String requesterImage;
  String requesterName;
  Timestamp date;
  CampusRequestModel({
    @required this.requestId,
    @required this.requesterId,
    @required this.recieverId,
    @required this.requesterImage,
    @required this.date,
    @required this.requesterName,
  });

  CampusRequestModel copyWith({
    String requestId,
    String requesterId,
    String recieverId,
    String requesterImage,
    Timestamp date,
    String requesterName,
  }) {
    return CampusRequestModel(
        requestId: requestId ?? this.requestId,
        requesterId: requesterId ?? this.requesterId,
        recieverId: recieverId ?? this.recieverId,
        requesterImage: requesterImage ?? this.requesterImage,
        date: date ?? this.date,
        requesterName: requesterName ?? this.requesterName);
  }

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'requesterId': requesterId,
      'recieverId': recieverId,
      'requesterImage': requesterImage,
      'date': date,
      'requesterName': requesterName
    };
  }

  factory CampusRequestModel.fromMap(Map<String, dynamic> map) {
    return CampusRequestModel(
        requestId: map['requestId'],
        requesterId: map['requesterId'],
        recieverId: map['recieverId'],
        requesterImage: map['requesterImage'],
        date: map['date'],
        requesterName: map['requesterName']);
  }

  String toJson() => json.encode(toMap());

  factory CampusRequestModel.fromJson(String source) =>
      CampusRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CampusRequestModel(requestId: $requestId, requesterId: $requesterId, recieverId: $recieverId, requesterImage: $requesterImage, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CampusRequestModel &&
        other.requestId == requestId &&
        other.requesterId == requesterId &&
        other.recieverId == recieverId &&
        other.requesterImage == requesterImage &&
        other.date == date;
  }

  @override
  int get hashCode {
    return requestId.hashCode ^
        requesterId.hashCode ^
        recieverId.hashCode ^
        requesterImage.hashCode ^
        date.hashCode;
  }
}
