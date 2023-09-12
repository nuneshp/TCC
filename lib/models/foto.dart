import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tcc_hugo/models/peso.dart';

class Foto {
  String? id;
  String? legenda;
  String? foto;
  DateTime? data;

  Foto({this.id, this.legenda, this.foto, this.data});

  Foto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    legenda = json['legenda'];
    foto = json['foto'];
    data = (json['data'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['legenda'] = this.legenda;
    data['foto'] = this.foto;
    data['data'] = this.data;

    return data;
  }
}
