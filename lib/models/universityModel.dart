import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityModel {
  final String id;
  final Timestamp createdAt;
  final String name;
  final String helpNumber;
  UniversityModel({
    this.id,
    this.createdAt,
    this.name,
    this.helpNumber,
  });

  UniversityModel copyWith({
    String id,
    Timestamp createdAt,
    String name,
    String helpNumber,
  }) {
    return UniversityModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      helpNumber: helpNumber ?? this.helpNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'helpNumber': helpNumber,
    };
  }

  factory UniversityModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UniversityModel(
      id: map['id'],
      createdAt: map['createdAt'],
      name: map['name'],
      helpNumber: map['helpNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UniversityModel.fromJson(String source) => UniversityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UniversityModel(id: $id, createdAt: $createdAt, name: $name, helpNumber: $helpNumber)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UniversityModel &&
      o.id == id &&
      o.createdAt == createdAt &&
      o.name == name &&
      o.helpNumber == helpNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdAt.hashCode ^
      name.hashCode ^
      helpNumber.hashCode;
  }
}
