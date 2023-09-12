import 'package:cloud_firestore/cloud_firestore.dart';

class Postagem {
  String? id;
  String? titulo;
  String? subtitulo;
  String? descricao;
  DateTime? date;
  String? urlImage;

  Postagem(
      {this.id, this.titulo,
      this.subtitulo,
      this.descricao,
      this.date,
      this.urlImage,
      });

  Postagem.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    titulo = json['titulo'];
    subtitulo = json['subtitulo'];
    descricao = json['descricao'];
    date = (json['date'] as Timestamp).toDate();
    urlImage = json['urlImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['subtitulo'] = this.subtitulo;
    data['descricao'] = this.descricao;
    data['date'] = this.date;
    data['urlImage'] = this.urlImage;
    return data;
  }
}
