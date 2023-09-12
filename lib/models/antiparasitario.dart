import 'package:cloud_firestore/cloud_firestore.dart';

class Antiparasitario {
  String? id;
  DateTime? data;
  DateTime? proximaData;
  String? marca;
  double? custo;

  Antiparasitario({this.id, this.data, this.proximaData, this.marca, this.custo});

  Antiparasitario.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    proximaData = (json['proximaData'] as Timestamp).toDate();
    marca = json['marca'];
    custo = json['custo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['proximaData'] = this.proximaData;
    data['marca'] = this.marca;
    data['custo'] = this.custo;
    return data;
  }
}