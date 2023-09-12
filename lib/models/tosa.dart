import 'package:cloud_firestore/cloud_firestore.dart';

class Tosa {
  String? id;
  DateTime? data;
  DateTime? proximaData;
  double? custo;

  Tosa({ this.id, this.data, this.proximaData, this.custo});

  Tosa.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    data = (json['data'] as Timestamp).toDate();
    proximaData = (json['proximaData'] as Timestamp).toDate();
    custo = json['custo'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['proximaData'] = this.proximaData;
    data['custo'] = this.custo;
   
    return data;
  }
}