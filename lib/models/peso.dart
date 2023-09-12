import 'package:cloud_firestore/cloud_firestore.dart';

class Peso {
  String? id;
  DateTime? data;
  double? peso;

  Peso({this.id,this.data, this.peso});

  Peso.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    peso = json['peso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['peso'] = this.peso;
    return data;
  }
}