import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserShelfModel {
  String id;
  String userId;
  String emoji;
  String note;
  Timestamp dateAdded;
  UserShelfModel({
    @required this.id,
    @required this.userId,
    @required this.emoji,
    @required this.note,
    @required this.dateAdded,
  });

  UserShelfModel copyWith({
    String id,
    String userId,
    String emoji,
    String note,
    Timestamp dateAdded,
  }) {
    return UserShelfModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      note: note ?? this.note,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'emoji': emoji,
      'note': note,
      'dateAdded': dateAdded,
    };
  }

  factory UserShelfModel.fromMap(Map<String, dynamic> map) {
    return UserShelfModel(
      id: map['id'],
      userId: map['userId'],
      emoji: map['emoji'],
      note: map['note'],
      dateAdded: map['dateAdded'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserShelfModel.fromJson(String source) =>
      UserShelfModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserShelfModel(id: $id, userId: $userId, emoji: $emoji, note: $note, dateAdded: $dateAdded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserShelfModel &&
        other.id == id &&
        other.userId == userId &&
        other.emoji == emoji &&
        other.note == note &&
        other.dateAdded == dateAdded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        emoji.hashCode ^
        note.hashCode ^
        dateAdded.hashCode;
  }
}
