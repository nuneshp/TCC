import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:tcc_hugo/databases/db_firestore.dart';

import 'package:tcc_hugo/services/auth_service.dart';

class DevicesService extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  late String? token;

  DevicesService({required this.auth}) {
    _initialize();
  }

  _initialize() async {
    db = DBFirestore.get();
    token = await FirebaseMessaging.instance.getToken();
  }

  Future<void> setToken() async {
    try {
      await db.collection('devices').doc('lista').set({
        auth.usuario!.uid: FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));

      print('Token salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar o token: $e');
    }
  }

  Future<void> removeToken() async {
    try {
      await db.collection('devices').doc('lista').update(
        {
          auth.usuario!.uid: FieldValue.arrayRemove([token])
        },
      );
      print("Token remodivo com sucesso");
    } catch (e) {
      print('Erro ao remover o token: $e');
    }
  }
}
