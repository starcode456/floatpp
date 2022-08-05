import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  String userProfile;
  String userName;
  String comment;
  Timestamp commnetTime;
  bool isReply;
  List<ReplyModel> replies;
  CommentModel({
    this.id,
    this.userProfile,
    this.userName,
    this.comment,
    this.commnetTime,
    this.isReply,
    this.replies,
  });

  CommentModel copyWith({
    String id,
    String userProfile,
    String userName,
    String comment,
    Timestamp commnetTime,
    bool isReply,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      commnetTime: commnetTime ?? this.commnetTime,
      isReply: isReply ?? this.isReply,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userProfile': userProfile,
      'userName': userName,
      'comment': comment,
      'commnetTime': commnetTime,
      'isReply': isReply,
      'replies': []
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
        id: map['id'],
        userProfile: map['userProfile'],
        userName: map['userName'],
        comment: map['comment'],
        commnetTime: map['commnetTime'],
        isReply: map['isReply'],
        replies: List<ReplyModel>.from(map["replies"]?.map((item) {
              return ReplyModel.fromMap(item);
            }) ??
            []));
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommnetModel(id: $id, userProfile: $userProfile, userName: $userName, comment: $comment, commnetTime: $commnetTime, isReply: $isReply)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.id == id &&
        other.userProfile == userProfile &&
        other.userName == userName &&
        other.comment == comment &&
        other.commnetTime == commnetTime &&
        other.isReply == isReply;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userProfile.hashCode ^
        userName.hashCode ^
        comment.hashCode ^
        commnetTime.hashCode ^
        isReply.hashCode;
  }
}

class ReplyModel {
  String id;
  String commentId;
  String userProfile;
  String userName;
  String comment;
  Timestamp commnetTime;
  bool isReply;

  ReplyModel({
    this.id,
    this.userProfile,
    this.userName,
    this.comment,
    this.commnetTime,
    this.isReply,
    this.commentId,
  });

  ReplyModel copyWith({
    String id,
    String userProfile,
    String userName,
    String comment,
    Timestamp commnetTime,
    bool isReply,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      commnetTime: commnetTime ?? this.commnetTime,
      isReply: isReply ?? this.isReply,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userProfile': userProfile,
      'userName': userName,
      'comment': comment,
      'commnetTime': commnetTime,
      'isReply': isReply ?? false,
      'commentId': commentId,
    };
  }

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
        id: map['id'],
        userProfile: map['userProfile'],
        userName: map['userName'],
        comment: map['comment'],
        commnetTime: map['commnetTime'],
        isReply: map['isReply'] ?? false,
        commentId: map['commentId']);
  }

  String toJson() => json.encode(toMap());

  factory ReplyModel.fromJson(String source) =>
      ReplyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommnetModel(id: $id, userProfile: $userProfile, userName: $userName, comment: $comment, commnetTime: $commnetTime, isReply: $isReply)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReplyModel &&
        other.id == id &&
        other.userProfile == userProfile &&
        other.userName == userName &&
        other.comment == comment &&
        other.commnetTime == commnetTime &&
        other.isReply == isReply;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userProfile.hashCode ^
        userName.hashCode ^
        comment.hashCode ^
        commnetTime.hashCode ^
        isReply.hashCode;
  }
}
