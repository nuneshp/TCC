import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:tcc_hugo/services/auth_service.dart';

class Storage {
  late FirebaseStorage storage;
  late AuthService auth;

  Storage({required this.auth}) {
    _startFirestore();
  }

  _startFirestore() {
    storage = FirebaseStorage.instance;
  }

  deleteImage(String urlImage) async {
    await FirebaseStorage.instance
        .refFromURL(urlImage)
        .getDownloadURL()
        .then((value) async {
      await storage.refFromURL(urlImage).delete();
    });
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref =
          'images/img-${auth.usuario!.email.toString().hashCode}_${DateTime.now().toString().hashCode}.jpeg';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              contentType: "image/jpeg",
              customMetadata: {
                "user": auth.usuario!.email.toString(),
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }
}
