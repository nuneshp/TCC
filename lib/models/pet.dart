import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tcc_hugo/models/peso.dart';

class Pet {
  String? id;
  String? nome;
  String? foto;
  String? raca;
  String? sexo;
  DateTime? nascimento;
  String? familia;
  // List<Peso>? listPeso;

  Pet(
      {this.id,
      this.nome,
      this.foto,
      this.raca,
      this.sexo,
      this.nascimento,
      this.familia});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
    raca = json['raca'];
    sexo = json['sexo'];
    nascimento = (json['nascimento'] as Timestamp).toDate();
    familia = json['familia'];
    // if (json['listPeso'] != null) {
    //   listPeso = [];
    //   json['listPeso'].forEach((peso) {
    //     listPeso!.add( Peso.fromJson(peso));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = nome;
    data['foto'] = foto;
    data['raca'] = raca;
    data['sexo'] = sexo;
    data['nascimento'] = nascimento;
    data['familia'] = familia;

    // if (listPeso != null) {
    //   data['listPeso'] = listPeso!.map((peso) => peso.toJson()).toList();
    // }
    return data;
  }
}
