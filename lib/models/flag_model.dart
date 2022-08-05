import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:float/models/comment_model.dart';
import 'package:flutter/material.dart';

class FlagModel {
  final String flagId;
  final String commentText;
  final String resourceId;
  final bool isReply;
  final String commentId;
  final Timestamp date;
  final ReplyModel replyModel;
  final String subject;
  FlagModel({
    @required this.flagId,
    @required this.commentText,
    @required this.resourceId,
    @required this.isReply,
    @required this.commentId,
    @required this.date,
    @required this.replyModel,
    @required this.subject,
  });

  FlagModel copyWith({
    String flagId,
    String commentText,
    String resourceId,
    bool isReply,
    String commentId,
    Timestamp date,
    ReplyModel replyModel,
    String subject,
  }) {
    return FlagModel(
      flagId: flagId ?? this.flagId,
      commentText: commentText ?? this.commentText,
      resourceId: resourceId ?? this.resourceId,
      isReply: isReply ?? this.isReply,
      commentId: commentId ?? this.commentId,
      date: date ?? this.date,
      replyModel: replyModel ?? this.replyModel,
      subject: subject ?? this.subject,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'flagId': flagId,
      'commentText': commentText,
      'resourceId': resourceId,
      'isReply': isReply,
      'commentId': commentId,
      'date': date,
      'replyModel': replyModel?.toMap(),
      'subject': subject,
    };
  }

  factory FlagModel.fromMap(Map<String, dynamic> map) {
    return FlagModel(
      flagId: map['flagId'],
      commentText: map['commentText'],
      resourceId: map['resourceId'],
      isReply: map['isReply'],
      commentId: map['commentId'],
      date: map['date'],
      replyModel: ReplyModel.fromMap(map['replyModel']),
      subject: map['subject'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FlagModel.fromJson(String source) =>
      FlagModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FlagModel(flagId: $flagId, commentText: $commentText, resourceId: $resourceId, isReply: $isReply, commentId: $commentId, date: $date, replyModel: $replyModel, subject: $subject)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlagModel &&
        other.flagId == flagId &&
        other.commentText == commentText &&
        other.resourceId == resourceId &&
        other.isReply == isReply &&
        other.commentId == commentId &&
        other.date == date &&
        other.replyModel == replyModel &&
        other.subject == subject;
  }

  @override
  int get hashCode {
    return flagId.hashCode ^
        commentText.hashCode ^
        resourceId.hashCode ^
        isReply.hashCode ^
        commentId.hashCode ^
        date.hashCode ^
        replyModel.hashCode ^
        subject.hashCode;
  }
}
