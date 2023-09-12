import 'package:cloud_firestore/cloud_firestore.dart';

class Lembrete {
  String? id;
  String? titulo;
  DateTime? data;
  DateTime? proximaData;

  Lembrete({this.id, this.data, this.proximaData, this.titulo});

  Lembrete.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    proximaData = (json['proximaData'] as Timestamp).toDate();
    titulo = json['titulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['proximaData'] = this.proximaData;
    data['titulo'] = this.titulo;

    return data;
  }
}
