import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class AvaliacaoService extends ChangeNotifier {
  late SharedPreferences prefs;
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;
  late bool avaliado;
  bool isLoading = true;

  AvaliacaoService({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    _startFirestore();
  }

  _startFirestore() async{
    prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("avaliado") && prefs.getBool("avaliado") != null) {
      avaliado = prefs.getBool("avaliado")!;
    } else {
      avaliado = false;
    }

    db = DBFirestore.get();
    isLoading = false;
    notifyListeners();
  }

  set(List<dynamic> avaliacao) async {
    try {
      final collection = db.collection('avaliacao/');

      // Criar o objeto Batch
      final batch = db.batch();
      final Ref = collection.doc("dados");
      batch.set(
          Ref, {"${auth.usuario!.email}": avaliacao}, SetOptions(merge: true));

      await batch.commit();
      prefs.setBool("avaliado", true).then((value) => avaliado = true);
    } catch (e) {}
  }
}
