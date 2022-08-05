import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubmittedResource {
  String title;
  String subject;
  String id;
  Timestamp dateSubmitted;
  SubmittedResource({this.title, this.subject, this.dateSubmitted, this.id});

  SubmittedResource copyWith({
    String title,
    String subject,
    Timestamp dateSubmitted,
    String id,
  }) {
    return SubmittedResource(
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dateSubmitted: dateSubmitted ?? this.dateSubmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'dateSubmitted': dateSubmitted,
      'id': id
    };
  }

  factory SubmittedResource.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return SubmittedResource(
        title: map['title'],
        subject: map['subject'],
        dateSubmitted: map['dateSubmitted'],
        id: map['id']);
  }

  String toJson() => json.encode(toMap());

  factory SubmittedResource.fromJson(String source) =>
      SubmittedResource.fromMap(json.decode(source));

  @override
  String toString() =>
      'SubmittedResource(title: $title, subject: $subject, dateSubmitted: $dateSubmitted)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SubmittedResource &&
        o.title == title &&
        o.subject == subject &&
        o.dateSubmitted == dateSubmitted;
  }

  @override
  int get hashCode =>
      title.hashCode ^ subject.hashCode ^ dateSubmitted.hashCode;
}
