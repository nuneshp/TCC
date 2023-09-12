import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_hugo/databases/db_firestore.dart';
import 'package:tcc_hugo/models/postagem.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/services/storage.dart';

class PostagensRepository extends ChangeNotifier {
  List<Postagem> _lista = [];
  bool isLoading = true;
  
  late FirebaseFirestore db;
  late Storage storage;
  late AuthService auth;

  PostagensRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    _startFirestore();
    await _read();
  }

  _startFirestore() {
    db = DBFirestore.get();
    storage = Storage(auth: auth);
  }

   Future<void> _read() async {
    
      if (auth.usuario != null && _lista.isEmpty) {
      
        final snapshot = await db
            .collection('postagens')
            .doc('lista')
            .get();

        List<Postagem> lista = [];

        if (snapshot.exists) {
          if (snapshot.data()!.containsKey('postagens')) {
            List<dynamic> postagensData = snapshot.data()!['postagens'];
            lista = postagensData
                .map((postagemData) => Postagem.fromJson(postagemData))
                .toList();
          }
        }

        _lista = lista;
      }
    
    print("---->"+_lista.length.toString());

    isLoading = false;
    notifyListeners();
  }

  
   UnmodifiableListView<Postagem> get lista => UnmodifiableListView(_lista);

}
