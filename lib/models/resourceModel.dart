import 'dart:convert';

import 'package:flutter/foundation.dart';

class ResourceModel {
  String id;
  String image;
  String title;
  String subject;
  List<String> tags;
  String link;
  String publisher;
  List<String> userImages;
  ResourceModel(
      {@required this.id,
      @required this.image,
      @required this.title,
      @required this.subject,
      @required this.tags,
      @required this.link,
      @required this.publisher,
      @required this.userImages});

  ResourceModel copyWith({
    String id,
    String image,
    String title,
    String subject,
    List<String> tags,
    String link,
    String publisher,
  }) {
    return ResourceModel(
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        subject: subject ?? this.subject,
        tags: tags ?? this.tags,
        link: link ?? this.link,
        publisher: publisher ?? this.publisher,
        userImages: userImages ?? this.userImages);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'subject': subject,
      'tags': tags,
      'link': link,
      'publisher': publisher,
      'userImages': userImages
    };
  }

  factory ResourceModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ResourceModel(
      id: map['id'],
      image: map['image'] ?? '',
      title: map['title'],
      subject: map['subject'],
      tags: List<String>.from(map['tags']),
      userImages: List<String>.from(map['userImages'] ?? []),
      link: map['link'],
      publisher: map['publisher'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResourceModel.fromJson(String source) =>
      ResourceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ResourceModel(id: $id, image: $image, title: $title, subject: $subject, tags: $tags, link: $link, publisher: $publisher)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ResourceModel &&
        o.id == id &&
        o.image == image &&
        o.title == title &&
        o.subject == subject &&
        listEquals(o.tags, tags) &&
        o.link == link &&
        o.publisher == publisher;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        image.hashCode ^
        title.hashCode ^
        subject.hashCode ^
        tags.hashCode ^
        link.hashCode ^
        publisher.hashCode;
  }
}
