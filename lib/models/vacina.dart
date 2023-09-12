import 'package:cloud_firestore/cloud_firestore.dart';

class Vacina {
  String? id;
  DateTime? data;
  DateTime? proximaData;
  String? categoria;
  String? marca;
  String? dose;
  String? lote;
  double? custo;

  Vacina({this.id, this.data, this.proximaData, this.categoria, this.marca, this.dose, this.lote, this.custo });

  Vacina.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    proximaData = (json['proximaData'] as Timestamp).toDate();
    categoria = json['categoria'];
    marca = json['marca'];
    dose = json['dose'];
    lote = json['lote'];
    custo = json['custo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['proximaData'] = this.proximaData;
    data['categoria'] = this.categoria;
    data['marca'] = this.marca;
    data['dose'] = this.dose;
    data['lote'] = this.lote;
    data['custo'] = this.custo;
    return data;
  }
}