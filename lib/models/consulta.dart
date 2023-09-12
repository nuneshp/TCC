import 'package:cloud_firestore/cloud_firestore.dart';

class Consulta {
  String? id;
  String? queixa;
  String? diagnostico;
  String? nomeVeterinario;
  DateTime? data;
  DateTime? proximaData;
  double? custo;

  Consulta({this.id, this.data, this.proximaData, this.queixa, this.diagnostico, this.nomeVeterinario, this.custo});

  Consulta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    proximaData = (json['proximaData'] as Timestamp).toDate();
    queixa = json['queixa'];
    diagnostico = json['diagnostico'];
    nomeVeterinario = json['nomeVeterinario'];
    custo = json['custo'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['proximaData'] = this.proximaData;
    data['queixa']= this.queixa;
    data['diagnostico'] = this.diagnostico;
    data['nomeVeterinario'] = this.nomeVeterinario;
    data['custo'] = this.custo;
   
    return data;
  }
}